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

#r "nuget: Deedle"
#r "nuget: FSharp.Data"
```

# Basic Heatmap

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET 

let matrix =
    [[1.;1.5;0.7;2.7];
    [2.;0.5;1.2;1.4];
    [0.1;2.6;2.4;3.0];]

let rownames = ["p3";"p2";"p1"]
let colnames = ["Tp0";"Tp30";"Tp60";"Tp160"]

let colorscaleValue = 
    StyleParam.Colorscale.Custom [(0.0,"#3D9970");(1.0,"#001f3f")]

Chart.Heatmap(
    data=matrix,ColNames=colnames,RowNames=rownames,
    Colorscale=colorscaleValue,
    Showscale=true
)
|> Chart.withSize(700.,500.)
|> Chart.withMarginSize(Left=200.)
```

```csharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data

let volcano = 
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/volcano.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

Chart.Heatmap(data=Frame.toJaggedArray(volcano))
```

# Sequential Colorscales: Greys

```csharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data

let volcano = 
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/volcano.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

Chart.Heatmap(data=Frame.toJaggedArray(volcano),Colorscale=StyleParam.Colorscale.Greys)
```

# Custom colorscales

```csharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data

let volcano = 
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/volcano.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let customColorscale = StyleParam.Colorscale.Custom [(0.0,"red");(1.0,"green")]

Chart.Heatmap(data=Frame.toJaggedArray(volcano),Colorscale=customColorscale)
```
