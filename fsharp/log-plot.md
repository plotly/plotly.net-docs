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
    description: How to make Log plots in F# with Plotly.
    display_as: scientific
    language: fsharp
    layout: base
    name: Log Plots
    order: 1
    page_type: example_index
    permalink: fsharp/log-plot/
    thumbnail: thumbnail/log.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Newtonsoft.Json, 12.0.3"
#r "nuget: Plotly.NET, 2.0.0-preview.10"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.10"
#r "nuget: FSharp.Data"
```

This page shows examples of how to configure 2-dimensional Cartesian axes to follow a logarithmic rather than linear progression. Configuring gridlines, ticks, tick labels and axis titles on logarithmic axes is done the same was as with linear axes.


# Logarithmic Axes

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects
open FSharp.Data

let data = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv")

let x = data.Rows |> Seq.map (fun row -> row.GetColumn("gdpPercap"))
let y = data.Rows |> Seq.map (fun row -> row.GetColumn("lifeExp"))

Chart.Scatter(x=x,y=y,mode=StyleParam.Mode.Markers )
|> Chart.withXAxis(LinearAxis.init(AxisType=StyleParam.AxisType.Log))
```

Setting the range of a logarithmic axis works the same was as with linear axes: using the XAxis Range and YAxis Range keywords on the Layout. 

In the example below, the range of the x-axis is [0, 5] in log units, which is the same as [0, 10000] in linear units.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects
open FSharp.Data

let data = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/gapminder2007.csv")

let x = data.Rows |> Seq.map (fun row -> row.GetColumn("gdpPercap"))
let y = data.Rows |> Seq.map (fun row -> row.GetColumn("lifeExp"))

Chart.Scatter(x=x,y=y,mode=StyleParam.Mode.Markers )
|> Chart.withXAxis(LinearAxis.init(AxisType=StyleParam.AxisType.Log, Range=StyleParam.Range.MinMax(0.,5.))) // log range: 10^0=1, 10^5=100000
|> Chart.withYAxisStyle(title="lifeExp",MinMax=(0.,100.)) // linear range
```
