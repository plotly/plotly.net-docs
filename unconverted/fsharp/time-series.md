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
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.7"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.7"
#r "nuget: Deedle"
#r "nuget: FSharp.Data"

```

# Time Series using Axes of type date


```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open FSharp.Data
open Deedle

let dataset = 
  Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv"
   |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

```

```fsharp dotnet_interactive={"language": "fsharp"}
let getColumn column=
        dataset
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq
let scatter =
            Chart.Scatter(getColumn "Date",getColumn "AAPL.High",mode = StyleParam.Mode.Lines_Markers)
```

```fsharp dotnet_interactive={"language": "fsharp"}
scatter
```

# Displaying Period Data


```fsharp dotnet_interactive={"language": "fsharp"}
let date=["2020-01-10"; "2020-02-10"; "2020-03-10"; "2020-04-10"; "2020-05-10"; "2020-06-10"]
let value=[1;2;3;1;2;3]

let layout =
    let temp = Layout()
    temp?ticklabelmode <- "period"
    temp?showgrid <- true
    temp

[
Chart.Scatter(date,value,mode = StyleParam.Mode.Lines_Markers, Name="Raw Data",MarkerSymbol=StyleParam.Symbol.Asterisk)
Chart.Scatter(date,value,mode = StyleParam.Mode.Lines_Markers, Name="Start-aligned")
|> GenericChart.mapTrace(fun x -> 
        x.SetValue("xperiod", "M1")
        x.SetValue("xperiodalignment", "start")
        x)
Chart.Scatter(date,value,mode = StyleParam.Mode.Lines_Markers, Name="Middle-aligned")
|> GenericChart.mapTrace(fun x -> 
        x.SetValue("xperiod", "M1")
        x.SetValue("xperiodalignment", "middle")
        x)
Chart.Scatter(date,value,mode = StyleParam.Mode.Lines_Markers, Name="End-aligned")
|> GenericChart.mapTrace(fun x -> 
        x.SetValue("xperiod", "M1")
        x.SetValue("xperiodalignment", "end")
        x)
Chart.Column(date,value, Name="Bar-Middle-aligned",Color="rgba(247, 156, 83, 0.86)")
|> GenericChart.mapTrace(fun x -> 
        x.SetValue("xperiod", "M1")
        x.SetValue("xperiodalignment", "middle")
        x)
]


|>Chart.combine
|> Chart.withLayout(layout)
```

# Hover Templates with Mixtures of Period data


```fsharp dotnet_interactive={"language": "fsharp"}
let x0=["2020-01-01"; "2020-04-01"; "2020-07-01"]
let y0=[1000; 1500; 1700]
let x1=["2020-01-01"; "2020-02-01"; "2020-03-01";
      "2020-04-01"; "2020-05-01"; "2020-06-01";
      "2020-07-01"; "2020-08-01"; "2020-09-01"]
let y1=[1100;1050;1200;1300;1400;1700;1500;1400;1600]

[
Chart.Column(x0,y0,Color="rgba(103, 102, 255,1)")
|> GenericChart.mapTrace(fun x -> 
        x.SetValue("xperiod", "M1")
        x.SetValue("xperiodalignment", "middle")
        x)
Chart.Scatter(x1,y1,mode = StyleParam.Mode.Lines_Markers)
|> GenericChart.mapTrace(fun x -> 
        x.SetValue("xperiod", "M1")
        x.SetValue("xperiodalignment", "middle")
        x)
]
|>Chart.combine
```
