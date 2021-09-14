---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.4.2
  kernelspec:
    display_name: .NET (F#)
    language: F#
    name: .net-fsharp
  language_info:
    codemirror_mode:
      name: ipython
      version: 3
    file_extension: .fs
    mimetype: text/x-fsharp
    name: F#
    nbconvert_exporter: fsharp
    pygments_lexer: fsharp
    version: 5.0
  plotly:
    description: How to make Pie charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Pie Charts
    order: 5
    page_type: u-guide
    permalink: fsharp/pie-charts/
    thumbnail: thumbnail/pie-chart.jpg
---

## Basic Pie Chart with go.Pie

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500; 2500; 1053; 500]

Chart.Pie(Labels=labels, values=values)
```

## Styled Pie Chart

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let colors = ["gold"; "mediumturquoise"; "darkorange"; "lightgreen"]
let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500; 2500; 1053; 500]

let layout =
    let obj = Layout()
    obj?hoverinfo <- "label+percent"
    obj?textinfo <- "value"
    obj?textfont_size <- 20
    obj

Chart.Pie(Labels=labels, values=values, Colors = colors)
|> Chart.withLayout(layout)
```

## Controlling text orientation inside pie sectors

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let colors = ["gold"; "mediumturquoise"; "darkorange"; "lightgreen"]
let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500; 2500; 1053; 500]

let layout =
    let obj = Layout()
    obj?insidetextorientation <- "radial"
    obj

Chart.Pie(Labels=labels, values=values, Textinfo="label+percent")
|> Chart.withLayout(layout)
```

## Donut Chart

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500; 2500; 1053; 500]


Chart.Doughnut(Labels=labels, values=values, Hole=0.3)
```

## Pulling sectors out from the center

```fsharp dotnet_interactive={"language": "fsharp"}

#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500.; 2500.; 1053.; 500.]


let trace =
    let tmp = Trace("pie")
    tmp?labels <- labels
    tmp?values <- values
    tmp?pull <- [0.;0.;0.2;0.]
    tmp

GenericChart.ofTraceObject(trace)
```

## Pie Charts in subplots

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let labels = ["US"; "China"; "European Union"; "Russian Federation"; "Brazil"; "India"; "Rest of the World"]
let values = [4500.; 2500.; 1053.; 500.]

let layout =
    let tmp = Layout()
    tmp?title_text <- "Global Emissions 1990-2011"
    tmp?annotations <- [{|text = "CHG"; x = 0.18; y = 0.5; font_size = 20; showarrow = false|};{|text = "CO2"; x = 0.82; y = 0.5; font_size = 20; showarrow = false|}]
    tmp

let chg =
    let tmp = Trace("pie")
    tmp?labels <- labels
    tmp?domain <- {|x = [0.; 0.5]|}
    tmp?hole <- 0.4
    tmp?hoverinfo <- "label+percent+name"
    tmp?name <- "CHG Emissions"
    tmp?values <- [16; 15; 12; 6; 5; 4; 42]
    tmp

let co2 =
    let tmp = Trace("pie")
    tmp?labels <- labels
    tmp?domain <- {|x = [0.5; 1.0]|}
    tmp?hole <- 0.4
    tmp?hoverinfo <- "label+percent+name"
    tmp?name <- "CO2 Emissions"
    tmp?values <- [27; 11; 25; 8; 1; 3; 25]
    tmp

