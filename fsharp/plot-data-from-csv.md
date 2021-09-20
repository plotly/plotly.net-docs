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
    description: How to create charts from csv files with Plotly and F#
    display_as: advanced_opt
    language: fsharp
    layout: base
    name: Plot CSV Data
    order: 1
    page_type: example_index
    permalink: fsharp/plot-data-from-csv/
    thumbnail: thumbnail/csv.jpg
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
#r "nuget: FSharp.Data"
#r "nuget:Deedle"
```

# Plot from CSV with Plotly

```fsharp  dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Deedle
open Plotly.NET
open Plotly.NET.LayoutObjects

let dataset = 
  Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/2014_apple_stock.csv"
   |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumn column=
        dataset
        |> Frame.getCol column
        |> Series.values
         
let xy = Seq.zip  (getColumn "AAPL_x" :> seq<DateTime>) (getColumn "AAPL_y" :> seq<float>) 
Chart.Line(xy,Name="Share Prices (in USD)")
|>Chart.withLayout(Layout.init(Title.init("Apple Share Prices over time (2014)"),PlotBGColor=Color.fromString "#e5ecf6",ShowLegend=true,Width=1100.))
|>Chart.withXAxis(LinearAxis.init(Title=Title.init("AAPL_x"),ZeroLineColor=Color.fromString"#ffff",ZeroLineWidth=2.,GridColor=Color.fromString"#ffff" ))
|>Chart.withYAxis(LinearAxis.init(Title=Title.init("AAPL_y"),ZeroLineColor=Color.fromString"#ffff",ZeroLineWidth=2.,GridColor=Color.fromString"#ffff" ))

```
