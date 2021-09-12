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
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
#r "nuget:Deedle"
#r "nuget: FSharp.Data"
```

# Simple Candlestick

```csharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data
open Plotly.NET
open System.Globalization

let dataset = 
  Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv"
   |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumn column=
        dataset
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let format = "MM/dd/yyyy hh:mm:ss"
let provider = CultureInfo.InvariantCulture

let getDateTime d= DateTime.ParseExact(string(d),format,provider)

let stockData = dataset 
                |> Frame.mapRows (fun k v -> (v.Get("Date") |> getDateTime ,StockData.Create(v?``AAPL.Open``,v?``AAPL.High``,v?``AAPL.Low``,v?``AAPL.Close``)) )
                |> Series.values 
                |> Array.ofSeq

Chart.Candlestick(stockData)

```

# Candlestick without Rangeslider

```csharp dotnet_interactive={"language": "fsharp"}

Chart.Candlestick(stockData)
|> Chart.withXAxisRangeSlider(RangeSlider.init(Visible=false))

```

# Adding Customized Text and Annotations

```csharp dotnet_interactive={"language": "fsharp"}
let annotation = Annotation.init(X="2016-12-09",Y=0.05,Text="Increase Period Begins",XRef="x", YRef="paper",ShowArrow=false)
let line = Shape.init(StyleParam.ShapeType.Line, X0="2016-12-09", X1="2016-12-09", Y0=0, Y1=1,Xref="x",Yref="paper",Line=Line.init(Width=1.5))

Chart.Candlestick(stockData)
|> Chart.withTitle(title="The Great Recession")
|> Chart.withAnnotations([annotation])
|> Chart.withShapes([line])
|> Chart.withLayout(Layout.init(Plot_bgcolor="#e5ecf6",Width=800.0))
|> Chart.withXAxisRangeSlider(RangeSlider.init(Visible=false))
```

# Custom Candlestick Colors (Not Working)

```csharp dotnet_interactive={"language": "fsharp"}
Chart.Candlestick(stockData,Increasing=Line.init(Color="cyan"),Decreasing=Line.init(Color="gray"))
```

# Simple Example

```csharp dotnet_interactive={"language": "csharp"}
let dates = [for i in 1..5 -> DateTime.Now.AddDays(float i)]
let open_price = [10.0;5.0;7.0;12.0;10.0]
let close = [20.0;3.0;12.0;21.0;5.0]
let low = [5.0;1.0;5.0;12.0;3.0]
let high = [25.0;10.0;15.0;27.0;15.0]

let stock_data = [for i in 0..4 -> (dates.[i], StockData.Create(o=open_price.[i],h=high.[i],l=low.[i],c=close.[i]))]

Chart.Candlestick(stock_data)
```
