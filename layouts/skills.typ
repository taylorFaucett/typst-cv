#let layout-skills(entries, settings: none, isbreakable: true) = {
  if entries == none or entries.len() == 0 {
    none
  } else {
    let label-width = 8.8em

    // Render a single skill item (handles both string and dictionary formats)
    let get-item-name(item) = {
      if type(item) == dictionary {
        item.name
      } else {
        item
      }
    }

    // Render items as a comma-separated inline list
    let render-items-inline(items) = {
      if items == none or items.len() == 0 { 
        none 
      } else {
        items.map(item => get-item-name(item)).join(", ")
      }
    }

    // Main grid with category labels and skill items
    let row-items = ()
    for (i, entry) in entries.enumerate() {
      row-items.push(
        align(right + top)[
          #text(weight: "semibold")[#smallcaps(entry.category)]
        ]
      )
      row-items.push(
        render-items-inline(entry.items)
      )
    }

    grid(
      columns: (label-width, 1fr),
      row-gutter: if settings != none { settings.spacing-element + 0.7em } else { 0.9em },
      column-gutter: 1.2em,
      align: left,
      ..row-items
    )
  }
}
