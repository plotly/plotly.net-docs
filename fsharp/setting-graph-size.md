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
    description: How to manipulate the graph size, margins and background color.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Setting Graph Size
    order: 11
    page_type: example_index
    permalink: fsharp/setting-graph-size/
    thumbnail: thumbnail/sizing.png
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
```

# Adjusting Height, Width, & Margins



```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET 
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let x = [1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.; ]
let y = [2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]

Chart.Point(x,y)            
            |> Chart.withSize(700.0,500.0)
            |> Chart.withMargin(Margin.init(?Left= Some(10.0) ))




```
