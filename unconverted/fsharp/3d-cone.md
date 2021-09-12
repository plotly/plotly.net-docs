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
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data, 4.2.2"
```

# Basic 3D Cone


```csharp dotnet_interactive={"language": "fsharp"}
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

```csharp dotnet_interactive={"language": "fsharp"}
cone3d

```

# Multiple 3D Cones


```csharp dotnet_interactive={"language": "fsharp"}
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

```csharp dotnet_interactive={"language": "fsharp"}
cone3d
```
