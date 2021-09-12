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
```

# Figure Data Structure

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x  = [for i in 0..20 -> i]
let y = [for i in 0..20 -> 2*i*2+3*i+10]

let figure = Chart.Line(x,y)
            |> Chart.withLayout(Layout.init(Width=500.0,Height=500.0))
            |> GenericChart.toFigure

figure.Layout.GetProperties(true)

```
