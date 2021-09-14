---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.4.2
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
    description: How to make categorical charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Categorical Charts
    order: 5
    page_type: u-guide
    permalink: fsharp/categorical-charts/
    thumbnail: thumbnail/categorical.jpg
---

## Automatically Sorting Categories by Name or Total Value

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

let layout =
    let obj = Layout()
    obj?barmode <- "stack"
    obj?xaxis <- {|categoryorder = "category ascending"|}
    obj?width <- 1000.
    obj

[
    Chart.Column(x, [2.;5.;1.;9.], Name = "Montreal")
    Chart.Column(x, [1.;4.;9.;16.], Name = "Ottawa")
    Chart.Column(x, [6.;8.;4.5;8.], Name = "Toronto")
]
|> Chart.Combine
|> Chart.withLayout(layout)
```

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

let layout =
    let obj = Layout()
    obj?barmode <- "stack"
    obj?xaxis <- {|categoryorder = "total ascending"|}
    obj?width <- 1000.
    obj

[
    Chart.Column(x, [2.;5.;1.;9.], Name = "Montreal")
    Chart.Column(x, [1.;4.;9.;16.], Name = "Ottawa")
    Chart.Column(x, [6.;8.;4.5;8.], Name = "Toronto")
]
|> Chart.Combine
|> Chart.withLayout(layout)
```

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

let layout =
    let obj = Layout()
    obj?barmode <- "stack"
    obj?xaxis <- {|categoryorder = "array"; categoryarray = ['d';'a';'c';'b']|}
    obj?width <- 1000.
    obj

[
    Chart.Column(x, [2.;5.;1.;9.], Name = "Montreal")
    Chart.Column(x, [1.;4.;9.;16.], Name = "Ottawa")
    Chart.Column(x, [6.;8.;4.5;8.], Name = "Toronto")
]
|> Chart.Combine
|> Chart.withLayout(layout)
```

## Gridlines, Ticks and Tick Labels

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

Chart.Column(["A";"B";"C"], [1;3;2])
|> Chart.withX_Axis(Axis.LinearAxis.init(Showgrid = true, Ticks = StyleParam.TickOptions.Outside))
```

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let trace x y name =
    let tmp = Trace("bar")
    tmp?x <- x
    tmp?y <- y
    tmp?name <- name
    tmp
[
    GenericChart.ofTraceObject(trace [["First"; "First";"Second";"Second"];["A"; "B"; "A"; "B"]] [2;3;1;5] "Adults")
    GenericChart.ofTraceObject(trace [["First"; "First";"Second";"Second"];["A"; "B"; "A"; "B"]] [8;3;6;5] "Children")
]
|> Chart.Combine
|> Chart.withLayout(Layout.init(Title = "Multi-category axis", Width = 700.))
```
