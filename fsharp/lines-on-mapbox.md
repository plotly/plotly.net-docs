---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.12.0
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
    description: How to draw a line on Map in F# with Plotly.
    display_as: maps
    language: fsharp
    layout: base
    name: Lines on Mapbox
    order: 2
    page_type: u-guide
    permalink: fsharp/lines-on-mapbox/
    thumbnail: thumbnail/line_mapbox.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,2.0.0-preview.8"
#r "nuget: FSharp.Data"
```

# Mapbox Access Token and Base Map Configuration
To plot on Mapbox maps with Plotly you may need a Mapbox account and a public <a href="https://www.mapbox.com/studio">Mapbox Access Token</a>.


# Lines on Mapbox maps

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open FSharp.Data
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let data = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/us-cities-top-1k.csv")

let getData state = data.Rows
                        |> Seq.filter (fun row -> row.GetColumn("State") = state)
                        |> Seq.map (fun row -> row.GetColumn("lon"),row.GetColumn("lat"))

let newyorkData = getData "New York"
let ohioData = getData "Ohio"

[
    Chart.LineMapbox(newyorkData,Name="New York")
    Chart.LineMapbox(ohioData,Name="Ohio")
]
|> Chart.combine
|> Chart.withMapbox(mapBox = Mapbox.init(Style=StyleParam.MapboxStyle.StamenTerrain,Center=(-80.,41.),Zoom=3.))
|> Chart.withMarginSize(Left=0,Right=0,Top=0,Bottom=0)

```

# Lines on Mapbox maps using ScatterMapbox traces

This example uses Chart.ScatterMapbox and sets the mode attribute to a combination of markers and line.

```fsharp dotnet_interactive={"language": "fsharp"}
[
    Chart.ScatterMapbox(longitudes = [ 10; 20; 30 ], latitudes = [ 10; 20; 30 ], mode = StyleParam.Mode.Lines_Markers)
    Chart.ScatterMapbox(longitudes = [ -50; -60; 40 ], latitudes = [ 30; 10; -20 ], mode = StyleParam.Mode.Lines_Markers)
]

|> Chart.combine
|> Chart.withMarkerStyle (Size = 10)
|> Chart.withMarginSize (Left = 0, Right = 0, Top = 0, Bottom = 0)
|> Chart.withMapbox (Mapbox.init (Center = (10., 10.), Style = StyleParam.MapboxStyle.StamenTerrain, Zoom = 1.))

```
