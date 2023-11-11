#let title = [
  A fluid dynamic model
  for glacier flow
]

#set text(font: "Linux Libertine", 11pt)
#set par(justify: true)
#set page(
  "us-letter",
  margin: auto,
  header: align(
    right + horizon,
    title
  ),
  numbering: "1",
)

#show heading.where(
  level: 1
): it => block(width: 100%)[
  #set align(center)
  #set text(12pt, weight: "regular")
  #smallcaps(it.body)
]

#show heading.where(
  level: 2
): it => text(
  size: 11pt,
  weight: "regular",
  style: "italic",
  it.body + [.],
)

#align(center, text(
  17pt,
  weight: "bold",
  title,
))

#grid(
  columns: (1fr, 1fr),
  align(center)[
    Therese Tungsten \
    Artos Institute \
    #link("mailto:tung@artos.edu")
  ],
  align(center)[
    Dr. John Doe \
    Artos Institute \
    #link("mailto:doe@artos.edu")
  ]
)

#align(center)[
  #set par(justify: false)
  *Abstract* \
  #lorem(80)
]

#v(4mm)
#show: rest => columns(2, rest)

= Introduction
#lorem(35)

== Motivation
#lorem(45)
