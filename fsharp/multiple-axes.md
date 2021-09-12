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
    description: How to make a graph with multiple axes (dual y-axis plots, plots
      with secondary axes) in F#.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Multiple Axes
    order: 16
    page_type: u-guide
    permalink: fsharp/multiple-axes/
    thumbnail: thumbnail/multiple-axes.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
```

# Two Y Axes

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.Axis

let x = [for i in 0..10 -> i]
let y1 = [for i in x -> Math.Pow(float i,2.0)]
let y2 = [for i in x -> Math.Pow(float i,3.0)]

[
    Chart.Line(x,y1,Name="anchor 1",ShowMarkers=true) |> Chart.withAxisAnchor(Y=1);
    Chart.Line(x,y2,Name="anchor 2",ShowMarkers=true) |> Chart.withAxisAnchor(Y=2)
]
|> Chart.combine
|> Chart.withLayout(Layout.init(Plot_bgcolor="#e5ecf6"))
|> Chart.withYAxisStyle(
        "axis 1",
        Side=StyleParam.Side.Left,
        Id=StyleParam.SubPlotId.YAxis 1
    )
|> Chart.withYAxisStyle(
        "axis2",
        Side=StyleParam.Side.Right,
        Id=StyleParam.SubPlotId.YAxis 2,
        Overlaying=StyleParam.LinearAxisId.Y 1
    )
```

# Multiple Axes

```fsharp dotnet_interactive={"language": "fsharp"}
[
    for i in 1..4 ->
                    Chart.Line(x=[for j in i..(i+4) -> j],y=[for j in i..(i+4) -> 2*j*j+3*j],Name=String.Format("anchor {0}",i),ShowMarkers=true )
                    |> Chart.withAxisAnchor(Y=i)
]
|> Chart.combine
|> Chart.withXAxisStyle("x-axis",Domain=(0.3, 0.7))
|> Chart.withLayout(Layout.init(Plot_bgcolor="#e5ecf6"))
|> Chart.withYAxisStyle(
        "y axis 1",
        Side=StyleParam.Side.Left,
        Id=StyleParam.SubPlotId.YAxis 1
    )
|> Chart.withYAxisStyle(
        "y axis 2",
        Side=StyleParam.Side.Left,
        Id=StyleParam.SubPlotId.YAxis 2,
        Position= 0.1,
        Overlaying=StyleParam.LinearAxisId.Y 1
    )
|> Chart.withYAxisStyle(
        "y axis 3",
        Side=StyleParam.Side.Right,
        Id=StyleParam.SubPlotId.YAxis 3,
        Overlaying=StyleParam.LinearAxisId.Y 1
    )
|> Chart.withYAxisStyle(
        "y axis 4",
        Side=StyleParam.Side.Right,
        Id=StyleParam.SubPlotId.YAxis 4,
        Position= 0.85,
        Overlaying=StyleParam.LinearAxisId.Y 1
    )

```

# Multiple Y-Axes Subplots

```fsharp dotnet_interactive={"language": "fsharp"}
// open Plotly.NET

// let x = [for i in 0..10 -> i]
// let y = [for i in x -> Math.Pow(float i,2.0)]
// let y2 = [for i in x -> Math.Pow(float i,3.0)]

// [
//     [
//         Chart.Point(x,y,Name="1,1") |> Chart.withAxisAnchor(Y=1)
//         Chart.Point(x,y2,Name="1,2") |> Chart.withAxisAnchor(Y=2)
//     ]|>
//     Chart.combine
//     |> Chart.withYAxisStyle("y1",Side=StyleParam.Side.Left,Id=StyleParam.SubPlotId.YAxis 1)
//     |> Chart.withYAxisStyle("y2", Side=StyleParam.Side.Right,Id=StyleParam.SubPlotId.YAxis 2)

//     Chart.Invisible()

// ]
// |> Chart.Grid(2,2)



// let getChart i =
//     [
//         Chart.Line(x,y1,Name="anchor "+string i,ShowMarkers=true) |> Chart.withAxisAnchor(Y=i);
//         Chart.Line(x,y2,Name="anchor "+string (i+1),ShowMarkers=true) |> Chart.withAxisAnchor(Y=i+1)
//     ]
//     |> Chart.combine
//     |> Chart.withLayout(Layout.init(Plot_bgcolor="#e5ecf6"))
//     |> Chart.withYAxisStyle(
//             "axis 1",
//             Side=StyleParam.Side.Left,
//             Id=StyleParam.SubPlotId.YAxis i
//         )
//     |> Chart.withYAxisStyle(
//             "axis 2",
//             Side=StyleParam.Side.Right,
//             Id=StyleParam.SubPlotId.YAxis (i+1),
//             Overlaying=StyleParam.LinearAxisId.Y 1
//         )

// let grid =
//     [
//         for i in 1..1 -> (getChart i)
//     ]
//     |> Chart.Grid(2,2)

// grid

```
