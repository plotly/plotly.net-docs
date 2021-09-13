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
    description: How to make Treemap Charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Treemap Charts
    order: 5
    page_type: u-guide
    permalink: fsharp/treemaps/
    thumbnail: thumbnail/treemap.png
---

# Treemap Charts


## Imports

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET
```

## Basic Treemap with go.Treemap

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let values = [0.0; 11.0; 12.0; 13.0; 14.0; 15.0; 20.0; 30.0]
let labels = ["container"; "A1"; "A2"; "A3"; "A4"; "A5"; "B1"; "B2"]
let parents = [""; "container"; "A1"; "A2"; "A3"; "A4"; "container"; "B1"]

Chart.Treemap(labels,
              parents,
              Values = values,
              Colors = ["lightgray"])
```

## Set Different Attributes in Treemap

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let labels = ["Eve"; "Cain"; "Seth"; "Enos"; "Noam"; "Abel"; "Awan"; "Enoch"; "Azura"]
let parents = [""; "Eve"; "Eve"; "Seth"; "Seth"; "Eve"; "Eve"; "Awan"; "Eve"]

let values1 = [10.0; 14.0; 12.0; 10.0; 2.0; 6.0; 6.0; 1.0; 4.0]
let values2 = [65.0; 14.0; 12.0; 10.0; 2.0; 6.0; 6.0; 1.0; 4.0]

[
    Chart.Treemap(labels,
            parents,
            Values = values1,
            Text = ["label+value+percent parent+percent entry+percent root"],
            Colors = ["lightgray"] )

    Chart.Treemap(labels,
            parents,
            Branchvalues = StyleParam.BranchValues.Total,
            Values = values2,
            Text = ["label+value+percent parent+percent entry"],
            Colors = ["lightgray"])
]
```

## Set Color of Treemap Sectors


### marker.colors

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let values = [0.0; 11.0; 12.0; 13.0; 14.0; 15.0; 20.0; 30.0]
let labels = ["container"; "A1"; "A2"; "A3"; "A4"; "A5"; "B1"; "B2"]
let parents = [""; "container"; "A1"; "A2"; "A3"; "A4"; "container"; "B1"]

Chart.Treemap(labels,
              parents,
              Values = values,
              Colors = ["pink"; "royalblue"; "lightgray"; "purple";
                        "cyan"; "lightgray"; "lightblue"; "lightgreen"])
```

### colorway

```fsharp dotnet_interactive={"language": "fsharp"}
let labels = ["container"; "A1"; "A2"; "A3"; "A4"; "A5"; "B1"; "B2"]
let parents = [""; "container"; "A1"; "A2"; "A3"; "A4"; "container"; "B1"]
let values = [0.0; 11.0; 12.0; 13.0; 14.0; 15.0; 20.0; 30.0]

let layout = Layout.init ()
let template = Template.init(layout) |>
               Template.withColorWay [|"pink"; "lightgray"|]

Chart.Treemap(labels,
              parents,
              Values = values,
              Colors = ["lightblue"] )
|> Chart.withTemplate template

```

### colorscale

```fsharp dotnet_interactive={"language": "fsharp"}
let values = [0.0; 11.0; 12.0; 13.0; 14.0; 15.0; 20.0; 30.0]
let labels = ["container"; "A1"; "A2"; "A3"; "A4"; "A5"; "B1"; "B2"]
let parents = [""; "container"; "A1"; "A2"; "A3"; "A4"; "container"; "B1"]

Chart.Treemap(labels,
              parents,
              Values = values//,
              (*Colorscale = StyleParam.Colorscale.Bluered*) )
```
