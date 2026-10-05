import { describe, expect, it } from 'vitest'
import { SECTIONS, groupBySection, sectionLabel } from '../../app/utils/sections.js'

const lesson = (id, section) => ({ id, slug: `l${id}`, section })

describe('sectionLabel', () => {
  it('liefert den Anzeigenamen eines Blocks', () => {
    expect(sectionLabel('js')).toBe('JavaScript')
  })

  it('gibt bei unbekanntem Block den Schlüssel zurück', () => {
    expect(sectionLabel('bonus')).toBe('bonus')
  })
})

describe('groupBySection', () => {
  it('gruppiert in Kursreihenfolge, unabhängig von der Eingabereihenfolge', () => {
    const groups = groupBySection([lesson(1, 'js'), lesson(2, 'start'), lesson(3, 'html')])
    expect(groups.map(g => g.key)).toEqual(['start', 'html', 'js'])
  })

  it('lässt leere Blöcke weg', () => {
    const groups = groupBySection([lesson(1, 'css')])
    expect(groups).toHaveLength(1)
    expect(groups[0]).toMatchObject({ key: 'css', label: 'CSS' })
  })

  it('behält die Reihenfolge der Lektionen innerhalb eines Blocks', () => {
    const groups = groupBySection([lesson(1, 'js'), lesson(2, 'js')])
    expect(groups[0].lessons.map(l => l.id)).toEqual([1, 2])
  })

  it('hängt Lektionen mit unbekanntem Block ans Ende, statt sie zu verschlucken', () => {
    const groups = groupBySection([lesson(1, 'bonus'), lesson(2, 'start')])
    expect(groups.map(g => g.key)).toEqual(['start', 'bonus'])
  })

  it('liefert für eine leere Liste keine Gruppen', () => {
    expect(groupBySection([])).toEqual([])
  })
})

describe('SECTIONS', () => {
  it('enthält die fünf Blöcke der Spec', () => {
    expect(SECTIONS.map(s => s.key)).toEqual(['start', 'html', 'css', 'js', 'abschluss'])
  })
})
