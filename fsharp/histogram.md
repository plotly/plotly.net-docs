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
    description: How to make Histograms in F# with Plotly.
    display_as: statistical
    language: fsharp
    layout: base
    name: Histograms
    order: 3
    page_type: example_index
    permalink: fsharp/histograms/
    thumbnail: thumbnail/histogram.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.7"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.7"
#r "nuget: newtonsoft.json"
open Plotly.NET
```

# Basic Histogram

```fsharp dotnet_interactive={"language": "fsharp"}
let N = 500
let rnd = System.Random()
let x = Array.init N (fun _ -> rnd.NextDouble())
Chart.Histogram(x)
```

# Normalized Histogram


```fsharp dotnet_interactive={"language": "fsharp"}
let N = 500
let rnd = System.Random()
let x = Array.init N (fun _ -> rnd.NextDouble())
Chart.Histogram(
               x,
               HistNorm=StyleParam.HistNorm.Probability
               )
```

# Horizontal Histogram


```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
let N = 500
let rnd = System.Random()
let x = Array.init N (fun _ -> rnd.NextDouble())
```

```fsharp dotnet_interactive={"language": "fsharp"}
Chart.Histogram(
               x,
               Orientation=StyleParam.Orientation.Horizontal
               )  // issue with horizental allign
```

# Overlaid Histogram


```fsharp dotnet_interactive={"language": "fsharp"}
let N = 500
let rnd = System.Random()
let x0 = Array.init N (fun _ -> rnd.NextDouble())
let x1= Array.init N (fun _ -> rnd.NextDouble())
[
    Chart.Histogram(x0)
    |> GenericChart.mapTrace(fun x ->
        x.SetValue("name", "trace 0")
        x.SetValue("marker", {| color = "rgba(103, 102, 255,1)"; line = {| color = "rgba(103, 102, 255, 1)"; width = 3 |} |})
        x)
    Chart.Histogram(x1)
    |> GenericChart.mapTrace(fun x ->
        x.SetValue("name", "trace 1")
        x.SetValue("marker", {| color = "rgba(255, 70, 51, 1)"; line = {| color = "rgba(255, 70, 51, 1)"; width = 3 |} |})
        x)
]
|> Chart.combine
|> Chart.withLayout(Layout.init(Barmode = StyleParam.Barmode.Overlay))
```

# Stacked Histograms


```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let N = 500
let rnd = System.Random()
let x0 = Array.init N (fun _ -> rnd.NextDouble())
let x1= Array.init N (fun _ -> rnd.NextDouble())
[
    Chart.Histogram(x0)
    |> GenericChart.mapTrace(fun x ->
        x.SetValue("name", "trace 0")
        x.SetValue("marker", {| color = "rgba(103, 102, 255,1)"; line = {| color = "rgba(103, 102, 255, 1)"; width = 3 |} |})
        x)
    Chart.Histogram(x1)
    |> GenericChart.mapTrace(fun x ->
        x.SetValue("name", "trace 1")
        x.SetValue("marker", {| color = "rgba(255, 70, 51, 1)"; line = {| color = "rgba(255, 70, 51, 1)"; width = 3 |} |})
        x)
]
|> Chart.combine
|> Chart.withLayout(Layout.init(Barmode = StyleParam.Barmode.Stack))
```

# Styled Histogram


```fsharp dotnet_interactive={"language": "fsharp"}
let N = 500
let rnd = System.Random()
let x0 = Array.init N (fun _ -> rnd.NextDouble())
let x1= Array.init N (fun _ -> rnd.NextDouble())

let layout =
    let temp = Layout()
    temp?barmode <- "Overlay"
    temp?bargap <- 0.5
    temp?bargroupgap <- 0.1
    temp
[
    Chart.Histogram(x0)                  // Issues setting the xbins start,end and size=0.5
    |> GenericChart.mapTrace(fun x ->
        x.SetValue("name", "control")
        x.SetValue("HistNorm","percent")
        x.SetValue("Opacity","0.75")
        x.SetValue("marker", {| color = "rgba(255, 69, 246, 0.35)"; line = {| color = "rgba(255, 69, 246, 0.35)"; width = 5 |} |})
        x)
    Chart.Histogram(x1)
    |> GenericChart.mapTrace(fun x ->
        x.SetValue("name", "experimental")
        x.SetValue("HistNorm","percent")
        x.SetValue("Opacity","0.75")
        x.SetValue("marker", {| color = "rgba(103, 102, 255,1)"; line = {| color = "rgba(103, 102, 255,1)"; width = 5 |} |})
        x)
]


|> Chart.combine
|> Chart.withTitle("Sample Result")
|> Chart.withXAxisStyle("Value")
|> Chart.withYAxisStyle("Count")
//|> Chart.withLayout(Layout.init(Barmode = StyleParam.Barmode.Overlay))
|> Chart.withLayout(layout)   // Issues setting the xbins start,end and size=0.5

```

# Cumulative Histogram


```fsharp dotnet_interactive={"language": "fsharp"}
let N = 500
let rnd = System.Random()
let x = Array.init N (fun _ -> rnd.NextDouble())
```

```fsharp dotnet_interactive={"language": "fsharp"}
Chart.Histogram(x)     // issue with not find cumulative in histogram
```

# Specify Aggregation Function


```fsharp dotnet_interactive={"language": "fsharp"}
let fruits =  ["Apples";"Apples";"Apples";"Oranges"; "Bananas"];
let counts = ["5";"10";"3";"10";"5"]
[
Chart.Histogram(
              fruits,
               Name = "Sum"
               );
Chart.Histogram(
              counts ,
               Name = "Count"
               );
]
|> Chart.combine
```

# Share bins between histograms



```fsharp dotnet_interactive={"language": "fsharp"}
let N = 500
let rnd = System.Random()
let x0 = Array.init N (fun _ -> rnd.Next(7, 20))
let x1 = Array.init N (fun _ -> rnd.Next(7, 20))
let layout =
    let obj = Layout()
    obj?bargap <- 0.5
    obj?bargroupgap <- 0.1
    obj
[
    Chart.Histogram(x0)
    |> GenericChart.mapTrace(fun x ->
        x.SetValue("name", "trace 0")
        x.SetValue("marker", {| color = "rgba(103, 102, 255, 1)"; line = {| color = "rgba(103, 102, 255, 1)"; width = 5 |} |})
        x)
    Chart.Histogram(x1)
    |> GenericChart.mapTrace(fun x ->
        x.SetValue("name", "trace 1")
        x.SetValue("marker", {| color = "rgba(255, 70, 51, 1)"; line = {| color = "rgba(255, 70, 51, 1)"; width = 5 |} |})
        x)
]

|> Chart.combine
|> Chart.withLayout(Layout.init(Barmode = StyleParam.Barmode.Stack))
```
