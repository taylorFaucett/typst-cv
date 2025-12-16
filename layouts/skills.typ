#let layout-skills(entries, settings: none, isbreakable: true) = {
  if entries == none or entries.len() == 0 {
    none
  } else {
    let label-width = 8.8em
    let item-columns = 2  // Number of columns for skill items
    let skill-name-width = 10.5em  // Fixed width for skill names

    // Render proficiency indicators (filled/unfilled circles)
    let render-proficiency(level) = {
      let max-level = 3
      let filled = "●"
      let empty = "○"
      
      let circles = ()
      for i in range(max-level) {
        if i < level {
          circles.push(filled)
        } else {
          circles.push(empty)
        }
      }
      text(size: 0.7em, fill: rgb(100, 100, 100))[#circles.join(" ")]
    }

    // Render a single skill item with fixed-width name and aligned dots
    let render-item(item) = {
      if type(item) == dictionary {
        let name = item.name
        let level = item.at("level", default: none)
        if level != none {
          grid(
            columns: (skill-name-width, auto),
            column-gutter: 0.5em,
            align: (left, left),
            [#name],
            render-proficiency(level)
          )
        } else {
          box(width: skill-name-width)[#name]
        }
      } else {
        box(width: skill-name-width)[#item]
      }
    }

    // Render items in a multi-column grid
    let render-items-grid(items) = {
      if items == none or items.len() == 0 { 
        none 
      } else {
        grid(
          columns: item-columns,
          column-gutter: 1.5em,
          row-gutter: 0.35em,
          ..items.map(item => render-item(item))
        )
      }
    }

    // Main grid with category labels and skill items
    let row-items = ()
    for entry in entries {
      row-items.push(
        align(right + top)[
          #text(weight: "semibold")[#smallcaps(entry.category)]
        ]
      )
      row-items.push(
        render-items-grid(entry.items)
      )
    }

    grid(
      columns: (label-width, 1fr),
      row-gutter: if settings != none { settings.spacing-element + 0.4em } else { 0.6em },
      column-gutter: 1.2em,
      align: left,
      ..row-items
    )
  }
}
