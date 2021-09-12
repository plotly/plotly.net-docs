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
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data"
```

```fsharp dotnet_interactive={"language": "fsharp"}

```

# Basic Streamtube Plot


```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET 
open FSharp.Data

let x=[0; 0; 0]
let y=[0; 1; 2]
let z=[0; 0; 0]
let u=[0; 0; 0]
let v=[1; 1; 1]
let w=[0; 0; 0]
let margin =Margin.init(Left =20.0, Bottom=20.0,Top =20.0, Right  = 20.0 )
let layout = Layout.init(  Margin=margin)


let streamtube3d  =
        Trace3d.initStreamTube (fun streamtube3d ->
            streamtube3d?x <- x
            streamtube3d?y <-y
            streamtube3d?z <-z
            streamtube3d?u <- u
            streamtube3d?v <-v
            streamtube3d?w <-w
            streamtube3d?sizeref <- 0.3
            streamtube3d?colorscale <- "Portland"
            streamtube3d?showscale <- false
            streamtube3d?maxdisplayed <- 3000
            streamtube3d
            )         
        |> GenericChart.ofTraceObject
        |> Chart.withLayout layout
```

```fsharp dotnet_interactive={"language": "fsharp"}
streamtube3d
```

# Starting Position and Segments



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


```

```fsharp dotnet_interactive={"language": "fsharp"}
let streamtube3d  =
        Trace3d.initStreamTube (fun streamtube3d ->
            streamtube3d?x <- x
            streamtube3d?y <-y
            streamtube3d?z <-z
            streamtube3d?u <- u
            streamtube3d?v <-v
            streamtube3d?w <-w
            streamtube3d?sizeref <- 0.3
            streamtube3d?colorscale <- "Portland"
            streamtube3d?showscale <- false
            streamtube3d?maxdisplayed <- 3000
            streamtube3d
            )         
        |> GenericChart.ofTraceObject
        |> Chart.withLayout layout
```

```fsharp dotnet_interactive={"language": "fsharp"}
streamtube3d
```
