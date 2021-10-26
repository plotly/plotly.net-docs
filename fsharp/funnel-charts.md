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
    description: How to make funnel-chart plots in F# with Plotly.      
    display_as: financial
    language: fsharp
    layout: base
    name: Funnel Chart
    order: 4
    page_type: example_index
    permalink: fsharp/funnel-charts/
    thumbnail: thumbnail/funnel.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Newtonsoft.Json, 12.0.3"
#r "nuget: Plotly.NET,  2.0.0-preview.10"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.10"
```

# Introduction

Funnel charts are often used to represent data in different stages of a business process. It’s an important mechanism in Business Intelligence to identify potential problem areas of a process. For example, it’s used to observe the revenue or loss in a sales process for each stage, and displays values that are decreasing progressively. Each stage is illustrated as a percentage of the total of all values.


# Basic Funnel Chart

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let y = ["Website visit"; "Downloads"; "Potential customers"; "Requested price"; "invoice sent"]
let x = [39.; 27.4; 20.6; 11.; 2.]

Chart.Funnel(x,y)
|> Chart.withMarginSize(Left=150.)
```

# Setting Marker Size and Color

This example uses TextPosition and TextInfo to determine information appears on the graph, and shows how to customize the bars.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects

let y = ["Website visit"; "Downloads"; "Potential customers"; "Requested price"; "invoice sent"]
let x = [39.; 27.4; 20.6; 11.; 2.]

let colors = ["deepskyblue";"lightsalmon"; "tan"; "teal"; "silver"]
                |> Seq.map (fun c -> Color.fromString c)
                |> Color.fromColors

let lineColors = ["wheat";"wheat"; "blue"; "wheat"; "wheat"]
                    |> Seq.map (fun c -> Color.fromString c)
                    |> Color.fromColors

let connector =
    FunnelConnector.init (
        Line = Line.init (Color = Color.fromString "royalblue", Dash = StyleParam.DrawingStyle.Dash, Width = 3.)
    )

Chart.Funnel(x, y, TextPosition = StyleParam.TextPosition.Inside, Opacity = 0.65, Connector = connector)
|> GenericChart.mapTrace
    (fun t ->
        t?textinfo <- "value+percent initial"
        t)
|> Chart.withMarkerStyle (Color = colors, Outline = Line.init (Color = lineColors, Width = 3.))

```

# Stacked Funnel Plot

```fsharp dotnet_interactive={"language": "fsharp"}
let y = ["Website visit"; "Downloads"; "Potential customers"; "Requested price"]

let chart1 = Chart.Funnel([120; 60; 30; 20],y,Name="Montreal")
                |> GenericChart.mapTrace(fun t -> t?textinfo <- "value+percent initial";t)

let chart2 = Chart.Funnel(
                    [ 100; 60; 40; 30; 20 ],
                    y,
                    TextPosition = StyleParam.TextPosition.Inside,
                    Orientation = StyleParam.Orientation.Horizontal,
                    Name = "Toronto"
                )|> GenericChart.mapTrace(fun t -> t?textinfo <- "value+percent previous";t)

let final = y@ ["Finalized"]
let chart3 = Chart.Funnel(
                    [ 90; 70; 50; 30; 10; 5],
                    final,
                    TextPosition = StyleParam.TextPosition.Outside,
                    Orientation = StyleParam.Orientation.Horizontal,
                    Name = "Vancouver"
                ) |> GenericChart.mapTrace(fun t -> t?textinfo <- "value+percent total";t)

[chart1;chart2;chart3]
|> Chart.combine
|> Chart.withMarginSize(Left=150.)
|> Chart.withSize(Width=800)
|> Chart.withLayout(Layout.init(PlotBGColor=Color.fromString "#e5ecf6"))
    
```

# Basic Area Funnel Plot

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

Chart.FunnelArea(Text=["The 1st";"The 2nd"; "The 3rd"; "The 4th"; "The 5th"],Values=[5; 4; 3; 2; 1])
```

# Set Marker Size and Color in Area Funnel Plots

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let colors = ["deepskyblue";"lightsalmon"; "tan"; "teal"; "silver"]
                |> Seq.map (fun c -> Color.fromString c)
                
let lineColors = ["wheat";"wheat"; "blue"; "wheat"; "wheat"]
                    |> Seq.map (fun c -> Color.fromString c)
                    |> Color.fromColors

Chart.FunnelArea(
    Text =
        [ "The 1st"
          "The 2nd"
          "The 3rd"
          "The 4th"
          "The 5th" ],
    Values = [ 5; 4; 3; 2; 1 ],
    Insidetextfont =
        Font.init (Family = StyleParam.FontFamily.Old_Standard_TT, Size = 13., Color = Color.fromString "black"),
    Opacity = 0.65
)
|> Chart.withMarkerStyle (Colors = colors, Outline = Line.init (Color = lineColors, Width = 4.))

```
