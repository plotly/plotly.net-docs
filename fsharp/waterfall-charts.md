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
    description: How to make waterfall plots in F# with Plotly.      
    display_as: financial
    language: fsharp
    layout: base
    name: Waterfall Charts
    order: 3
    page_type: example_index
    permalink: fsharp/waterfall-charts/
    thumbnail: thumbnail/waterfall-charts.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Newtonsoft.Json, 12.0.3"
#r "nuget: Plotly.NET,  2.0.0-preview.10"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.10"
```

# Simple Waterfall Chart

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let x =
    [ "Sales"
      "Consulting"
      "Net revenue"
      "Purchases"
      "Other expenses"
      "Profit before tax" ]

let y = [ 60; 80; 0; -40; -20; 0 ]

let measure =
    [ StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Total
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Total ]

Chart.Waterfall(
    x = x,
    y = y,
    Measure = measure,
    Connector = WaterfallConnector.init (Line = Line.init (Color = Color.fromString "rgb(63, 63, 63)"))
)
|> GenericChart.mapTrace //Workaround
    (fun t ->
        t?text <- [ "+60";"+80";"";"-40";"-20";"Total" ]
        t?textposition <- "outside"
        t)

```

# Horizontal Waterfall Chart

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [375.; 128.; 78.; 27.; Double.NaN; -327.; -12.; -78.; -12.; Double.NaN; 32.; 89.; Double.NaN; -45.; Double.NaN]

let measure =
    [ StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Total
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Total
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Total
      StyleParam.WaterfallMeasure.Relative
      StyleParam.WaterfallMeasure.Total ]

let y =
    [ "Sales"
      "Consulting"
      "Maintenance"
      "Other revenue"
      "Net revenue"
      "Purchases"
      "Material expenses"
      "Personnel expenses"
      "Other expenses"
      "Operating profit"
      "Investment income"
      "Financial income"
      "Profit before tax"
      "Income tax (15%)"
      "Profit after tax" ]

Chart.Waterfall(
    x = x,
    y = y,
    Measure = measure,
    Orientation = StyleParam.Orientation.Horizontal,
    Connector =
        WaterfallConnector.init (
            ConnectorMode = StyleParam.ConnectorMode.Between,
            Line = Line.init (Color = Color.fromString "rgb(0,0,0)", Dash = StyleParam.DrawingStyle.Solid, Width = 4.)
        )
)
|> Chart.withTitle ("Profit and loss statement 2018")
|> Chart.withTraceName ("2018")
|> Chart.withMarginSize (Left = 150)

```
