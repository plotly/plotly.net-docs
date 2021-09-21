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
    description: The structure of a figure - data, traces and layout explained.
    display_as: file_settings
    language: fsharp
    layout: base
    name: The Figure Data Structure
    order: 29
    page_type: example_index
    permalink: fsharp/figure-structure/
    thumbnail: thumbnail/violin.jpg
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
```

# Figure Data Structure

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x  = [for i in 0..20 -> i]
let y = [for i in 0..20 -> 2*i*2+3*i+10]

let figure = Chart.Line(x,y)
            |> Chart.withLayout(Layout.init(Width=500,Height=500))
            |> GenericChart.toFigure

figure.Layout.GetProperties(true)

```
