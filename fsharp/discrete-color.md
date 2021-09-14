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
    order: 29
    page_type: example_index
    permalink: fsharp/discrete-color/
    thumbnail: thumbnail/heatmap_colorscale.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"

#r "nuget: Deedle"
#r "nuget: FSharp.Data"


```

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
let y' = [2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]

Chart.Point(x,y',Name="line")




```
