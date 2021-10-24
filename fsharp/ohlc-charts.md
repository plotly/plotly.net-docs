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
    description: How to make interactive OHLC charts in F# with Plotly.      
    display_as: financial
    language: fsharp
    layout: base
    name: OHLC Charts
    order: 5
    page_type: example_index
    permalink: fsharp/ohlc-charts/
    thumbnail: thumbnail/ohlc.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Newtonsoft.Json, 12.0.3"
#r "nuget: Plotly.NET,  2.0.0-preview.10"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.10"
#r "nuget: FSharp.Data"
```

The OHLC chart (for open, high, low and close) is a style of financial chart describing open, high, low and close values for a given x coordinate (most likely time). The tip of the lines represent the low and high values and the horizontal segments represent the open and close values. Sample points where the close value is higher (lower) then the open value are called increasing (decreasing). By default, increasing items are drawn in green whereas decreasing are drawn in red.


# Simple OHLC Chart

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

let _open =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("AAPL.Open"))

let high =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("AAPL.High"))

let close =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("AAPL.Close"))

let low =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("AAPL.Low"))

let date =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("Date"))

Chart.OHLC(``open`` = _open, high = high, close = close, low = low, x = date)

```

# OHLC Chart without Rangeslider

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

let _open =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("AAPL.Open"))

let high =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("AAPL.High"))

let close =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("AAPL.Close"))

let low =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("AAPL.Low"))

let date =
    data.Rows
    |> Seq.map (fun row -> row.GetColumn("Date"))

Chart.OHLC(``open`` = _open, high = high, close = close, low = low, x = date)
|> Chart.withXAxisRangeSlider(rangeSlider=RangeSlider.init(Visible=false))
```

# Adding Customized Text and Annotations

```fsharp dotnet_interactive={"language": "fsharp"}
let annotation =
    Annotation.init (
        X = "2016-12-09",
        Y = 0.05,
        Text = "Increase Period Begins",
        XRef = "x",
        YRef = "paper",
        ShowArrow = false
    )

let line =
    Shape.init (
        StyleParam.ShapeType.Line,
        X0 = "2016-12-09",
        X1 = "2016-12-09",
        Y0 = 0,
        Y1 = 1,
        Xref = "x",
        Yref = "paper",
        Line = Line.init (Width = 1.5)
    )

Chart.OHLC(``open`` = _open, high = high, close = close, low = low, x = date)
|> Chart.withTitle (title = "The Great Recession")
|> Chart.withAnnotations ([ annotation ])
|> Chart.withShapes ([ line ])
|> Chart.withLayout (Layout.init (PlotBGColor = Color.fromString "#e5ecf6", Width = 800))
|> Chart.withXAxisRangeSlider (RangeSlider.init (Visible = false))
```

# Custom OHLC Colors (NOT WORKING)

```fsharp dotnet_interactive={"language": "fsharp"}
Chart.OHLC(
    ``open`` = _open,
    high = high,
    close = close,
    low = low,
    x = date,
    Increasing = Line.init (Color = Color.fromString "cyan"),
    Decreasing = Line.init (Color = Color.fromString "gray")
)

```

# Simple Example with DateTime Objects

```fsharp dotnet_interactive={"language": "fsharp"}
let dates =
    [ for i in 1 .. 5 -> DateTime.Now.AddDays(float i) ]

let open_price = [ 10.0; 5.0; 7.0; 12.0; 10.0 ]
let close = [ 20.0; 3.0; 12.0; 21.0; 5.0 ]
let low = [ 5.0; 1.0; 5.0; 12.0; 3.0 ]
let high = [ 25.0; 10.0; 15.0; 27.0; 15.0 ]

Chart.OHLC(x=dates,``open``=open_price,close=close,low=low,high=high)

```

# Custom Hovertext

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

let _open =
    data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL.Open"))

let high =
    data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL.High"))

let close =
    data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL.Close"))

let low =
    data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL.Low"))

let date =
    data.Rows |> Seq.map (fun row -> row.GetColumn("Date"))

let text =
    data.Rows |> Seq.map (fun row -> "Open:"+row.GetColumn("AAPL.Open")+"<br>Close:"+row.GetColumn("AAPL.Close"))

Chart.OHLC(``open`` = _open, high = high, close = close, low = low, x = date)
|> GenericChart.mapTrace (fun t ->  //Workaround
                            t?text <- text
                            t?hoverinfo <- "text"
                            t)
```
