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
    description: Displaying Figures using Plotly's F# graphing library
    display_as: file_settings
    language: fsharp
    layout: base
    name: Displaying Figures
    order: 3
    page_type: example_index
    permalink: fsharp/renderers/
    thumbnail: thumbnail/displaying-figures.png
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
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
