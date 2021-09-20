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
    description: How to make 3D scatter plots in F# with Plotly.
    display_as: 3d_charts
    language: fsharp
    layout: base
    name: 3D Scatter Plots
    order: 2
    page_type: example_index
    permalink: fsharp/3d-scatter-plots/
    thumbnail: thumbnail/3d-scatter.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
// #r "nuget: Plotly.NET, 2.0.0-preview.6"
// #r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"

#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
open Plotly.NET
```

# Basic 3D Scatter Plot


### Basic 3D Scatter Plot



If Plotly Express does not provide a good starting point, it is also possible to use the more generic go.Scatter3D class from plotly.graph_objects. Like the 2D scatter plot go.Scatter, go.Scatter3d plots individual data in three-dimensional space.

```fsharp dotnet_interactive={"language": "fsharp"}
(*
open System

let t = [0. .. 0.5 .. 10.]

let x,y,z =
    t
    |> List.map (fun i ->
        let i' = float i
        let r = 10. * Math.Cos (i' / 10.)
        (r*Math.Cos i',r*Math.Sin i',i')
    )
    |> List.unzip3

let scatter3dLine =
    Chart.Scatter3d(x,y,z,mode = StyleParam.Mode.Markers)
*)
```

```fsharp dotnet_interactive={"language": "fsharp"}
//scatter3dLine
```

# 3D Scatter Plot with Colorscaling and Marker Styling


```fsharp dotnet_interactive={"language": "fsharp"}
(*
open Plotly.NET
open System


let c = [0. .. 0.5 .. 10.]

let x,y,z =
    c
    |> List.map (fun i ->
        let i' = float i
        let r = 10. * Math.Cos (i' / 10.)
        (r*Math.Cos i',r*Math.Sin i',i')
    )
    |> List.unzip3

let marker = Marker.init(Size =12,Opacity=0.8, Colorscale = StyleParam.Colorscale.Viridis)
marker?color <- x

let margin =Margin.init(Left =0., Bottom=0.,Top =0., Right  = 0. )
let layout = Layout.init(  Margin=margin)

let scatter3dLine =
    Chart.Scatter3d(x,y,z,mode = StyleParam.Mode.Markers)
    |> Chart.withMarker marker
    |> Chart.withLayout layout
*)
```

```fsharp dotnet_interactive={"language": "fsharp"}
//scatter3dLine
```
