-- Prüft die Zugriffsregeln. Alles läuft in einer Transaktion und wird zurückgerollt.
-- Erfolg: Die letzte Abfrage liefert 'rls ok'. Jede verletzte Regel bricht mit einer Meldung ab.
begin;

do $$
declare
  user_a uuid := gen_random_uuid();
  user_b uuid := gen_random_uuid();
  draft_id bigint;
  public_id bigint;
  n integer;
begin
  insert into auth.users (id, instance_id, aud, role, email) values
    (user_a, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls-a@example.test'),
    (user_b, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls-b@example.test');

  insert into public.lessons (slug, title, summary, position, section, content, published) values
    ('rls-test-draft', 'Entwurf', 'x', 900001, 'start', 'x', false),
    ('rls-test-public', 'Öffentlich', 'x', 900002, 'start', 'x', true);
  select id into draft_id from public.lessons where slug = 'rls-test-draft';
  select id into public_id from public.lessons where slug = 'rls-test-public';

  insert into public.lesson_progress (user_id, lesson_id) values (user_b, public_id);
  insert into public.profiles (user_id, last_lesson_id) values (user_b, public_id);

  -- Unangemeldet
  perform set_config('request.jwt.claims', '{"role":"anon"}', true);
  set local role anon;

  select count(*) into n from public.lessons where slug = 'rls-test-draft';
  assert n = 0, 'anon sieht eine unveröffentlichte Lektion';
  select count(*) into n from public.lessons where slug = 'rls-test-public';
  assert n = 1, 'anon sieht eine veröffentlichte Lektion nicht';

  begin
    update public.lessons set title = 'geändert' where slug = 'rls-test-public';
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
    select count(*) into n from public.profiles;
    assert n = 0, 'anon sieht Profile';
  exception when insufficient_privilege then null;
  end;

  -- Angemeldet als Nutzer A
  perform set_config('request.jwt.claims', json_build_object('sub', user_a, 'role', 'authenticated')::text, true);
  set local role authenticated;

  select count(*) into n from public.lessons where slug = 'rls-test-draft';
  assert n = 0, 'Nutzer sieht eine unveröffentlichte Lektion';

  select count(*) into n from public.lesson_progress;
  assert n = 0, 'A sieht fremden Fortschritt';
  select count(*) into n from public.profiles;
  assert n = 0, 'A sieht ein fremdes Profil';

  begin
    insert into public.lesson_progress (user_id, lesson_id) values (user_b, draft_id);
    assert false, 'A konnte Fortschritt für B anlegen';
  exception when insufficient_privilege then null;
  end;

  delete from public.lesson_progress where user_id = user_b;
  get diagnostics n = row_count;
  assert n = 0, 'A konnte Fortschritt von B löschen';

  update public.profiles set last_lesson_id = null where user_id = user_b;
  get diagnostics n = row_count;
  assert n = 0, 'A konnte das Profil von B ändern';

  begin
    insert into public.profiles (user_id, last_lesson_id) values (gen_random_uuid(), public_id);
    assert false, 'A konnte ein fremdes Profil anlegen';
  exception when insufficient_privilege then null;
  end;

  insert into public.lesson_progress (user_id, lesson_id) values (user_a, public_id);
  select count(*) into n from public.lesson_progress;
  assert n = 1, 'A sieht den eigenen Fortschritt nicht';

  insert into public.profiles (user_id, last_lesson_id) values (user_a, public_id);
  update public.profiles set last_lesson_id = null where user_id = user_a;
  get diagnostics n = row_count;
  assert n = 1, 'A konnte das eigene Profil nicht ändern';

  delete from public.lesson_progress where user_id = user_a;
  get diagnostics n = row_count;
  assert n = 1, 'A konnte den eigenen Fortschritt nicht löschen';

  reset role;
end $$;

rollback;

select 'rls ok' as result;
