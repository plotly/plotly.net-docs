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
    description: How to make Heatmaps in F# with Plotly.
    display_as: scientific
    language: fsharp
    layout: base
    name: Heatmaps
    order: 2
    page_type: example_index
    permalink: fsharp/heatmaps/
    thumbnail: thumbnail/heatmap.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"

#r "nuget: Deedle"
#r "nuget: FSharp.Data"
```

# Basic Heatmap

```fsharp dotnet_interactive={"language": "fsharp"}
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

```fsharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data

let volcano =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/volcano.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

Chart.Heatmap(data=Frame.toJaggedArray(volcano))
```

# Sequential Colorscales: Greys

```fsharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data

let volcano =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/volcano.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

Chart.Heatmap(data=Frame.toJaggedArray(volcano),Colorscale=StyleParam.Colorscale.Greys)
```

# Custom colorscales

```fsharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data

let volcano =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/volcano.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let customColorscale = StyleParam.Colorscale.Custom [(0.0,"red");(1.0,"green")]

Chart.Heatmap(data=Frame.toJaggedArray(volcano),Colorscale=customColorscale)
```
