#let layout-skills(entries, settings: none, isbreakable: true) = {
  if entries == none or entries.len() == 0 {
    none
  } else {
    let label-width = 8.8em
    let item-columns = 3  // Number of columns for skill items

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

    // Render a single skill item with dots on the left for better alignment
    let render-item(item) = {
      if type(item) == dictionary {
        let name = item.name
        let level = item.at("level", default: none)
        if level != none {
          grid(
            columns: (auto, 1fr),
            column-gutter: 0.6em,
            align: (right, left + horizon),
            render-proficiency(level),
            [#name]
          )
        } else {
          [#name]
        }
      } else {
        [#item]
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
          row-gutter: 0.8em,
          ..items.map(item => render-item(item))
        )
      }
    }

    // Main grid with category labels and skill items
    let row-items = ()
    for (i, entry) in entries.enumerate() {
      if i != 0 {
        row-items.push(grid.cell(colspan: 2, line(length: 100%, stroke: 0.5pt + rgb(200, 200, 200))))
      }
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
