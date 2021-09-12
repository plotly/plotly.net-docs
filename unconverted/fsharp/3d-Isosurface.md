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
```

# Basic Isosurface



```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET 
 
let isosurface3d =
        Trace3d.initIsoSurface (fun isosurface3d ->
            isosurface3d?x <- [0.;0.;0.;0.;1.;1.;1.;1.]
            isosurface3d?y <-[1.;0.;1.;0.;1.;0.;1.;0.]
            isosurface3d?z <-[1.;1.;0.;0.;1.;1.;0.;0.]
            isosurface3d?value<-[1.;2.;3.;4.;5.;6.;7.;8.]
            isosurface3d?opacity<-0.5
            isosurface3d?isomin<-2
            isosurface3d?isomax<-6
            isosurface3d?color <- "lightpink"
            isosurface3d
            )         
        |> GenericChart.ofTraceObject
```

```fsharp dotnet_interactive={"language": "fsharp"}
isosurface3d

```
