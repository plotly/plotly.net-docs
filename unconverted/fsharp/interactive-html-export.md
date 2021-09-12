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

# Interactive vs Static Export


Plotly figures are interactive when viewed in a web browser: you can hover over data points, pan and zoom axes, and show and hide traces by clicking or double-clicking on the legend. You can export figures either to static image file formats like PNG, JPEG, SVG or PDF or you can export them to HTML files which can be opened in a browser.


# Saving to an HTML file

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [for i in 0..10 -> i]
let y = [for i in x -> i*2]

Chart.Point(x,y)
|> Chart.saveHtmlAs "test"

```
