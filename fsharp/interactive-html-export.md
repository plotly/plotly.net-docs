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
    description: Plotly allows you to save interactive HTML versions of your figures
      to your local disk.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Interactive HTML Export
    order: 31
    page_type: u-guide
    permalink: fsharp/interactive-html-export/
    thumbnail: thumbnail/static-image-export.png
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
```

# Interactive vs Static Export


Plotly figures are interactive when viewed in a web browser: you can hover over data points, pan and zoom axes, and show and hide traces by clicking or double-clicking on the legend. You can export figures either to static image file formats like PNG, JPEG, SVG or PDF or you can export them to HTML files which can be opened in a browser.


# Saving to an HTML file

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [for i in 0..10 -> i]
let y = [for i in x -> i*2]

Chart.Point(x,y)
|> Chart.saveHtmlAs "test"

```
