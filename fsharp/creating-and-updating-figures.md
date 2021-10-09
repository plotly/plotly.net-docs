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
    description: Creating and Updating Figures in F# with Plotly.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Creating and Updating Figures
    order: 2
    page_type: u-guide
    permalink: fsharp/creating-and-updating-figures/
    thumbnail: thumbnail/creating-and-updating-figures.png
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.9"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.9"
#r "nuget: Deedle"
#r "nuget: FSharp.Data"
```

The plotly.NET package exists to create, manipulate and render graphical figures (i.e. charts, plots, maps and diagrams) represented by data structures also referred to as figures. The rendering process uses the Plotly.js JavaScript library under the hood although .NET developers using this module very rarely need to interact with the Javascript library directly, if ever. Figures can be represented as 'DynamicObj' an extension of `DynamicObject` which makes it possible to set arbitraryly named and typed properties of these objects via the `?` operator, and are serialized as text in JavaScript Object Notation (JSON) before being passed to Plotly.js.


# Creating Figures using DynamicObject

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let xAxis = 
    let tmp = LinearAxis()
    tmp?title <- "xAxis"
    tmp?zerolinecolor  <- "#ffff"
    tmp?showline <- true    
    tmp?zerolinewidth <- 2, 
    tmp?gridcolor <- "ffff"
    tmp

let yAxis =
    let tmp = LinearAxis()
    tmp?title <- "yAxis"
    tmp?zerolinecolor  <- "#ffff"
    tmp?showline <- true    
    tmp?zerolinewidth <- 2, 
    tmp?gridcolor <- "ffff"   
    tmp

let trace = 
    let tmp = Trace("bar")
    tmp?x <- [1;2;3]
    tmp?y <- [1;3;2]
    tmp

let layout =
    let tmp = Layout()
    tmp?title <- "A Figure Specified by DynamicObj"
    tmp?plot_bgcolor <- "#e5ecf6"
    tmp?xaxis <- xAxis
    tmp?yaxis <- yAxis    
    tmp?showlegend <- true
    tmp


GenericChart.Figure.create [trace] layout
|> GenericChart.fromFigure
```

# Figures as GenericChart Objects

Plotly.NET is a .NET wrapper for creation of `plotly charts`() written in F#. This means that, under the hood, all functionality creates JSON objects that can be rendered by plotly.
The central type that gets created by all Chart constructors is `GenericChart`, which itself represents either a single chart or a multi chart (as a Discriminate Union type). Plotly.NET has multiple abstraction layers to work with `GenericChart`s.

Chart type provides an F# convience layer that abstracts dynamic object creation. Chart type covers all the plot types(i.e Scatter,Line,3D, Heatmap etc).
The main benefit of creating charts using Chart type is; It provides strongly typed access to all the properties of Plotly figure 

```fsharp dotnet_interactive={"language": "fsharp"}
Chart.Column(Keys = [ 1; 2; 3 ], values = [ 1; 3; 2 ])
|> Chart.withXAxis (
    LinearAxis.init (
        Title = Title.init ("xAxis"),
        ZeroLineColor = Color.fromString "#ffff",
        GridColor = Color.fromString "#ffff",
        ZeroLineWidth = 2.
    )
)
|> Chart.withYAxis (
    LinearAxis.init (
        Title = Title.init ("Axis"),
        ZeroLineColor = Color.fromString "#ffff",
        GridColor = Color.fromString "#ffff",
        ZeroLineWidth = 2.
    )
)
|> Chart.withLayout (Layout.init (Title = Title.init ("A Plotly.NET Chart"), PlotBGColor = Color.fromString "#e5ecf6"))
```

# Creating Figures/Charts

This section summarizes several ways to create new Plotly figures with the Plotly.NET.


## Scatter Plot

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Deedle
open Plotly.NET

let data =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/iris.csv"
    |> fun csv -> Frame.ReadCsvString(csv, true, separators = ",")

let getColumnData column =
    data
    |> Frame.getCol column
    |> Series.values
    |> Array.ofSeq

let X: float [] = getColumnData "SepalWidth"
let Y: float [] = getColumnData "SepalLength"

let Colors =
    getColumnData "Name"
    |> Seq.map
        (function
        | "Iris-setosa" -> Color.fromString "blue"
        | "Iris-versicolor" -> Color.fromString "orange"
        | _ -> Color.fromString "deeppink")
    |> Color.fromColors

