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
    description: How to make 3D streamtube plots in F# with Plotly.
    display_as: 3d_charts
    language: fsharp
    layout: base
    name: 3D Streamtube Plots
    order: 9
    page_type: u-guide
    permalink: fsharp/streamtube-plot/
    thumbnail: thumbnail/streamtube.jpg
---

// can't yet format YamlFrontmatter (["title: 3D Mesh plots"; "category: 3D Charts"; "categoryindex: 4"; "index: 4"], Some { StartLine = 2 StartColumn = 0 EndLine = 6 EndColumn = 8 }) to pynb markdown



```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data"
```

# Basic Streamtube Plot


```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET
open FSharp.Data

let x=[0, 0, 0]
let y=[0, 1, 2]
let z=[0, 0, 0]
let u=[0, 0, 0]
let v=[1, 1, 1]
let w=[0, 0, 0]
let margin =Margin.init(Left =20.0, Bottom=20.0,Top =20.0, Right  = 20.0 )
let layout = Layout.init(  Margin=margin)


let mesh3d  =
        Trace3d.initStreamTube (fun mesh3d ->
            mesh3d?x <- x
            mesh3d?y <-y
            mesh3d?z <-z
            mesh3d?u <- u
            mesh3d?v <-v
            mesh3d?w <-w
            mesh3d?sizeref <- 0.3
            mesh3d?colorscale <- "Portland"
            mesh3d?showscale <- false
            mesh3d?maxdisplayed <- 3000
            mesh3d
            )
        |> GenericChart.ofTraceObject
        |> Chart.withLayout layout
```

```fsharp dotnet_interactive={"language": "fsharp"}
mesh3d
```

# Simple 3D Mesh example


```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET
open FSharp.Data

type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/master/streamtube-wind.csv">
let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/master/streamtube-wind.csv")

let x=[for row in df1.Rows do row.X]
let y=[for row in df1.Rows do row.Y]
let z=[for row in df1.Rows do row.Z]
let u=[for row in df1.Rows do row.U]
let v=[for row in df1.Rows do row.V]
let w=[for row in df1.Rows do row.W]
let margin =Margin.init(Left =20.0, Bottom=20.0,Top =20.0, Right  = 20.0 )
let layout = Layout.init(  Margin=margin)


let mesh3d  =
        Trace3d.initStreamTube (fun mesh3d ->
            mesh3d?x <- x
            mesh3d?y <-y
            mesh3d?z <-z
            mesh3d?u <- u
            mesh3d?v <-v
            mesh3d?w <-w
            mesh3d?sizeref <- 0.3
            mesh3d?colorscale <- "Portland"
            mesh3d?showscale <- false
            mesh3d?maxdisplayed <- 3000
            mesh3d
            )
        |> GenericChart.ofTraceObject
        |> Chart.withLayout layout
```

```fsharp dotnet_interactive={"language": "fsharp"}
mesh3d
```
