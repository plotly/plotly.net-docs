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
    description: A reference for the built-in named continuous (sequential, diverging
      and cyclical) color scales in Plotly.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Built-in Continuous Color Scales
    order: 27
    page_type: example_index
    permalink: fsharp/builtin-colorscales/
    thumbnail: thumbnail/heatmap_colorscale.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
    
```

# Built-in and Custom color scales

The following built-in continuous color scales are available. Through Custom Colorscale, you can define custom colors

```fsharp dotnet_interactive={"language": "fsharp"}
open Microsoft.FSharp.Reflection
open Plotly.NET

let builtinColorScales = FSharpType.GetUnionCases typeof<StyleParam.Colorscale>

for case in builtinColorScales do printfn "%s" case.Name

```

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET 

let matrix =
    [[1.;1.5;0.7;2.7];
    [2.;0.5;1.2;1.4];
    [0.1;2.6;2.4;3.0];]

let rownames = ["p3";"p2";"p1"]
let colnames = ["Tp0";"Tp30";"Tp60";"Tp160"]

let colorscaleValue = 
    StyleParam.Colorscale.Custom [(0.0,"#3D9970");(1.0,"#001f3f")] //StyleParam.Colorscale.Blackbody or StyleParam.Colorscale.Bluered etc

Chart.Heatmap(
    data=matrix,ColNames=colnames,RowNames=rownames,
    Colorscale=colorscaleValue,
    Showscale=true
)
|> Chart.withSize(700.,500.)
|> Chart.withMarginSize(Left=200.)

```
