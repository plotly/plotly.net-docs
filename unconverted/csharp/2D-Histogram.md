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
    description: How to make 2D Histograms in F# with Plotly.
    display_as: statistical
    language: fsharp
    layout: base
    name: 2D Histograms
    order: 5
    page_type: example_index
    permalink: fsharp/2D-Histogram/
    thumbnail: thumbnail/histogram2d.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Newtonsoft.Json, 12.0.3"
#r "nuget: Plotly.NET, 2.0.0-preview.9"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.9"
#r "nuget: Deedle"
#r "nuget: FSharp.Data"
#r "nuget: FSharp.Stats"
```

# 2D Histograms or Density Heatmaps
A 2D histogram, also known as a density heatmap, is the 2-dimensional generalization of a histogram which resembles a heatmap but is computed by grouping a set of points specified by their x and y coordinates into bins, and applying an aggregation function such as count or sum (if z is provided) to compute the color of the tile representing the bin. This kind of visualization (and the related 2D histogram contour, or density contour) is often used to manage over-plotting, or situations where showing large data sets as scatter plots would result in points overlapping each other and hiding patterns.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Deedle
open FSharp.Data

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/tips.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")
    

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let y:float[] = getColumnData "tip"
let x:float[] = getColumnData "total_bill"

Chart.Histogram2d(x,y,Showscale=true)
```

The number of bins can be controlled with nBinsx and nBinsy and the color scale with colorscale.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Deedle
open FSharp.Data

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/tips.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")
    

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let y:float[] = getColumnData "tip"
let x:float[] = getColumnData "total_bill"

Chart.Histogram2d(x,y,Showscale=true,nBinsx=20,nBinsy=20,Colorscale=StyleParam.Colorscale.Viridis)
```

# 2D Histogram of a Bivariate Normal Distribution

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Stats.Distributions

let n  = 20

let xs = 
    let normal = Continuous.normal 500. 20.
    [300..700]|> Seq.map (fun x -> normal.Sample())

let ys = 
    let normal = Continuous.normal 500. 20.
    [300..700]|> Seq.map (fun x -> normal.Sample())

Chart.Histogram2d(x=xs,y=ys,nBinsx=n,nBinsy=n)
```

# 2D Histogram Binning and Styling Options

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Stats.Distributions
open Plotly.NET.TraceObjects

let n  = 20

let xs = 
    let normal = Continuous.normal 500. 20.
    [300..700]|> Seq.map (fun x -> normal.Sample())

let ys = 
    let normal = Continuous.normal 500. 20.
    [300..700]|> Seq.map (fun x -> normal.Sample())

let customColorscale =
    StyleParam.Colorscale.Custom [ (0.0, "rgb(12,51,131)")
                                   (0.25, "rgb(10,136,186)")
                                   (0.5, "rgb(242,211,56)")
                                   (0.75, "rgb(242,143,56)")
                                   (1.0, "rgb(217,30,30)") ]


Chart.Histogram2d(
    x = xs,
    y = ys,
    xBins = Bins.init (StartBins = 440., EndBins = 570., Size = 5.),
    yBins = Bins.init (StartBins = 440., EndBins = 570., Size = 5.),
    HistNorm = StyleParam.HistNorm.Probability,
    Colorscale= customColorscale
)  
```

# 2D Histogram Overlaid with a Scatter Chart

```fsharp dotnet_interactive={"language": "fsharp"}
open System

let rand = new Random()

let x0 = [for i in 1..100 -> rand.NextDouble()]
let y0 = [for i in 1..100 -> rand.NextDouble()]

let x1 = [for i in 1..50 -> rand.NextDouble()]
let y1 = [for i in 1..50 -> rand.NextDouble()]

let x = x0 @ x1
let y =  y0 @ y1

let chart1 =
    Chart.Scatter(x = x0, y = y0, mode = StyleParam.Mode.Markers, ShowLegend = false)
    |> Chart.withMarkerStyle (
        Size = 8,
        Color = Color.fromString "white",
        Opacity = 0.7,
        Outline = Line.init (Width = 1.),
        Symbol = StyleParam.MarkerSymbol.X
    )

let chart2 =
    Chart.Scatter(x = x1, y = y1, mode = StyleParam.Mode.Markers, ShowLegend = false)
    |> Chart.withMarkerStyle (
        Size = 8,
        Color = Color.fromString "white",
        Opacity = 0.7,
        Outline = Line.init (Width = 1.)
    )

let histogra2D =
    Chart.Histogram2d(x, y, Colorscale = StyleParam.Colorscale.YIGnBu)

[ chart1; chart2; histogra2D ]
|> Chart.combine
|> Chart.withXAxisStyle (title = "", ShowGrid = false, Zeroline = false)
|> Chart.withYAxisStyle (title = "", ShowGrid = false, ZeroLine = false)
```
