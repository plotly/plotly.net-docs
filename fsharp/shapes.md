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
    description: How to make SVG shapes in python. Examples of lines, circle, rectangle,
      and path.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Shapes
    order: 25
    page_type: example_index
    permalink: fsharp/shapes/
    thumbnail: thumbnail/shape.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
```

# Lines

```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET

let rand = new Random()

let x  = [for i in 0..20 -> i]
let y = [for i in 0..20 -> Math.Sin(float(i))]

let lines = [
        Shape.init(StyleParam.ShapeType.Line,0,5.,0.5,0.5,Line=Line.init(Color="red"));
        Shape.init(StyleParam.ShapeType.Line,5,10.,-0.5,-0.5,Line=Line.init(Color="green"));
        Shape.init(StyleParam.ShapeType.Line,10,15.,1,1,Line=Line.init(Color="orange"));
        Shape.init(StyleParam.ShapeType.Line,15,20.,-1,-1,Line=Line.init(Color="blue")) ]

Chart.Line(x,y)
|> Chart.withShapes lines
|> Chart.withTitle(title="Highlighting with Rectangles")
```

# Rectangles

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Deedle"
#r "nuget: FSharp.Data"

open Deedle
open FSharp.Data
open Plotly.NET

let data =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/2014_apple_stock.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let rects = [
    Shape.init(StyleParam.ShapeType.Rectangle,X0 = "2014-05-01", X1 = "2014-06-01", Xref = "x", Y0 = 70, Y1 = 90, Yref = "y",Fillcolor="blue",Opacity=0.2, Line=Line.init(Color="red"));
    Shape.init(StyleParam.ShapeType.Rectangle,X0 = "2014-09-01", X1 = "2014-11-01", Xref = "x", Y0 = 95, Y1 = 105, Yref = "y",Line=Line.init(Color="red"));]

Chart.Point(x=getColumnData "AAPL_x",y=getColumnData "AAPL_y")
|> Chart.withShapes rects
|> Chart.withTitle(title="Highlighting with Rectangles")
```

# Circles


Circles are centered around ((x0+x1)/2, (y0+y1)/2))

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/tips.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")


let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let circles = [
    Shape.init(StyleParam.ShapeType.Circle,X0 = 10, X1 = 20, Xref = "x", Y0 = 1, Y1 = 3, Yref = "y",Fillcolor="rgb(50, 20, 90)",Opacity=0.2, Line=Line.init(Color="rgb(50, 20, 90)"));
    Shape.init(StyleParam.ShapeType.Circle,X0 = 25, X1 = 40, Xref = "x", Y0 = 4, Y1 = 8, Yref = "y",Fillcolor="rgb(30, 100, 120)",Opacity=0.2, Line=Line.init(Color="rgb(30, 100, 120)"));
    ]

Chart.Point(x=getColumnData "total_bill",y=getColumnData "tip")
|> Chart.withShapes circles
|> Chart.withTitle(title="Highlighting Regions with Circles")
```

# Drawing Shapes on Cartesian Plots

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/tips.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")


let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq


Chart.Point(x=getColumnData "total_bill",y=getColumnData "tip")
|> Chart.withTitle(title="Click and drag inside the figure to draw a rectangle or select another shape in the modebar")
//|> Chart.withConfig (Config.init()) //modeBarButtonsToAdd
//|> Chart.withLayout (Layout.init(Dragmode=StyleParam.DragMode.Rotate)) //dragmode="drawrect",
```
