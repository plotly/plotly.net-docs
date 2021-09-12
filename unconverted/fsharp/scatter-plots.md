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
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: newtonsoft.json"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

open System
open System.Drawing
let random = System.Random();

let nextFloat (min, max) = (random.NextDouble() * (max - min) + min);

```

# Scatter and line plots with go.Scatter


## Simple Scatter Plot

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let ts = [0. .. 0.1 .. 10.]
let ys = ts |> Seq.map (Math.Sin)
Chart.Scatter(ts, ys, StyleParam.Mode.Markers)
```

## Line and Scatter Plots

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let n = 100.
let random_x = [0. .. 1. .. n]

let generate() = random_x |> Seq.map (fun _-> nextFloat(-2., 2.))

let random_y0 = generate () |> Seq.map(fun x-> x + 5.)
let random_y1 = generate ()
let random_y2 = generate () |> Seq.map(fun x-> x - 5.)

[
    Chart.Scatter(random_x, random_y0, StyleParam.Mode.Markers, Name="Markers");
    Chart.Scatter(random_x, random_y1, StyleParam.Mode.Lines_Markers, Name="Lines_Markers");
    Chart.Scatter(random_x, random_y2, StyleParam.Mode.Lines, Name="Lines");
] |> Chart.Combine
```

## Bubble Scatter Plots

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let xs =[1; 2; 3; 4]
let ys =[10;11; 12; 13]

let marker = Marker.init(MultiSizes=[40; 60; 80; 100]);
marker?color <- ["#4287f5";"#cb23fa";"#23fabd";"#ff7b00"]; 

Chart.Scatter(xs, ys, StyleParam.Mode.Markers, Name="Markers")
        |> Chart.withMarker(marker)
```

## Style Scatter Plots

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET
open System

let ts = [0. .. 0.1 .. 10.]
let sins = ts |> Seq.map (Math.Sin)
let coss = ts |> Seq.map (Math.Cos)

[
    Chart.Scatter(ts, sins, StyleParam.Mode.Markers, Name ="sin", Color = "rgba(152, 0, 0, .8)");
    Chart.Scatter(ts, coss, StyleParam.Mode.Markers, Name ="cos", Color = "rgba(255, 182, 193, .9)")
] |> Chart.Combine 
  |> Chart.withMarker(Marker.init(10, Line = Line.init(Width=2.)))
  |> Chart.withX_AxisStyle("", Zeroline=false)
  |> Chart.withY_AxisStyle("", Zeroline=false)
  |> Chart.withTitle("Styled Scatter")
```

## Data Labels on Hover

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data, 4.2.2"
open Plotly.NET
open FSharp.Data

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

## Scatter with a Color Dimension

```csharp dotnet_interactive={"language": "fsharp"}
let xs = [0. .. 1. .. 500.] 
let ys = xs |> Seq.map (fun _ -> nextFloat(-3., 4.))

let marker = Marker.init(Size = 16, Colorscale=StyleParam.Colorscale.Viridis, Showscale=true);
marker?color <- ys
Chart.Point(xs, ys) 
  |> Chart.withMarker(marker)
```

## Large Data Sets

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let series = [0. .. 1. .. 100000.]
let xs = series |> Seq.map (fun x-> nextFloat(-x, x)) 
let ys = series |> Seq.map (fun x-> nextFloat(-x, x))

let marker = Marker.init(Colorscale=StyleParam.Colorscale.Viridis, Line=Line.init(Width=1.))
marker?color <-ys

Chart.Scatter(xs, ys, StyleParam.Mode.Markers, UseWebGL= true) 
  |> Chart.withMarker(marker)

```

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let n  = 100000
let series = [1 .. n]
let rs = series |> Seq.map (fun _ -> nextFloat(0. ,1.))
let thetas = series |> Seq.map (fun _ -> nextFloat(0. ,2.*Math.PI))
let xs = thetas |> Seq.zip rs |> Seq.map(fun (t,r)-> Math.Cos(r*t) )
let ys = thetas |> Seq.zip rs |> Seq.map(fun (t,r)-> Math.Sin(r*t))

let marker = Marker.init(Colorscale=StyleParam.Colorscale.Viridis, Line=Line.init(Width=01.))
                      marker?color<-series |> Seq.map (fun _ -> nextFloat(0. ,1.))

