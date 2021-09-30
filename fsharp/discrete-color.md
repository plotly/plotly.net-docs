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
    description: How to use and configure discrete color sequences, also known as
      categorical or qualitative color scales.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Discrete Colors
    order: 28
    page_type: example_index
    permalink: fsharp/discrete-color/
    thumbnail: thumbnail/heatmap_colorscale.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"

#r "nuget: Deedle"
#r "nuget: FSharp.Data"
```

color can be used to represent continuous or discrete data.
Marker Color can be used to set discrete colors to individual points as shown in the below example. This page is about using color to represent categorical data using discrete colors, but Plotly.NET can also represent continuous values with color.

```fsharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data
open Plotly.NET

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/tips.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")
    

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let x  = [1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.; ]
let y = [2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]

let colors = ["red"; "magenta"; "yellow"; "blue"; "deeppink";
                "orangered"; "black"; "gray"; "aliceblue"; "cyan"]
                |> Seq.map (fun c -> Color.fromString c)
                |> Color.fromColors

Chart.Point(x,y,Name="line",Color=colors)  


```

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let x=[1; 2; 3; 4]
let y=[10; 11; 12; 13]

let colors = 
    ["rgb(160, 164, 214)"; "rgb(255, 144, 14)";  "rgb(44, 160, 101)"; "rgb(255, 65, 54)"]
    |> Seq.map (fun c -> Color.fromString(c))
    |> Color.fromColors

let marker = Marker.init(Color=colors)

Chart.Scatter(x,y,StyleParam.Mode.Markers)
    |> Chart.withMarker(marker)
```
