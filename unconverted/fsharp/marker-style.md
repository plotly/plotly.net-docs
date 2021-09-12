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

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"

```

# Add Marker Border


In order to make markers distinct, you can add a border to the markers

```csharp dotnet_interactive={"language": "fsharp"}

open Plotly.NET

let x  = [1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.; ]
let y1 = [2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]
let y2 = [1.; 2.5; 4.; 2.5; 4.; 6.5; 3.5; 5.5; 4.5; 6.]

[
    Chart.Point(x,y1,Name="plot-1") |> Chart.withMarkerStyle(Size=10,Color="deeppink",Symbol=StyleParam.Symbol.Cross);
    Chart.Point(x,y2,Name="plot-2") |> Chart.withMarkerStyle(Size=20,Color="blue",Symbol=StyleParam.Symbol.Diamond)
]
|> Chart.combine
```

# Marker Opacity


To maximise visibility of density, it is recommended to set the opacity inside the marker marker:{opacity:0.5}. If mulitple traces exist with high density, consider using marker opacity in conjunction with trace opacity.

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open System

let rand = new Random()

let x  = [for i in 0..100 -> 100+i]
let y1 = [for i in 0..100 -> rand.NextDouble()]
let y2 = [for i in 0..100 -> rand.NextDouble()]

[
    Chart.Point([for i in 0..2 -> 50+i],[0.5;0.8],Name="plot-1",Showlegend=false) |> Chart.withMarker(Marker.init(Size=150,Color="green",Opacity=0.5, Symbol=StyleParam.Symbol.Circle,Line=Line.init(Width=10.,Color="red")));
    Chart.Point(x,y1,Name="plot-2",Showlegend=false) |> Chart.withMarkerStyle(Size=25,Color="deeppink",Opacity=0.5, Symbol=StyleParam.Symbol.Circle);
    Chart.Point(x,y2,Name="plot-3",Showlegend=false) |> Chart.withMarkerStyle(Size=25,Color="blue",Opacity=0.5, Symbol=StyleParam.Symbol.Circle)
]
|> Chart.combine
```

# Color Opacity


To maximise visibility of each point, set the color opacity by using alpha: marker:{color: 'rgba(0,0,0,0.5)'}. Here, the marker line will remain opaque.

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open System

let rand = new Random()

let x  = [for i in 0..100 -> 100+i]
let y1 = [for i in 0..100 -> rand.NextDouble()]
let y2 = [for i in 0..100 -> rand.NextDouble()]

[
    Chart.Point([for i in 0..2 -> 50+i],[0.5;0.8],Name="plot-1",Showlegend=false) |> Chart.withMarker(Marker.init(Size=150,Color="rgba(17, 157, 255,0.5)",Opacity=0.5, Symbol=StyleParam.Symbol.Circle,Line=Line.init(Width=10.,Color="red")));
    Chart.Point(x,y1,Name="plot-2",Showlegend=false) |> Chart.withMarkerStyle(Size=25,Color="rgba(17, 157, 255,0.5)",Opacity=0.5, Symbol=StyleParam.Symbol.Circle);
    Chart.Point(x,y2,Name="plot-3",Showlegend=false) |> Chart.withMarkerStyle(Size=25,Color="rgba(17, 157, 255,0.5)",Opacity=0.5, Symbol=StyleParam.Symbol.Circle)
]
|> Chart.combine
```