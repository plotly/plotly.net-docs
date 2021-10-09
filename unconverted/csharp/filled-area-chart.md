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
    description: How to make filled area charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Filled Area
    order: 7
    page_type: u-guide
    permalink: fsharp/filled-area-plots/
    thumbnail: thumbnail/area.jpg
---

This example shows how to fill the area enclosed by traces.

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
open Plotly.NET
```

# Basic Filled Area Chart

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [1; 2; 3; 4]
let y0 = [0; 2; 3; 5]
let y1 = [3; 5; 1; 7]

[
    Chart.Area(x, y0)
    Chart.Area(x, y1)
] 
|> Chart.combine
```

# Overlaid Area Chart Without Boundary Lines

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [1; 2; 3; 4]
let y0 = [0; 2; 3; 5]
let y1 = [3; 5; 1; 7]

[
    Chart.Area(x, y0) 
    Chart.Area(x, y1)
] 
|> Chart.combine
|> Chart.withLineStyle(Width=0.0)
```

# Interior Filling for Area Chart

Setting Fill=StyleParam.Fill.ToNext_y makes two traces fill only interior

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET

let x = [1; 2; 3; 4]
let y0 = [3; 4; 8; 3]
let y1 = [1; 6; 2; 6]

[
    Chart.Scatter(x, y0, Plotly.NET.StyleParam.Mode.Lines, Color = Color.fromString "indigo")    
    Chart.Scatter(x, y1, Plotly.NET.StyleParam.Mode.Lines, Color = Color.fromString "indigo")     
    |> GenericChart.mapTrace(Trace2DStyle.Scatter(Fill=StyleParam.Fill.ToNext_y))    
]
|> Chart.combine



```

# Stacked Area Chart

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = ["Winter"; "Spring"; "Summer"; "Fall"]
let y0 = [40; 60; 40; 10]
let y1 = [20; 10; 10; 60]
let y2 = [40; 30; 50; 30]

[
    Chart.StackedArea(x, y0, Color=Color.fromString "#B4A3F4") 
    Chart.StackedArea(x, y1, Color=Color.fromString "#AAE9E8")
    Chart.StackedArea(x, y2, Color=Color.fromString "#CEF2E5")
] 
|> Chart.combine
|> Chart.withLineStyle(Width=0.0)
```

# Stacked Area Chart with Normalized Values
Stacked Area Chart can be created using Chart.Scatter with same StackGroup property set for all traces. For example same StackGroup="one" set for all Chart.Scatter traces

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let x = ["Winter"; "Spring"; "Summer"; "Fall"]
let y0 = [40; 20; 30; 40]
let y1 = [20; 10; 10; 60]
let y2 = [40; 30; 50; 30]

let yAxis = LinearAxis.init(AxisType = StyleParam.AxisType.Linear,
                                 Range = StyleParam.Range.MinMax(1.0, 100.0),
                                 TickSuffix = "%")

[
    Chart.Scatter(x, 
                  y0, 
                  StyleParam.Mode.Lines,
                  StackGroup = "one",
                  GroupNorm = StyleParam.GroupNorm.Percent,
                  Color=Color.fromString "rgb(131, 90, 241)")
    Chart.Scatter(x, 
                  y1, 
                  StyleParam.Mode.Lines,
                  StackGroup = "one",
                  Color=Color.fromString "rgb(111, 231, 219)")
    Chart.Scatter(x, 
                  y2, 
                  StyleParam.Mode.Lines,
                  StackGroup = "one",
                  Color=Color.fromString "rgb(184, 247, 2121)")
] 
|> Chart.combine
|> Chart.withLineStyle(Width=0.0)
|> Chart.withYAxis yAxis
```

# Select Hover Points

Chart.Area uses Chart.Scatter, hence setting Trace2DStyle.Scatter will apply area trace styles. HoverInformation can be set by the following properties in Trace2DStyle.Scatter

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let x0 = [0.0; 0.5; 1.0; 1.5; 2.0]
let y = [0.0; 1.0; 2.0; 1.0; 0.0]
let x1 = [3.0; 3.5; 4.0; 4.5; 5.0]

[
    Chart.Area(x0, 
               y, 
               Color=Color.fromString "#9400D3")
    |> GenericChart.mapTrace (Trace2DStyle.Scatter(HoverOn=StyleParam.HoverOn.PointsFills,HoverInfo=StyleParam.HoverInfo.All,Text="Points + Fills"))
                               
    Chart.Area(x1, 
               y, 
               Color=Color.fromString "#EE82EE")
    |> GenericChart.mapTrace (Trace2DStyle.Scatter(HoverOn=StyleParam.HoverOn.Points,HoverInfo=StyleParam.HoverInfo.All,Text="Points Only"))               
] 
|> Chart.combine
|> Chart.withXAxisStyle(title="X",MinMax=(0.0, 5.2))
|> Chart.withYAxisStyle(title="Y",MinMax=(0.0, 3.0))
|> Chart.withSize(Width = 1000)
```
