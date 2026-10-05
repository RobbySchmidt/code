export function useLogout() {
  const client = useSupabaseClient()
  const user = useSupabaseUser()

  return async function logout() {
    const { error } = await client.auth.signOut()
    // Schlägt das Abmelden beim Server fehl, die lokale Sitzung trotzdem löschen.
    if (error) await client.auth.signOut({ scope: 'local' })
    user.value = null
    await navigateTo('/')
  }
}
