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
    description: How to make WebGL Charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: WebGL vs SVG
    order: 14
    page_type: u-guide
    permalink: fsharp/webgl-vs-svg/
    thumbnail: thumbnail/webgl.jpg
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
#r "nuget: FSharp.Stats"
```

The following trace types use WebGL for part or all of the rendering through UseWebGL property
* Chart.Scatter
* Chart.Point
* Chart.Line
* Chart.Spline
* Chart.Bubble



# WebGL with 100,000 points using Scatter Plot

```fsharp  dotnet_interactive={"language": "fsharp"}

open Plotly.NET
open Plotly.NET.TraceObjects
open FSharp.Stats.Distributions
open System

let N = 100000

let rs = 
    let normal = Continuous.uniform -1. 1.
    Array.init N (fun _ -> normal.Sample())

let thetas = 
    let normal = Continuous.uniform 0.0 (2.*Math.PI)
    Array.init N (fun _ -> normal.Sample())
    
let xs = thetas |> Seq.zip rs |> Seq.map(fun (r,t)-> r*Math.Cos(t) )
let ys = thetas |> Seq.zip rs |> Seq.map(fun (r,t)-> r*Math.Sin(t))

let marker = Marker.init(Colorscale=StyleParam.Colorscale.Bluered, Line=Line.init(Width=1.,Color=Color.fromString "DarkSlateGrey"))

Chart.Scatter(xs, ys, StyleParam.Mode.Markers, UseWebGL= true)
|> Chart.withMarker(marker)
|> Chart.withLayout(Layout.init(Width = 1000))
```

# WebGL Rendering with 1 Million Points

```fsharp  dotnet_interactive={"language": "fsharp"}

open Plotly.NET
open Plotly.NET.TraceObjects
open FSharp.Stats.Distributions
open System

let N = 1000000

let rs = 
    let normal = Continuous.uniform -1. 1.
    Array.init N (fun _ -> normal.Sample())

let thetas = 
    let normal = Continuous.uniform 0.0 (2.*Math.PI)
    Array.init N (fun _ -> normal.Sample())
    
let xs = thetas |> Seq.zip rs |> Seq.map(fun (r,t)-> r*Math.Cos(t) )
let ys = thetas |> Seq.zip rs |> Seq.map(fun (r,t)-> r*Math.Sin(t))

let marker = Marker.init(Colorscale=StyleParam.Colorscale.Bluered, Line=Line.init(Width=1.,Color=Color.fromString "DarkSlateGrey"))

Chart.Scatter(xs, ys, StyleParam.Mode.Markers, UseWebGL= true)
|> Chart.withMarker(marker)
|> Chart.withLayout(Layout.init(Width = 1000))
```

# WebGL Rendering with many traces

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open System

let N = 5000

let x = [-10. .. (1./float N) .. 10.]
let y = [for i in x -> Math.Sin(i) ]

[
    for _ in 0..10 ->
        Chart.Scatter(x, y, StyleParam.Mode.Markers, UseWebGL= true,ShowLegend=false)
]
|> Chart.Grid(10,1)
|> Chart.withSize(Height=800)

```