Chart.Grid(
    [
        [GenericChart.ofTraceObject(chg); GenericChart.ofTraceObject(co2)]
    ]
) |> Chart.withLayout(layout)
```

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let labels = ["1st"; "2nd"; "3rd"; "4th"; "5th"]
let nightColors = ["rgb(56, 75, 126)"; "rgb(18, 36, 37)"; "rgb(34, 53, 101)"; "rgb(36, 55, 57)"; "rgb(6, 4, 4)"]
let sunflowersColors = ["rgb(177; 127; 38)"; "rgb(205; 152; 36)"; "rgb(99; 79; 37)"; "rgb(129; 180; 179)"; "rgb(124; 103; 37)"]
let irisesColors = ["rgb(33; 75; 99)"; "rgb(79; 129; 102)"; "rgb(151; 179; 100)";"rgb(175; 49; 35)"; "rgb(36; 73; 147)"]
let cafeColors =  ["rgb(146; 123; 21)"; "rgb(177; 180; 34)"; "rgb(206; 206; 40)"; "rgb(175; 51; 21)"; "rgb(35; 36; 21)"]

let layout =
    let tmp = Layout()
    tmp?title_text <- "Van Gogh: 5 Most Prominent Colors Shown Proportionally"
    tmp?showlegend <- false
    tmp?width <- 1000.
    tmp?height <- 500.
    tmp

let starryNight =
    let tmp = Trace("pie")
    tmp?labels <- labels
    tmp?domain <- {|x = [0.; 0.5]; y = [0.5; 1.0]|}
    tmp?name <- "Starry Night"
    tmp?marker_colors <- nightColors
    tmp?values <- [38; 27; 18; 10; 7]
    tmp

let sunflowers =
    let tmp = Trace("pie")
    tmp?labels <- labels
    tmp?domain <- {|x = [0.5; 1.0]; y = [0.5; 1.0]|}
    tmp?marker_colors <- sunflowersColors
    tmp?name <- "Sunflowers"
    tmp?values <- [28; 26; 21; 15; 10]
    tmp

let irises =
    let tmp = Trace("pie")
    tmp?labels <- labels
    tmp?domain <- {|x = [0.0; 0.5]; y = [0.0; 0.5]|}
    tmp?marker_colors <- irisesColors
    tmp?name <- "Irises"
    tmp?values <- [38; 19; 16; 14; 13]
    tmp

let nightCafe =
    let tmp = Trace("pie")
    tmp?labels <- labels
    tmp?domain <- {|x = [0.5; 1.0]; y = [0.0; 0.5]|}
    tmp?marker_colors <- cafeColors
    tmp?name <- "The Night Café"
    tmp?values <- [31; 24; 19; 18; 8]
    tmp

Chart.Grid(
    [
        [GenericChart.ofTraceObject(starryNight); GenericChart.ofTraceObject(sunflowers)]
        [GenericChart.ofTraceObject(irises); GenericChart.ofTraceObject(nightCafe)]
    ]
)
|> Chart.withLayout(layout)
|> Chart.withLayoutGrid(LayoutGrid.init(Rows=2, Columns=2))
```

## Plot chart with area proportional to total count

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let labels = ["Asia"; "Europe"; "Africa"; "Americas"; "Oceania"]

let layout =
    let tmp = Layout()
    tmp?title <- "World GDP"
    tmp?width <- 1700.
    tmp

let gdp1980 =
    let tmp = Trace("pie")
    tmp?labels <- labels
    tmp?domain <- Domain.init(Row = 1, Column = 2)
    tmp?title <- "World GDP 1980"
    tmp?scalegroup <- "one"
    tmp?values <- [4.;7.;1.;7.;0.5]
    tmp

let gdp2007 =
    let tmp = Trace("pie")
    tmp?labels <- labels
    tmp?domain <- Domain.init(Row = 1, Column = 1)
    tmp?title <- "World GDP 2007"
    tmp?scalegroup <- "one"
    tmp?values <- [21.;15.;3.;19.;1.]
    tmp

[
    GenericChart.ofTraceObject(gdp1980)
    GenericChart.ofTraceObject(gdp2007)
]
|> Chart.Combine
|> Chart.withLayout(layout)
|> Chart.withLayoutGrid(LayoutGrid.init(Rows = 1, Columns = 2))
```

## Sunburst charts

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let labels = ["Eve"; "Cain"; "Seth"; "Enos"; "Noam"; "Abel"; "Awan"; "Enoch"; "Azura"]
let parents = [""; "Eve"; "Eve"; "Seth"; "Seth"; "Eve"; "Eve"; "Awan"; "Eve"]
let values = [10.;14.;12.;10.;2.;6.;6.;4.;4.]

let layout =
    let tmp = Layout()
    tmp?margin <- {|t = 0.; l = 0.;  r = 0.; b = 0.|}
    tmp

Chart.Sunburst(labels = labels, parents = parents, Values = values)
|> Chart.withLayout(layout)
```