Chart.Scatter(x = X, y = Y, mode = StyleParam.Mode.Markers, Color = Colors)
|> Chart.withLayout (
    Layout.init (Title = Title.init (Text = "A Plotly Figure"), PlotBGColor = Color.fromString "#e5ecf6")
)
|> Chart.withXAxis (
    LinearAxis.init (
        Title = Title.init (Text = "SepalWidth"),
        ZeroLineColor = Color.fromString "#ffff",
        ZeroLineWidth = 2.,
        GridColor = Color.fromString "#ffff"
    )
)
|> Chart.withYAxis (
    LinearAxis.init (
        Title = Title.init (Text = "SepalLength"),
        ZeroLineColor = Color.fromString "#ffff",
        ZeroLineWidth = 2.,
        GridColor = Color.fromString "#ffff"
    )
)

```

## Make Subplots

Chart.Grid creates a grid of subplots that traces can be added to

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let scatter =
    Chart.Scatter(x = [ 1; 2; 3 ], y = [ 4; 2; 1 ], mode = StyleParam.Mode.Markers, Name = "Scatter")

let bar =
    Chart.Column([ 1; 2; 3 ], [ 4; 2; 1 ], Name = "Bar")

[ scatter; bar ] |> Chart.Grid(1, 2)
```

# Updating Figures


## Adding Traces

Traces can be added using Chart.combine that creates a GenericChart object

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let scatter =
    Chart.Scatter(x = [ 1; 2; 3 ], y = [ 4; 2; 1 ], mode = StyleParam.Mode.Markers, Name = "Scatter")
    |> Chart.withMarkerStyle (Size = 10)

let bar =
    Chart.Column(Keys = [ 1; 2; 3 ], values = [ 4; 2; 1 ], Name = "Bar")

[ scatter; bar ] |> Chart.combine

```

## Updating Figure Layouts

Chart.withLayout updates the default Layout for the plot

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let layout =
    Layout.init (
        Title = Title.init (Text = "Using Layout() With Plotly Figures"),
        Font = Font.init (Size = 17.),
        PlotBGColor = Color.fromString "#e5ecf6"
    )

Chart.Column(Keys = [ 1; 2; 3 ], values = [ 4; 2; 1 ], Name = "Bar")
|> Chart.withLayout (layout)

```

# Updating Traces

Plotly.NET provides extensions for updating properties of GenericChart

To show some examples, we will start with a chart that contains bar and scatter traces across two subplots.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let fig1 =
    [ Chart.Column(Keys = [ 0; 1; 2 ], values = [ 2; 1; 3 ], Name = "b", Color = Color.fromString "red")
      Chart.Scatter(x = [ 0; 1; 2 ], y = [ 4.; 2.; 3.5 ], mode = StyleParam.Mode.Markers, Name = "a")
      |> Chart.withMarkerStyle (Size = 20, Color = Color.fromString "rgb(51, 204, 51)") ]
    |> Chart.combine
    
let fig2 =
    [ Chart.Column(Keys = [ 0; 1; 2 ], values = [ 1; 3; 2 ], Name = "c", Color = Color.fromString "#33cc33")
      Chart.Scatter(x = [ 0; 1; 2 ], y = [ 2.; 3.5; 4. ], mode = StyleParam.Mode.Markers, Name = "d")
      |> Chart.withMarkerStyle (Size = 20, Color = Color.fromString "rgb(255, 0,0)") ]
    |> Chart.combine
    

[ fig1; fig2 ] |> Chart.Grid(1, 2)

```

Note that both scatter and bar traces have a Marker Color property to control their coloring. Here is an example of using markerStyle() to modify the color of all traces.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let fig1 =
    [ Chart.Column(Keys = [ 0; 1; 2 ], values = [ 2; 1; 3 ], Name = "b", Color = Color.fromString "red")
      Chart.Scatter(x = [ 0; 1; 2 ], y = [ 4.; 2.; 3.5 ], mode = StyleParam.Mode.Markers, Name = "a")
      |> Chart.withMarkerStyle (Size = 20, Color = Color.fromString "rgb(51, 204, 51)") ]
    |> Chart.combine
    |> Chart.withMarkerStyle(Size=20,Color=Color.fromString "blue")
    
let fig2 =
    [ Chart.Column(Keys = [ 0; 1; 2 ], values = [ 1; 3; 2 ], Name = "c", Color = Color.fromString "#33cc33")
      Chart.Scatter(x = [ 0; 1; 2 ], y = [ 2.; 3.5; 4. ], mode = StyleParam.Mode.Markers, Name = "d")
      |> Chart.withMarkerStyle (Size = 20, Color = Color.fromString "rgb(255, 0,0)") ]
    |> Chart.combine
    |> Chart.withMarkerStyle(Size=20,Color=Color.fromString "blue")
    

[ fig1; fig2 ] |> Chart.Grid(1, 2)
```

