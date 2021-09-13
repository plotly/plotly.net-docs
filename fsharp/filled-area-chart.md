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
    name: Filled Area Charts
    order: 5
    page_type: u-guide
    permalink: fsharp/filled-area-charts/
    thumbnail: thumbnail/area.jpg
---

# Filled Area Charts


## Imports

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET
```

## Filled area chart with plotly.graph_objects

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [1; 2; 3; 4]
let y0 = [0; 2; 3; 5]
let y1 = [3; 5; 1; 7]

[
    Chart.Area(x, y0)
    Chart.Area(x, y1)
]
|> Chart.Combine
```

## Overlaid Area Chart Without Boundary Lines

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [1; 2; 3; 4]
let y0 = [0; 2; 3; 5]
let y1 = [3; 5; 1; 7]

[
    Chart.Area(x, y0)
    Chart.Area(x, y1)
]
|> Chart.Combine
|> Chart.withLineStyle(Width=0.0)
```

## Interior Filling for Area Chart

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [1; 2; 3; 4]
let y0 = [3; 4; 8; 3]
let y1 = [1; 6; 2; 6]

let stackGroup = "filling"

[
    Chart.Scatter(x, y0, Plotly.NET.StyleParam.Mode.Lines, Color = "indigo")
    Chart.Scatter(x, y1, Plotly.NET.StyleParam.Mode.Lines, Color = "indigo") |> GenericChart.mapTrace(fun x -> x.SetValue("fill", "tonexty"); x)
]
|> Chart.Combine


```

## Stacked Area Chart

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = ["Winter"; "Spring"; "Summer"; "Fall"]
let y0 = [40; 60; 40; 10]
let y1 = [20; 10; 10; 60]
let y2 = [40; 30; 50; 30]

[
    Chart.StackedArea(x, y0, Color="#B4A3F4")
    Chart.StackedArea(x, y1, Color="#AAE9E8")
    Chart.StackedArea(x, y2, Color="#CEF2E5")
]
|> Chart.Combine
|> Chart.withLineStyle(Width=0.0)
```

## Stacked Area Chart with Normalized Values

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = ["Winter"; "Spring"; "Summer"; "Fall"]
let y0 = [40; 20; 30; 40]
let y1 = [50; 70; 40; 60]
let y2 = [70; 80; 60; 70]
let y3 = [100; 100; 100; 100]

let xAxis = Axis.LinearAxis.init(AxisType = StyleParam.AxisType.Category)

let yAxis = Axis.LinearAxis.init(AxisType = StyleParam.AxisType.Linear,
                                 Range = StyleParam.Range.MinMax(1.0, 100.0),
                                 Ticksuffix = "%")

[
    Chart.Scatter(x,
                  y0,
                  StyleParam.Mode.Lines,
                  StackGroup = stackGroup,
                  GroupNorm = StyleParam.GroupNorm.Percent,
                  Color="#B4A3F4")
    Chart.Scatter(x,
                  y1,
                  StyleParam.Mode.Lines,
                  StackGroup = stackGroup,
                  Color="#B2C9F2")
    Chart.Scatter(x,
                  y2,
                  StyleParam.Mode.Lines,
                  StackGroup = stackGroup,
                  Color="#AAE9E8")
    Chart.Scatter(x,
                  y3,
                  StyleParam.Mode.Lines,
                  StackGroup = stackGroup,
                  Color="#CEF2E5")
]
|> Chart.Combine
|> Chart.withLineStyle(Width=0.0)
|> Chart.withX_Axis xAxis
|> Chart.withY_Axis yAxis
```

## Select Hover Points

```fsharp dotnet_interactive={"language": "fsharp"}
let x0 = [0.0; 0.5; 1.0; 1.5; 2.0]
let y = [0.0; 1.0; 2.0; 1.0; 0.0]
let x1 = [3.0; 3.5; 4.0; 4.5; 5.0]

let xAxis = Axis.LinearAxis.init(AxisType = StyleParam.AxisType.Linear,
                                 Range = StyleParam.Range.MinMax(0.0, 5.2))

let yAxis = Axis.LinearAxis.init(AxisType = StyleParam.AxisType.Linear,
                                 Range = StyleParam.Range.MinMax(0.0, 3.0))

[
    Chart.Area(x0,
               y,
               Color="#9400D3")
               |> GenericChart.mapTrace(fun x -> x.SetValue("hoveron", "points+fills"); x.SetValue("text", "Points + Fills"); x.SetValue("hoverinfo", "text+x+y"); x)
    Chart.Area(x1,
               y,
               Color="#EE82EE")
               |> GenericChart.mapTrace(fun x -> x.SetValue("hoveron", "points"); x.SetValue("text", "Points only"); x.SetValue("hoverinfo", "text+x+y"); x)
]
|> Chart.Combine
|> Chart.withX_Axis xAxis
|> Chart.withY_Axis yAxis
|> Chart.withLayout(Layout.init(Width = 1000.))
```
