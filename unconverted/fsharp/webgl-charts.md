---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.12.0
  kernelspec:
    display_name: .NET (C#)
    language: C#
    name: .net-csharp
---

## WebGL with 100,000 points with Graph Objects

```csharp dotnet_interactive={"language": "fsharp"}
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

```csharp dotnet_interactive={"language": "fsharp"}
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

```csharp dotnet_interactive={"language": "fsharp"}
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