Chart.Scatter(xs, ys, StyleParam.Mode.Markers, UseWebGL= true) 
  |> Chart.withMarker(marker)
```

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let x=[|0; 1; 2; 3; 4|]
let y=[|0; 1; 4; 9; 16|]

Chart.Scatter(x, y , StyleParam.Mode.Markers_Text)
    |> Chart.withX_AxisStyle ("x")
    |> Chart.withY_AxisStyle ("y")

```

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data, 4.2.2"
open Plotly.NET
open FSharp.Data

[<Literal>]
let IrisDatasetUrl = 
    "https://gist.githubusercontent.com/netj/8836201/raw/6f9306ad21398ea43cba4f7d537619d0e07d5ae3/iris.csv"

type IrisDataset = CsvProvider<IrisDatasetUrl>
let datasetItems = IrisDataset.GetSample()

let iris = {| sepal_length = datasetItems.Rows |> Seq.map(fun i -> i.``Sepal.length``)
              speal_width = datasetItems.Rows |> Seq.map(fun i -> i.``Sepal.width``)
              petal_length = datasetItems.Rows |> Seq.map(fun i -> i.``Petal.length``)
              petal_width = datasetItems.Rows |> Seq.map(fun i -> i.``Petal.width``)
              species  = datasetItems.Rows |> Seq.map(fun i -> i.Variety)|}

Chart.Scatter(iris.speal_width, iris.sepal_length,StyleParam.Mode.Markers)
    |> Chart.withX_AxisStyle ("sepal_width")
    |> Chart.withY_AxisStyle ("sepal_length")

```

<!-- #region dotnet_interactive={"language": "fsharp"} -->
## Setting size and color with column names
<!-- #endregion -->

```csharp dotnet_interactive={"language": "fsharp"}

let marker = Marker.init(MultiSizes=iris.petal_length);
marker?color <- iris.species;

Chart.Scatter(iris.speal_width, iris.sepal_length, StyleParam.Mode.Markers, Labels=iris.petal_width)
    |> Chart.withX_AxisStyle ("sepal_width")
    |> Chart.withY_AxisStyle ("sepal_length")
    |> Chart.withMarker(marker)
```

##Line plot with Plotly.NET

```csharp dotnet_interactive={"language": "fsharp"}
let marker = Marker.init()
marker?color <- iris.species
marker?symbol <- iris.species

Chart.Scatter(iris.speal_width, iris.sepal_length,StyleParam.Mode.Markers, Labels=iris.petal_width)
    |> Chart.withX_AxisStyle ("sepal_width")
    |> Chart.withY_AxisStyle ("sepal_length")
    |> Chart.withMarker(marker)
```

```csharp dotnet_interactive={"language": "fsharp"}
let marker = Marker.init(Showscale = true);
marker?color <- iris.petal_length

Chart.Scatter(iris.speal_width, iris.sepal_length,StyleParam.Mode.Markers, Labels=iris.petal_width)
    |> Chart.withX_AxisStyle ("sepal_width")
    |> Chart.withY_AxisStyle ("sepal_length")
    |> Chart.withMarker(marker)
```

<!-- #region dotnet_interactive={"language": "fsharp"} -->
## Scatter plots and Categorical Axes
<!-- #endregion -->

```csharp dotnet_interactive={"language": "fsharp"}
let nation = ["South Korea";"China";"Canada"]
let matel = ["gold";"silver";"bronze"]
let gold = [24;10;9]
let silver = [13;15;12]
let bronze = [11;8;12]
```

```csharp dotnet_interactive={"language": "fsharp"}
let marker = Marker.init(Size=10);
marker?color <- matel
marker?symbol <- matel

Chart.Scatter([1 .. 25], nation,StyleParam.Mode.Markers, Labels=iris.petal_width)
    |> Chart.withX_AxisStyle ("sepal_width")
    |> Chart.withY_AxisStyle ("sepal_length")
    |> Chart.withMarker(marker)
```

```csharp dotnet_interactive={"language": "fsharp"}
let marker = Marker.init(MultiSizes=iris.petal_length);
marker?color <- iris.petal_length; 

