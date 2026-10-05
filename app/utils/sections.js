export const SECTIONS = [
  { key: 'start', label: 'Start' },
  { key: 'html', label: 'HTML' },
  { key: 'css', label: 'CSS' },
  { key: 'js', label: 'JavaScript' },
  { key: 'abschluss', label: 'Abschluss' }
]

export function sectionLabel(key) {
  return SECTIONS.find(section => section.key === key)?.label ?? key
}

export function groupBySection(lessons) {
  const known = SECTIONS.map(section => section.key)
  const unknown = [...new Set(lessons.map(lesson => lesson.section))].filter(key => !known.includes(key))

  return [...known, ...unknown]
    .map(key => ({
      key,
      label: sectionLabel(key),
      lessons: lessons.filter(lesson => lesson.section === key)
    }))
    .filter(group => group.lessons.length > 0)
}
