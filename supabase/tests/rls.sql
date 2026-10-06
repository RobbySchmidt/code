-- Prüft die Zugriffsregeln. Alles läuft in einer Transaktion und wird zurückgerollt.
-- Erfolg: Die letzte Abfrage liefert 'rls ok'. Jede verletzte Regel bricht mit einer Meldung ab.
begin;

do $$
declare
  user_a uuid := gen_random_uuid();
  user_b uuid := gen_random_uuid();
  open_course bigint;
  draft_course bigint;
  draft_id bigint;
  public_id bigint;
  hidden_id bigint;
  n integer;
begin
  insert into auth.users (id, instance_id, aud, role, email) values
    (user_a, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls-a@example.test'),
    (user_b, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls-b@example.test');

  insert into public.courses (slug, title, summary, position, published) values
    ('rls-test-open', 'Offen', 'x', 900001, true),
    ('rls-test-draft', 'Entwurf', 'x', 900002, false);
  select id into open_course from public.courses where slug = 'rls-test-open';
  select id into draft_course from public.courses where slug = 'rls-test-draft';

  insert into public.lessons (course_id, slug, title, summary, position, section, content, published) values
    (open_course, 'rls-test-draft', 'Entwurf', 'x', 1, 'start', 'x', false),
    (open_course, 'rls-test-public', 'Öffentlich', 'x', 2, 'start', 'x', true),
    -- Derselbe Adressteil in einem zweiten Kurs muss erlaubt sein.
    (draft_course, 'rls-test-public', 'Versteckt', 'x', 1, 'start', 'x', true);
  select id into draft_id from public.lessons where course_id = open_course and slug = 'rls-test-draft';
  select id into public_id from public.lessons where course_id = open_course and slug = 'rls-test-public';
  select id into hidden_id from public.lessons where course_id = draft_course and slug = 'rls-test-public';

  insert into public.lesson_progress (user_id, lesson_id) values (user_b, public_id);
  insert into public.course_state (user_id, course_id, last_lesson_id) values (user_b, open_course, public_id);

  -- Unangemeldet
  perform set_config('request.jwt.claims', '{"role":"anon"}', true);
  set local role anon;

  select count(*) into n from public.courses where slug = 'rls-test-draft';
  assert n = 0, 'anon sieht einen unveröffentlichten Kurs';
  select count(*) into n from public.courses where slug = 'rls-test-open';
  assert n = 1, 'anon sieht einen veröffentlichten Kurs nicht';

  select count(*) into n from public.lessons where id = draft_id;
  assert n = 0, 'anon sieht eine unveröffentlichte Lektion';
  select count(*) into n from public.lessons where id = public_id;
  assert n = 1, 'anon sieht eine veröffentlichte Lektion nicht';
  select count(*) into n from public.lessons where id = hidden_id;
  assert n = 0, 'anon sieht eine Lektion eines unveröffentlichten Kurses';

  begin
    update public.courses set title = 'geändert' where slug = 'rls-test-open';
    get diagnostics n = row_count;
    assert n = 0, 'anon konnte einen Kurs ändern';
  exception when insufficient_privilege then null;
  end;

  begin
    update public.lessons set title = 'geändert' where id = public_id;
    get diagnostics n = row_count;
    assert n = 0, 'anon konnte eine Lektion ändern';
  exception when insufficient_privilege then null;
  end;

  begin
    select count(*) into n from public.lesson_progress;
    assert n = 0, 'anon sieht Fortschritt';
  exception when insufficient_privilege then null;
  end;

  begin
    select count(*) into n from public.course_state;
    assert n = 0, 'anon sieht Kursstände';
  exception when insufficient_privilege then null;
  end;

  -- Angemeldet als Nutzer A
  perform set_config('request.jwt.claims', json_build_object('sub', user_a, 'role', 'authenticated')::text, true);
  set local role authenticated;

  select count(*) into n from public.courses where slug = 'rls-test-draft';
  assert n = 0, 'Nutzer sieht einen unveröffentlichten Kurs';
  select count(*) into n from public.lessons where id in (draft_id, hidden_id);
  assert n = 0, 'Nutzer sieht eine unveröffentlichte Lektion oder eine Lektion eines unveröffentlichten Kurses';

  select count(*) into n from public.lesson_progress;
  assert n = 0, 'A sieht fremden Fortschritt';
  select count(*) into n from public.course_state;
  assert n = 0, 'A sieht einen fremden Kursstand';

  begin
    insert into public.lesson_progress (user_id, lesson_id) values (user_b, draft_id);
    assert false, 'A konnte Fortschritt für B anlegen';
  exception when insufficient_privilege then null;
  end;

  delete from public.lesson_progress where user_id = user_b;
  get diagnostics n = row_count;
  assert n = 0, 'A konnte Fortschritt von B löschen';

  update public.course_state set last_lesson_id = null where user_id = user_b;
  get diagnostics n = row_count;
  assert n = 0, 'A konnte den Kursstand von B ändern';

  begin
    insert into public.course_state (user_id, course_id, last_lesson_id) values (gen_random_uuid(), open_course, public_id);
    assert false, 'A konnte einen fremden Kursstand anlegen';
  exception when insufficient_privilege then null;
  end;

  insert into public.lesson_progress (user_id, lesson_id) values (user_a, public_id);
  select count(*) into n from public.lesson_progress;
  assert n = 1, 'A sieht den eigenen Fortschritt nicht';

  insert into public.course_state (user_id, course_id, last_lesson_id) values (user_a, open_course, public_id);
  update public.course_state set last_lesson_id = null where user_id = user_a;
  get diagnostics n = row_count;
  assert n = 1, 'A konnte den eigenen Kursstand nicht ändern';

  begin
    delete from public.course_state where user_id = user_a;
    get diagnostics n = row_count;
    assert n = 0, 'A konnte den eigenen Kursstand löschen';
  exception when insufficient_privilege then null;
  end;

  delete from public.lesson_progress where user_id = user_a;
  get diagnostics n = row_count;
  assert n = 1, 'A konnte den eigenen Fortschritt nicht löschen';

  reset role;
end $$;

rollback;

select 'rls ok' as result;
