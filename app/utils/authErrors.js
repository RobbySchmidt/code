export const EXISTING_ACCOUNT_MESSAGE = 'Mit dieser E-Mail-Adresse gibt es bereits ein Konto. Melde dich an oder setze dein Passwort zurück.'

const FALLBACK_MESSAGE = 'Das hat nicht geklappt. Versuch es bitte noch einmal.'

const MESSAGES = {
  invalid_credentials: 'E-Mail-Adresse oder Passwort stimmen nicht.',
  email_not_confirmed: 'Bitte bestätige zuerst deine E-Mail-Adresse über den Link in unserer Mail.',
  user_already_exists: EXISTING_ACCOUNT_MESSAGE,
  email_exists: EXISTING_ACCOUNT_MESSAGE,
  weak_password: 'Das Passwort ist zu schwach. Nimm mindestens 8 Zeichen.',
  same_password: 'Das neue Passwort muss sich vom alten unterscheiden.',
  email_address_invalid: 'Diese E-Mail-Adresse ist ungültig.',
  email_address_not_authorized: 'An diese Adresse können wir gerade keine Mail senden.',
  over_email_send_rate_limit: 'Es wurden gerade zu viele Mails verschickt. Versuch es später noch einmal.',
  over_request_rate_limit: 'Zu viele Versuche. Warte kurz und versuch es noch einmal.',
  otp_expired: 'Der Link ist abgelaufen oder wurde schon benutzt.'
}

export function authErrorMessage(error) {
  if (!error) return ''
  return MESSAGES[error.code] ?? FALLBACK_MESSAGE
}

export function isExistingAccountSignup(data) {
  const identities = data?.user?.identities
  return Array.isArray(identities) && identities.length === 0
}
