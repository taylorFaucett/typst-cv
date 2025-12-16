#import "@preview/academicv:1.0.0": *

// Extended timeline layout that supports optional dissertation field
#let layout-timeline-education(entries, settings: none, isbreakable: true) = {
  if entries == none or entries.len() == 0 {
    none
  } else {
    for entry in entries {
      // First render the standard timeline entry
      layout-timeline(
        (entry,), 
        settings: settings, 
        isbreakable: isbreakable, 
        primary-element: ("institution",), 
        secondary-element: ("title",),
        tertiary-element: if "description" in entry { ("description",) } else { () }
      )
      
      // Then add dissertation row if present
      if "dissertation" in entry and entry.dissertation != none and entry.dissertation != "" {
        block(
          breakable: isbreakable,
          width: 100%,
        )[
          #v(if settings != none { settings.spacing-line } else { 5pt })
          #if "dissertation-url" in entry and entry.dissertation-url != none and entry.dissertation-url != "" {
            text(style: "italic")[Dissertation: #link(entry.dissertation-url)[#entry.dissertation]]
          } else {
            text(style: "italic")[Dissertation: #entry.dissertation]
          }
        ]
      }
    }
  }
}
