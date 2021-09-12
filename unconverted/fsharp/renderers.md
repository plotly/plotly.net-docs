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
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
open Plotly.NET

```

# Displaying Figures


```fsharp dotnet_interactive={"language": "fsharp"}
let x = [for i in 1..3 -> i] 
let y=[for i in 1..3 -> i]
Chart.Column(x,y)    
        |>Chart.withTitle("A Figure Displaying Itself")

```

# Overriding The Default Renderer


```fsharp dotnet_interactive={"language": "fsharp"}
let x = [for i in 1..3 -> i] 
let y=[for i in 1..3 -> i]
Chart.Column(x,y,Name="SVG")    
        |>Chart.withTitle("A Figure Displayed with the 'svg' Renderer")
        //|> Chart.withMarker (Marker.init (Color="Blues"))
        |>Chart.showAsImage(StyleParam.ImageFormat.SVG)

```

# Static Image Renderers


```fsharp dotnet_interactive={"language": "fsharp"}
let x = [for i in 1..3 -> i] 
let y=[for i in 1..3 -> i]
Chart.Column(x,y,Name="SVG")    
        |>Chart.withTitle("A Figure Displayed with the 'png' Renderer")
        |> Chart.withSize(800.,300.)
        |>Chart.showAsImage(StyleParam.ImageFormat.PNG)
```

```fsharp dotnet_interactive={"language": "fsharp"}
let x = [for i in 1..3 -> i] 
let y=[for i in 1..3 -> i]
Chart.Column(x,y,Name="SVG")    
        |>Chart.withTitle("A Figure Displayed with the 'jpeg' Renderer")
        |> Chart.withSize(800.,300.)
        |>Chart.showAsImage(StyleParam.ImageFormat.JPEG)
```
