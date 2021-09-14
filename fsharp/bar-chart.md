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
    description: How to make Bar Charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Bar Charts
    order: 3
    page_type: example_index
    permalink: fsharp/bar-charts/
    thumbnail: thumbnail/bar.jpg
---

<!-- #region dotnet_interactive={"language": "fsharp"} -->
# Bar Charts

## Imports
<!-- #endregion -->

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: newtonsoft.json"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

```

<!-- #region dotnet_interactive={"language": "fsharp"} -->
## Basic Bar Chart with plotly.graph_objects
<!-- #endregion -->

```fsharp dotnet_interactive={"language": "fsharp"}
let animals = ["giraffes"; "orangutans"; "monkeys"];
let sfValues = [20; 14; 23]
Chart.Column (animals, sfValues);

```

<!-- #region dotnet_interactive={"language": "fsharp"} -->
## Grouped Bar Chart
<!-- #endregion -->

```fsharp dotnet_interactive={"language": "fsharp"}
let animals = ["giraffes"; "orangutans"; "monkeys"];
let sfValues = [20; 14; 23]
let laValues = [12; 18; 29]

[
    Chart.Column (animals, sfValues, Name="SF Zoo");
    Chart.Column (animals, laValues, Name="LA Zoo")
]
|> Chart.Combine

```

## Stacked Bar Chart

```fsharp dotnet_interactive={"language": "fsharp"}
let animals = ["giraffes"; "orangutans"; "monkeys"];
let sfValues = [20; 14; 23]
let laValues = [12; 18; 29]

[
    Chart.StackedColumn (animals, sfValues, Name="SF Zoo");
    Chart.StackedColumn (animals, laValues, Name="LA Zoo")
]
|> Chart.Combine

```

## Bar Chart with Hover Text

```fsharp dotnet_interactive={"language": "fsharp"}
let products = ["Product A"; "Product B"; "Product C"];
let labels = ["27% market share"; "24% market share"; "19% market share"]
let sfValues = [20; 14; 23]

Chart.Column (
    products,
    sfValues,
    Labels=labels,
    Opacity=0.6
)
|> Chart.withMarker (
    Marker.init (
        Color="rgb(158,202,225)",
        Line=Line.init (Width=1.5, Color="rgb(8,48,107)")
    )
)
|> Chart.withTitle ("January 2013 Sales Report")

```

## Bar Chart with Direct Labels

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: newtonsoft.json"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"

let products = ["Product A"; "Product B"; "Product C"];
let sfValues = [20; 14; 23]
Chart.Column (
    products,
    sfValues,
    Labels= sfValues,
    TextPosition = StyleParam.TextPosition.TopCenter
)

    |> GenericChart.mapTrace(fun t->
                            t?textposition<- "auto" //workaround
                            t)

```

## Rotated Bar Chart Labels

```fsharp dotnet_interactive={"language": "fsharp"}
let months = ["Jan"; "Feb"; "Mar"; "Apr"; "May"; "Jun";
              "Jul"; "Aug"; "Sep"; "Oct"; "Nov"; "Dec"]
let primaryProduct = [20; 14; 25; 16; 18; 22; 19; 15; 12; 16; 14; 17]
let secondProduct = [19; 14; 22; 14; 16; 19; 15; 14; 10; 12; 12; 16]

[
    Chart.Column (months, primaryProduct, Name="Primary Product")
    |> Chart.withMarker (Marker.init (Color="indianred"));

    Chart.Column (months, secondProduct, Name="Second Product")
    |> Chart.withMarker (Marker.init (Color="lightSalmon"))
]
|> Chart.Combine
|> Chart.withX_Axis (Axis.LinearAxis.init (Tickangle= -45))

```

## Customizing Individual Bar Colors

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"

let featureKeys = ["Feature A"; "Feature B"; "Feature C";
                   "Feature D"; "Feature E"]
let featureValues = [20; 14; 23; 25; 22]

let colors =
    [1..5]
    |> List.mapi (fun i x -> if i = 1 then "crimson" else "lightslategray" )
    |> List.toSeq

let marker = Marker.init(Colors = colors);
marker?color<-colors

Chart.Column (featureKeys, featureValues, Marker=marker)

```

## Customizing Individual Bar Widths

```fsharp dotnet_interactive={"language": "fsharp"}
let featureKeys = [1.; 2.; 3.; 5.5; 10.]
let featureValues = [10; 8; 6; 4; 2]
let width = [0.8; 0.8; 0.8; 3.5; 4.]
Chart.Column (featureKeys,
              featureValues)
|> Chart.withMarker(Marker.init(MultiSizes= width))

//|> Chart.withLineStyle(Width = width) Doesnt accept float list

|> GenericChart.mapTrace(fun t->
                                t?width<-width;
                                t)  // workaround


```

```fsharp dotnet_interactive={"language": "fsharp"}
let labels = ["apples"; "oranges"; "pears"; "bananas"]
let widths = [10.; 20.; 20.; 50.]