Chart.Scatter(iris.speal_width, iris.sepal_length,StyleParam.Mode.Markers)
    |> Chart.withMarker(marker)
    |> Chart.withX_AxisStyle ("sepal_width")
    |> Chart.withY_AxisStyle ("sepal_length")
```

```csharp dotnet_interactive={"language": "fsharp"}
let marker = Marker.init(MultiSizes=iris.petal_length);
marker?color <- iris.petal_length; 

Chart.Scatter(iris.speal_width, iris.sepal_length,StyleParam.Mode.Markers)
    |> Chart.withMarker(marker)
    |> Chart.withX_AxisStyle ("sepal_width")
    |> Chart.withY_AxisStyle ("sepal_length")
```

### Some random data generators

```csharp dotnet_interactive={"language": "fsharp"}

open Plotly.NET
open System
let random = System.Random();

let nextFloat (min, max) = (random.NextDouble() * (max - min) + min);

let size = nextFloat(10.,15.)
let series = [1. .. size]
let generateRangedRandomData minValue maxValue  = series |> Seq.map (fun _ -> nextFloat(minValue, maxValue))
let generateRandomData ()  = 
    let max = nextFloat(1.,100.)
    generateRangedRandomData 1. max  
```

```csharp dotnet_interactive={"language": "fsharp"}
let yellowXs = generateRandomData() 
let yellowYs = generateRandomData()
let yellowSizes = generateRangedRandomData 10. 20.

let yellowChart = 
    Chart.Bubble(yellowXs,yellowYs,yellowSizes, Name = "Yellow", Color="#ebcc34")
    

let blueXs = generateRandomData() 
let blueYs = generateRandomData()
let blueSizes = generateRangedRandomData 10. 20.
let blueChart = 
    Chart.Bubble(blueXs,blueYs,blueSizes, Name = "Blue", Color = "#3471eb")


[
    yellowChart;
    blueChart
    
] |> Chart.Combine
  |> Chart.withX_AxisStyle ("X axis title")
  |> Chart.withY_AxisStyle ("Y axis title")
  |> Chart.withLayout(Layout.init(Hovermode = StyleParam.Hovermode.Y))
```



```csharp dotnet_interactive={"language": "fsharp"}
let marker = Marker.init(Showscale=true, Colorbar= Colorbar.init(Title="petal_length"));
marker?color <- iris.petal_length; 

Chart.Scatter(iris.speal_width, iris.sepal_length,StyleParam.Mode.Markers)
    |> Chart.withMarker(marker)
    |> Chart.withX_AxisStyle ("sepal_width")
    |> Chart.withY_AxisStyle ("sepal_length")
```

```csharp dotnet_interactive={"language": "fsharp"}
let marker = Marker.init(Showscale=true);
marker?color <- iris.petal_length; 

Chart.Scatter(iris.speal_width, iris.sepal_length, StyleParam.Mode.Markers)
    |> Chart.withMarker(marker)
    |> Chart.withX_AxisStyle ("sepal_width")
    |> Chart.withY_AxisStyle ("sepal_length")
```

```csharp dotnet_interactive={"language": "fsharp"}

let degreesToRadians degrees = degrees * Math.PI / 180.


let xs = {0. .. Math.PI * 2. .. 360.}
let ys = xs |> Seq.map  (degreesToRadians >> Math.Cos)

Chart.Line(xs, ys)
    |> Chart.withX_AxisStyle ("t")
    |> Chart.withY_AxisStyle ("cos(t)")
    |> Chart.withLayout(Layout.init(Hovermode = StyleParam.Hovermode.Closest))
```

```csharp dotnet_interactive={"language": "fsharp"}

let yellowXs = [1960 ..10 .. 2000]
let yellowYs = [70 .. 2 .. 80]

let blueXs = [1960 .. 10 .. 2000]
let blueYs = [65 .. 2 .. 80]

let yellowChart = 
    Chart.Line(yellowXs, yellowYs, Name = "Yellow", Color="#ebcc34")
let blueChart = 
    Chart.Line(blueXs,blueYs, Name = "Blue", Color = "#3471eb")


[
    yellowChart;
    blueChart
    
] |> Chart.Combine
  |> Chart.withX_AxisStyle ("X axis title")
  |> Chart.withY_AxisStyle ("Y axis title")
  |> Chart.withLayout(Layout.init(Hovermode = StyleParam.Hovermode.Closest))
```
