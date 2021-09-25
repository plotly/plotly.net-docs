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
    description: How to make scatter plots in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Scatter Plots
    order: 1
    page_type: u-guide
    permalink: fsharp/line-and-scatter/
    thumbnail: thumbnail/line-and-scatter.jpg
---

# Scatter Plots in F#
How to make scatter plots in F# with Plotly.NET

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: newtonsoft.json"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
#r "nuget: FSharp.Data"
#r "nuget: Deedle"

open Plotly.NET
```

# Scatter and line plots 
With Chart.Scatter, each data point is represented as a marker point, whose location is given by the x and y arrays.


# Simple Scatter Plot

```fsharp  dotnet_interactive={"language": "fsharp"}

let ts = [0. .. 0.1 .. 10.]
let ys = ts |> Seq.map (Math.Sin)
Chart.Scatter(ts, ys, mode=StyleParam.Mode.Markers)
```

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x=[|0; 1; 2; 3; 4|]
let y=[|0; 1; 4; 9; 16|]

Chart.Scatter(x, y , mode=StyleParam.Mode.Markers_Text)
    |> Chart.withXAxisStyle ("x")
    |> Chart.withYAxisStyle ("y")
```

# Line and Scatter Plots

settting mode in Chart.Scatter to StyleParam.Mode.Markers, StyleParam.Mode.Lines_Markers helps to visualize markers along with lines

```fsharp  dotnet_interactive={"language": "fsharp"}

open Plotly.NET

let n = 100.
let random_x = [0. .. 1. .. n]

let rand = new Random()

let nextFloat(max,min)= rand.NextDouble() * (max - min) + min

let generate() = random_x |> Seq.map (fun _-> nextFloat(-2., 2.))

let random_y0 = generate () |> Seq.map(fun x-> x + 5.)
let random_y1 = generate ()
let random_y2 = generate () |> Seq.map(fun x-> x - 5.)

[
    Chart.Scatter(random_x, random_y0, mode=StyleParam.Mode.Markers, Name="Markers");
    Chart.Scatter(random_x, random_y1, mode=StyleParam.Mode.Lines_Markers, Name="Lines_Markers");
    Chart.Scatter(random_x, random_y2, mode=StyleParam.Mode.Lines, Name="Lines");
] |> Chart.combine
```

# Bubble Scatter Plots
Scatter plots with variable-sized circular markers are often known as bubble charts. In bubble charts, a third dimension of the data is shown through the size of markers. 

MultiSizes property allows to set variable sizes for the marker symbols

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects

let xs =[1; 2; 3; 4]
let ys =[10;11; 12; 13]

let colors = [|"#4287f5";"#cb23fa";"#23fabd";"#ff7b00"|] |> Array.map (fun c -> Color.fromString(c))
let marker = Marker.init(MultiSizes=[40; 60; 80; 100]);
marker?color <- colors

Chart.Scatter(xs, ys, StyleParam.Mode.Markers, Name="Markers")
        |> Chart.withMarker(marker)
```

# Style Scatter Plots
There are many properties of the scatter chart type that control different aspects of the appearance of the plot. Here are a few examples

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open System

let ts = [0. .. 0.1 .. 10.]
let sins = ts |> Seq.map (Math.Sin)
let coss = ts |> Seq.map (Math.Cos)

[
    Chart.Scatter(ts, sins, StyleParam.Mode.Markers, Name ="sin");
    Chart.Scatter(ts, coss, StyleParam.Mode.Markers, Name ="cos")
] |> Chart.combine 
  |> Chart.withMarker(Marker.init(10, Line = Line.init(Width=2.)))
  |> Chart.withXAxisStyle("", Zeroline=false)
  |> Chart.withYAxisStyle("", ZeroLine=false)
  |> Chart.withTitle("Styled Scatter")
```

# Setting color

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects
open FSharp.Data
open Deedle

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/iris.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let SepalWidth:float[] = getColumnData "SepalWidth" 
let SepalLength:float[] = getColumnData "SepalLength" 
let PetalLength:float[] = getColumnData "PetalLength"
let PetalWidth:float[] = getColumnData "PetalWidth"
let colors = getColumnData "Name"  |> Array.map (fun name -> match name with
                                                            |"Iris-setosa" -> Color.fromString "red"
                                                            |"Iris-versicolor" -> Color.fromString "blue"
                                                            |_ -> Color.fromString "deeppink") |> Color.fromColors
                                
 

let marker = Marker.init(Color=colors)

Chart.Scatter(x=SepalWidth, y=SepalLength, mode=StyleParam.Mode.Markers, Labels=PetalWidth)
    |> Chart.withXAxisStyle ("sepal_width")
    |> Chart.withYAxisStyle ("sepal_length")
    |> Chart.withMarker(marker)
    
    
    
```

# Data Labels on Hover

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open FSharp.Data
open Plotly.NET.TraceObjects

[<Literal>]
let CsvPath = "https://raw.githubusercontent.com/plotly/datasets/master/2014_usa_states.csv"

type Dataset = CsvProvider<CsvPath>
let datasetItems = Dataset.GetSample()

let postalCodes = datasetItems.Rows |> Seq.map(fun x -> x.Postal)
let population = datasetItems.Rows |> Seq.map(fun x -> x.Population)
let states = datasetItems.Rows |> Seq.map(fun x -> x.State)

let marker = Marker.init()
marker?color <- population 

Chart.Point(postalCodes, population, Labels = states) 
  |> Chart.withMarker(marker)
  |> Chart.withTitle("Population of USA States")
```

# Scatter with a Color Dimension

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let xs = [0. .. 1. .. 500.] 
let ys = xs |> Seq.map (fun _ -> nextFloat(-3., 4.))

let marker = Marker.init(Size = 16, Colorscale=StyleParam.Colorscale.Viridis, Showscale=true)
marker?color <- ys //Workaround

Chart.Point(xs, ys) 
|> Chart.withMarker(marker)
```

# Large Data Sets

In Plotly.NET you can implement WebGL with UseWebGL property for increased speed, improved interactivity, and the ability to plot even more data!

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let series = [0. .. 1. .. 100000.]
let xs = series |> Seq.map (fun x-> nextFloat(-x, x)) 
let ys = series |> Seq.map (fun x-> nextFloat(-x, x))

let marker = Marker.init(Colorscale=StyleParam.Colorscale.Viridis, Line=Line.init(Width=1.))
marker?color <-ys

Chart.Scatter(xs, ys, StyleParam.Mode.Markers, UseWebGL= true) 
  |> Chart.withMarker(marker)

```

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: FSharp.Stats"
```

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

open FSharp.Stats.Distributions

let n  = 100000

let rs = 
    let normal = Continuous.uniform -1. 1.
    Array.init n (fun _ -> normal.Sample())

let thetas = 
    let normal = Continuous.uniform 0.0 (2.*Math.PI)
    Array.init n (fun _ -> normal.Sample())
    
let xs = thetas |> Seq.zip rs |> Seq.map(fun (r,t)-> r*Math.Cos(t) )
let ys = thetas |> Seq.zip rs |> Seq.map(fun (r,t)-> r*Math.Sin(t))

let colors = series |> Seq.map (fun _ -> nextFloat(0. ,1.)) |> Seq.cast<IConvertible> |> Color.fromColorScaleValues
let marker = Marker.init(Colorscale=StyleParam.Colorscale.Viridis, Line=Line.init(Width=01.),Color=colors)


Chart.Scatter(xs, ys, StyleParam.Mode.Markers, UseWebGL= true) 
|> Chart.withMarker(marker)
```