let data =
    [
        "South", [50.;80.;60.;70.]
        "North", [50.; 20.;40.;30.]
    ]

let cumSum (xs: float list) =
    xs |> Array.ofList |> Array.scan (+) LanguagePrimitives.GenericOne |> List.ofArray

let findByKey key data =
    (snd (List.find (fun (k,v) -> k = key) data))

let layout =
    let tmp = Layout()
    tmp?barmode <- "stack"
    tmp?uniformtext <- {|mode = "hide"; minsize = 10|}
    tmp?title <- "Marimekko Chart"
    tmp

let transformToColumn (key: string) (values: float list) =
    Chart.Column(values=(findByKey key data), keys=(Seq.map2 (-) (cumSum values) (widths)))
    |> GenericChart.mapTrace(fun t ->
        t.SetValue("customdata", [ for l, v in (Seq.zip labels (Seq.map2 (fun x y -> x*y) widths (findByKey key data) )) do l, v])
        t.SetValue("width", widths)
        t.SetValue("offset", 0.)
        t.SetValue("name", key)
        t.SetValue("textangle", 0)
        t.SetValue("textposition", "inside")
        t)
    |> Chart.withX_Axis(Axis.LinearAxis.init(Tickvals = (Seq.map2 (-) (cumSum widths) (Seq.map (fun x -> x/2.) widths)), Range = StyleParam.Range.Values [|0.; 100.|], Ticktext = [ for l, w in Seq.zip labels widths do $"{l}<br>{w}"]))
    |> Chart.withY_Axis(Axis.LinearAxis.init(Range = StyleParam.Range.Values [|0.; 100.|]))

[
    for key, values in data do
        (transformToColumn key values)
]
|> Chart.Combine
|> Chart.withLayout(layout)

```

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let years = [ "2016"; "2017"; "2018" ]

[
    Chart.Column(years, [500; 600; 700], Name="expenses", Marker=Marker.init(Color="crimson"))
        |> GenericChart.mapTrace(fun t->
                        t.SetValue("base",[-500;-600;-700])// workaround
                        t)

    ;Chart.Column(years, [300; 400; 700], Name="revenue", Marker=Marker.init(Color="lightslategrey"))
         |> GenericChart.mapTrace(fun t->
                            t.SetValue("base",0)
                            t)  // workaround
]
|> Chart.Combine
```

## Colored and Styled Bar Chart

```fsharp dotnet_interactive={"language": "fsharp"}

```

## Bar Chart with Relative Barmode

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [1; 2; 3; 4]

let layout =
    let obj = Layout()
    obj?barmode <- "relative"// wordaround
    obj?title_text <- "Relative Barmode"// wordaround
    obj

[
    Chart.Column(keys=x, values= [1.; 4.; 9.; 16.])
    Chart.Column(keys=x, values= [6.; -8.; -4.5; 8.])
    Chart.Column(keys=x, values= [-15.; -3.; 4.5; -8.])
    Chart.Column(keys=x, values= [-1.; 3.; -3.; -4.])
]
|> Chart.Combine
|> Chart.withLayout(layout)
```

## Bar Chart with Sorted or Ordered Categories

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

let layout =
    let obj = Layout()
    obj?barmode <- "stack"// wordaround
    obj?xaxis <- {|categoryorder = "category ascending"|} // wordaround
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
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

let layout =
    let obj = Layout()
    obj?barmode <- "stack"// wordaround
    obj?xaxis <- {|categoryorder = "array"; categoryarray = ['d';'a';'c';'b']|}// wordaround
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
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

let layout =
    let obj = Layout()
    obj?barmode <- "stack" // wordaround
    obj?xaxis <- {|categoryorder = "total descending"|} // wordaround
    obj

[
    Chart.Column(x, [2.;5.;1.;9.], Name = "Montreal")
    Chart.Column(x, [1.;4.;9.;16.], Name = "Ottawa")
    Chart.Column(x, [6.;8.;4.5;8.], Name = "Toronto")
]
|> Chart.Combine
|> Chart.withLayout(layout)
```

# Horizontal Bar Charts

## Bar Charts With Multicategory Axis Type

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"

open Plotly.NET

let x :Object list = [["BB+"; "BB+"; "BB+"; "BB"; "BB"; "BB"];[16; 17; 18; 16; 17; 18;]]

[
    Chart.Column(keys=[], values = [1;2;3;4;5;6])
    Chart.Column(keys=[], values = [6;5;4;3;2;1])
]
|> Chart.Combine
// |> Chart.withX_Axis(Axis.LinearAxis.init(Tickvals = ["BB+"; "BB+"; "BB+"; "BB"; "BB"; "BB"]))
|> GenericChart.mapTrace(fun t->
                                t?x<-x // workaround
                                t)
|> Chart.withLayout( Layout.init(Barmode = StyleParam.Barmode.Stack))
```
