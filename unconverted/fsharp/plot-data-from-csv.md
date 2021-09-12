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
#r "nuget: Plotly.NET,*-*"
#r "nuget: Plotly.NET.Interactive,*-*"
#r "nuget: FSharp.Data"
#r "nuget:Deedle"
```

# Plot from CSV with Plotly

```csharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Deedle
open Plotly.NET
open Plotly.NET.Axis

let dataset = 
  Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/2014_apple_stock.csv"
   |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumn column=
        dataset
        |> Frame.getCol column
        |> Series.values
         
let xy = Seq.zip  (getColumn "AAPL_x" :> seq<DateTime>) (getColumn "AAPL_y" :> seq<float>) 
Chart.Line(xy,Name="Share Prices (in USD)")
|>Chart.withLayout(Layout.init(Title.init("Apple Share Prices over time (2014)"),Plot_bgcolor="#e5ecf6",Showlegend=true,Width=1100.))
|>Chart.withXAxis(LinearAxis.init(Title=Title.init("AAPL_x"),ZeroLineColor="#ffff",ZeroLineWidth=2.,GridColor="#ffff" ))
|>Chart.withYAxis(LinearAxis.init(Title=Title.init("AAPL_y"),ZeroLineColor="#ffff",ZeroLineWidth=2.,GridColor="#ffff" ))

```
