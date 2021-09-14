---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.4.2
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
    description: How to format axes of 3D Cone plots in F# with Plotly.
    display_as: 3d_charts
    language: fsharp
    layout: base
    name: 3D Cone Plots
    order: 9
    page_type: u-guide
    permalink: fsharp/3d-cone/
    thumbnail: thumbnail/3dcone.png
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data, 4.2.2"
```

# Basic 3D Cone


```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET

let cone3d =
    Trace3d.initCone
        (fun cone3d ->
            cone3d?x <- [1]
            cone3d?y <- [1]
            cone3d?z <- [1]
            cone3d?u <- [1]
            cone3d?v <- [1]
            cone3d?w <- [0]
            cone3d?colorscale<-"Blues"
            cone3d?sizemode<-"absolute"
            cone3d?sizeref<- 20,
            cone3d?anchor<-"tip"
            cone3d
            )
    |> GenericChart.ofTraceObject
```

```fsharp dotnet_interactive={"language": "fsharp"}
cone3d

```

# Multiple 3D Cones


```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET


let cone3d =
    Trace3d.initCone
        (fun cone3d ->
            cone3d?x<-[1; 2; 3]
            cone3d?y<-[1; 2; 3]
            cone3d?z<-[1; 2; 3]
            cone3d?u<-[1; 0; 0]
            cone3d?v<-[0; 3; 0]
            cone3d?w<-[0; 0; 2]
            cone3d?sizemode<-"absolute"
            cone3d?sizeref<-2
            cone3d?anchor<-"tip"
            cone3d
            )
    |> GenericChart.ofTraceObject
```

```fsharp dotnet_interactive={"language": "fsharp"}
cone3d
```
