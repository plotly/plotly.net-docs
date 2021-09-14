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
    description: How to make WebGL Charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: WebGL Charts
    order: 5
    page_type: u-guide
    permalink: fsharp/webgl/
    thumbnail: thumbnail/webgl.png
---

## WebGL with 100,000 points with Graph Objects

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET
open System

let N = 100000

let genRandomNumbers count =
    let rnd = System.Random()
    (Seq.init count (fun _ -> (rnd.NextDouble ()) * (5. - (-5.)) + (-5.)))

let x = genRandomNumbers N
let y = genRandomNumbers N

let marker = Marker.init(Colorscale=StyleParam.Colorscale.Bluered, Line=Line.init(Width=1.))
marker?color <- "DarkSlateGrey"
marker?width <- 1

Chart.Scatter(x, y, StyleParam.Mode.Markers, UseWebGL= true)
|> Chart.withMarker(marker)
|> Chart.withLayout(Layout.init(Width = 1000.))
```

## WebGL Rendering with 1 Million Points

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET
open System

let N = 1000000

let genRandomNumbers count =
    let rnd = System.Random()
    (Seq.init count (fun _ -> (rnd.NextDouble ()) * (5. - (-5.)) + (-5.)))

let x = genRandomNumbers N
let y = genRandomNumbers N

let marker = Marker.init(Colorscale=StyleParam.Colorscale.Bluered, Line=Line.init(Width=1.))
marker?color <- "DarkSlateGrey"
marker?width <- 1

Chart.Scatter(x, y, StyleParam.Mode.Markers, UseWebGL= true)
|> Chart.withMarker(marker)
|> Chart.withLayout(Layout.init(Width = 1000.))
```

## WebGL Rendering with 1 Million Points

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET
open System

let N = 500

let genRandomNumbers count =
    let rnd = System.Random()
    (Seq.init count (fun _ -> (rnd.NextDouble ()) * (5. - (-5.)) + (-5.)))

let x = genRandomNumbers N
let y = genRandomNumbers N

Chart.Grid(
    [
        for _ in 0..10 do
            [Chart.Scatter(x, y, StyleParam.Mode.Markers, UseWebGL= true)]
    ],
    sharedAxes=true
)
|> Chart.withLayout(Layout.init(Width = 1000., Height = 1000., Showlegend = false))
|> Chart.Show
```
