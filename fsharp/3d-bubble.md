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
    description: How to format axes of 3D Bubble Charts in F# with Plotly.
    display_as: 3d_charts
    language: fsharp
    layout: base
    name: 3D Bubble Charts
    order: 9
    page_type: u-guide
    permalink: fsharp/3d-bubble-charts/
    thumbnail: thumbnail/3dbubble.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data"
```

# Simple Bubble Chart


```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open System
open FSharp.Data


type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv">
let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv")

let x = [for row in df1.Rows do row.Year]
let y = [for row in df1.Rows do row.Continent]
let z = [for row in df1.Rows do row.Pop]


let marker = Marker.init(Size =30,Opacity=0.8, Colorscale = StyleParam.Colorscale.Viridis)
let margin =Margin.init(Left =0., Bottom=0.,Top =20., Right  = 0. )
let layout = Layout.init(Height=800., Width=800., Margin=margin)

let bubble3d =
    Chart.Scatter3d(x,y,z,mode = StyleParam.Mode.Markers     , Labels=[for row in df1.Rows do row.Country])
    |> Chart.withMarker marker
    |> Chart.withLayout layout
    |>  Chart.withTitle("Examining Population and Life Expectancy Over Time")

```

```fsharp dotnet_interactive={"language": "fsharp"}
bubble3d
```

# Bubble Chart Sized by a Variable

```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET

let N = 50
let rnd = System.Random()

let mirroredXAxis =
    Axis.LinearAxis.init(
        Title ="Distance from Sun",
        Showspikes = false,
        Backgroundcolor ="rgb(20, 24, 54)",
        Showbackground=true
    )

let mirroredLogYAxis =
    Axis.LinearAxis.init(
        Title ="Density",
        Showspikes = false,
        Backgroundcolor ="rgb(20, 24, 54)",
        Showbackground=true
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
        Title ="Gravity",
        Showspikes = false,
        Backgroundcolor ="rgb(20, 24, 54)",
        Showbackground=true
    )
let planet_colors = ["rgb(135, 135, 125)"; "rgb(210, 50, 0)"; "rgb(50, 90, 255)";
                 "rgb(178, 0, 0)"; "rgb(235, 235, 210)"; "rgb(235, 205, 130)";
                 "rgb(55, 255, 217)"; "rgb(38, 0, 171)"; "rgb(255, 255, 255)"]
let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 800.,  Margin=margin)
let marker = Marker.init(Size =50,Opacity=0.8, Colors = planet_colors  , Sizemode =StyleParam.SizeMode.Diameter, Colorscale = StyleParam.Colorscale.Greys )

let distance_from_sun  =[57.9; 108.2; 149.6; 227.9; 778.6; 1433.5; 2872.5; 4495.1; 5906.4]
let density = [5427; 5243; 5514; 3933; 1326; 687; 1271; 1638; 2095]
let gravity = [3.7; 8.9; 9.8; 3.7; 23.1; 9.0; 8.7; 11.0; 0.7]
let planet_diameter = [4879; 12104; 12756; 6792; 142984; 120536; 51118; 49528; 2370]
let planets = ["Mercury"; "Venus"; "Earth"; "Mars"; "Jupiter";"Saturn"; "Uranus"; "Neptune"; "Pluto"]

let bubblechart =
        Chart.Scatter3d(distance_from_sun,density,gravity,mode = StyleParam.Mode.Markers  , Labels=planets )
        |>  Chart.withTitle("Planets")
        |> Chart.withX_Axis  mirroredXAxis
        |> Chart.withY_Axis  mirroredLogYAxis
        |> Chart.withZ_Axis  mirroredZAxis
        |> Chart.withLayout layout
        |> Chart.withMarker marker
```

```fsharp dotnet_interactive={"language": "fsharp"}
bubblechart
```