Individual trace marker styles can be updated with markerStyle like as shown above


# Overwrite Existing Properties

It is possible to overwrite the defined properties with the corresponding extension methods / abstractions

For example, Chart.withMarker() overwrites the red color of markers as shown below

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

Chart.Column([1;2;3],[1;3;2],Color=Color.fromString "red")
|> Chart.withMarker(Marker.init(Opacity=0.4))
```

# Updating Figure Axes

Here is an example of using Chart.withXAxis to disable the vertical grid lines across the subplots in a figure produced by Plotly.NET

```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET

let rand = new Random()
let x = [for i in 0..100 -> i]
let y = [for i in x -> rand.NextDouble()*10.+5.]
let y2 = [for i in x -> rand.NextDouble()*5.]

let chartGrid =
    LayoutGrid.init(
        Rows = 1,
        Columns = 2,
        SubPlots = [|
            [|
                StyleParam.LinearAxisId.X 1, StyleParam.LinearAxisId.Y 1
                StyleParam.LinearAxisId.X 2, StyleParam.LinearAxisId.Y 1
            |]
        |]
    )

[
    Chart.Point(x,y,Name="1,1") |> Chart.withAxisAnchor(X=1) 
    Chart.Point(x,y2,Name="1,2") |> Chart.withAxisAnchor(X=2) 
]
|> Chart.combine
|> Chart.withLayoutGrid chartGrid   
|> Chart.withXAxis(LinearAxis.init(ShowGrid=false),StyleParam.SubPlotId.XAxis 1)
|> Chart.withXAxis(LinearAxis.init(ShowGrid=false),StyleParam.SubPlotId.XAxis 2)
```

# Other Update Methods
GenericCharts created with the Plotly.NET graphing library also support:

the Chart.withLayoutImages() method in order to update background layout images,
Chart.withAnnotations() in order to update annotations,
and Chart.withShapes() in order to update shapes.


# Chaining Figure Operations

All of the Chart update operations described above are methods that return a reference to the Chart being modified. This makes it possible to chain multiple figure modification operations together into a single expression.

Here is an example of a chained expression that:

sets the title font size using Chart.withTitle,
disables vertical grid lines using LinearAxis,
updates the size and color of the markers and bar,
and then displaying the Chart.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

[
    Chart.Column(Keys = [ 0; 1; 2 ], values = [ 2; 1; 3 ], Name = "b", Color = Color.fromString "red")
    |> Chart.withMarkerStyle (Size = 20, Color = Color.fromString "yellow",Outline=Line.init(Width=1.5))
    Chart.Scatter(x = [ 0; 1; 2 ], y = [ 4.; 2.; 3.5 ], mode = StyleParam.Mode.Markers, Name = "a")
      |> Chart.withMarkerStyle (Size = 20, Color = Color.fromString "blue") ]
      
|> Chart.combine
|> Chart.withTitle(title="Chaining Multiple Chart Operations With A Plotly Chart",TitleFont=Font.init(Size=15.))
|> Chart.withXAxis(LinearAxis.init(ShowGrid=false))
```

# Property Assignment

Trace and layout properties can be updated using property assignment syntax. Here is an example of setting the figure title using property assignment.

As TraceObjects and LayoutObjects are of DynamicObj, they can be set through dynamic property assignment. But this is not a preferred way, consider using appropriate F# abstractions to set the properties

```fsharp dotnet_interactive={"language": "fsharp"}
let chart = Chart.Column([1;2;3],[1;3;2],Color=Color.fromString "red")

let layout = 
    let tmp = new Layout()
    let title = new Title()
    title?text <- "Using Property Assignment Syntax With GenericChart Object"
    tmp?title <- title
    tmp

chart
|> Chart.withLayout(layout)
```

And here is an example of updating the bar outline using property assignment.

```fsharp dotnet_interactive={"language": "fsharp"}
let chart = Chart.Column([1;2;3],[1;3;2],Color=Color.fromString "red")

let marker =
    let tmp = new Marker()
    let line = new Line()
    line?width <- 4
    line?color <- "black"
    tmp?line <- line
    tmp

chart
|> Chart.withMarker(marker)
```
