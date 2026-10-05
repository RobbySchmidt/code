import { describe, expect, it } from 'vitest'
import { EXISTING_ACCOUNT_MESSAGE, authErrorMessage, isExistingAccountSignup } from '../../app/utils/authErrors.js'

describe('authErrorMessage', () => {
  it('ist leer, wenn es keinen Fehler gibt', () => {
    expect(authErrorMessage(null)).toBe('')
  })

  it('übersetzt falsche Zugangsdaten', () => {
    expect(authErrorMessage({ code: 'invalid_credentials' })).toBe('E-Mail-Adresse oder Passwort stimmen nicht.')
  })

  it('übersetzt ein unbestätigtes Konto', () => {
    expect(authErrorMessage({ code: 'email_not_confirmed' })).toContain('bestätige')
  })

  it('übersetzt ein vorhandenes Konto für beide Fehlercodes gleich', () => {
    expect(authErrorMessage({ code: 'user_already_exists' })).toBe(EXISTING_ACCOUNT_MESSAGE)
    expect(authErrorMessage({ code: 'email_exists' })).toBe(EXISTING_ACCOUNT_MESSAGE)
  })

  it('übersetzt ein zu schwaches Passwort', () => {
    expect(authErrorMessage({ code: 'weak_password' })).toContain('8 Zeichen')
  })

  it('übersetzt einen abgelaufenen Link', () => {
    expect(authErrorMessage({ code: 'otp_expired' })).toContain('abgelaufen')
  })

  it('liefert eine allgemeine Meldung für unbekannte Codes und Netzwerkfehler ohne Code', () => {
    const fallback = 'Das hat nicht geklappt. Versuch es bitte noch einmal.'
    expect(authErrorMessage({ code: 'something_new' })).toBe(fallback)
    expect(authErrorMessage({ message: 'Failed to fetch' })).toBe(fallback)
  })
})

describe('isExistingAccountSignup', () => {
  it('erkennt die verschleierte Antwort für eine schon registrierte Adresse', () => {
    expect(isExistingAccountSignup({ user: { identities: [] } })).toBe(true)
  })

  it('ist falsch bei einer echten Neuregistrierung', () => {
    expect(isExistingAccountSignup({ user: { identities: [{ provider: 'email' }] } })).toBe(false)
  })

  it('ist falsch ohne Nutzer oder ohne Identitätsliste', () => {
    expect(isExistingAccountSignup(null)).toBe(false)
    expect(isExistingAccountSignup({ user: null })).toBe(false)
    expect(isExistingAccountSignup({ user: {} })).toBe(false)
  })
})
