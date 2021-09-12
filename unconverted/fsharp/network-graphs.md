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

# Create Nodes

```csharp dotnet_interactive={"language": "fsharp"}
//open QuickGraph
open Plotly.NET
open Plotly.NET.Axis


let x = [2;3;5;1;10;3]
let y = [12;14;7;2;15;4]

Chart.Point(x,y)
|> Chart.withMarkerStyle(Size=10)
|> Chart.withXAxis(LinearAxis.init(ShowTickLabels=false,ShowGrid=false,ShowLine=false))
|> Chart.withYAxis(LinearAxis.init(ShowTickLabels=false,ShowGrid=false,ShowLine=false))

```

# Create Edges

```csharp dotnet_interactive={"language": "fsharp"}

open System

let rand = new Random()

let x = [for i in 0..100 -> rand.Next(0,100) ]
let y = [for i in x -> rand.Next(0,100) ]

let edges = [for i in x ->  let i = rand.Next(0,100)
                            let j = rand.Next(0,100)                            
                            Shape.init(StyleParam.ShapeType.Line,X0=x.[i],X1=x.[j],Y0=y.[i],Y1=y.[j],Line=Line.init(Color="#888",Width=0.5))]


Chart.Point(x,y)
|> Chart.withMarkerStyle(Size=10)
|> Chart.withXAxis(LinearAxis.init(ShowTickLabels=false,ShowGrid=false,ShowLine=false,ZeroLine=false))
|> Chart.withYAxis(LinearAxis.init(ShowTickLabels=false,ShowGrid=false,ShowLine=false,ZeroLine=false))
|> Chart.withShapes edges
```
