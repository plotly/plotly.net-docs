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
    description: How to use hover text and formatting in F# with Plotly.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Hover Text and Formatting
    order: 23
    page_type: example_index
    permalink: fsharp/hover-text-and-formatting/
    thumbnail: thumbnail/hover-text.png
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
```

# Hover Labels

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [for i in 0..10 -> i]
let y = [for i in x -> i*2]
let labels = [for i in x -> "Text "+ string i]

Chart.Point(x,y,Labels=labels)
```

# Customizing Hover Mode

```fsharp  dotnet_interactive={"language": "fsharp"}
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
|> Chart.withLayout(Layout.init(HoverMode=StyleParam.HoverMode.X))
```
