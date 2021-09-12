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

# Hover Labels

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [for i in 0..10 -> i]
let y = [for i in x -> i*2]
let labels = [for i in x -> "Text "+ string i]

Chart.Point(x,y,Labels=labels)
```

# Customizing Hover Mode

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [for i in 0..10 -> i]
let y1 = [for i in x -> 2.0*Math.Cos(float i)]
let y2 = [for i in x -> 5.0*Math.Sin(float i)]

let labels = [for i in x -> "Text "+ string i]

[
Chart.Line(x,y1,Labels=labels,ShowMarkers=true);
Chart.Line(x,y2,Labels=labels,ShowMarkers=true);
]
|> Chart.combine
|> Chart.withLayout(Layout.init(Hovermode=StyleParam.HoverMode.X))
```
