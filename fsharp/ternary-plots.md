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
    description: How to make Ternary plots in F# with Plotly.
    display_as: scientific
    language: fsharp
    layout: base
    name: Ternary Plots
    order: 1
    page_type: example_index
    permalink: fsharp/ternary-plots/
    thumbnail: thumbnail/v4-migration.png
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Newtonsoft.Json, 12.0.3"
#r "nuget: Plotly.NET, 2.0.0-preview.10"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.10"
```

# Ternary Plots

A ternary plot depicts the ratios of three variables as positions in an equilateral triangle.

It graphically depicts the ratios of the three variables as positions in an equilateral triangle. 
It is used in physical chemistry, petrology, mineralogy, metallurgy, and other physical sciences to show the compositions of systems composed of three species. 
In population genetics, a triangle plot of genotype frequencies is called a de Finetti diagram. In game theory, it is often called a simplex plot.
Ternary plots are tools for analyzing compositional data in the three-dimensional case.


# Basic Ternary point charts

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

// a coordinates
let a  = [ 1; 2; 3; 4; 5; 6; 7;]
// b coordinates
let b  = a |> List.rev
//c
let c  = [ 2; 2; 2; 2; 2; 2; 2;]

Chart.PointTernary(a,b,c)
```

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let rawData = [
    {|journalist=75;developer=25;designer=0;label="point 1" |}
    {|journalist=70;developer=10;designer=20;label="point 2" |}
    {|journalist=75;developer=20;designer=5;label="point 3" |}
    {|journalist=5;developer=60;designer=35;label="point 4" |}
    {|journalist=10;developer=80;designer=10;label="point 5" |}
    {|journalist=10;developer=90;designer=0;label="point 6" |}
    {|journalist=10;developer=70;designer=10;label="point 7" |}
    {|journalist=10;developer=20;designer=70;label="point 8" |}
    {|journalist=15;developer=5;designer=80;label="point 9" |}
    {|journalist=10;developer=10;designer=80;label="point 10" |}
    {|journalist=20;developer=10;designer=70;label="point 11" |}
    ]

let A= [for item in rawData -> item.journalist]
let B = [for item in rawData -> item.developer]
let C = [for item in rawData -> item.designer]

let makeAxis title tickAngle=
    LinearAxis.init(Title=Title.init(title,Font = Font.init(Size=20.)),TickAngle=tickAngle,TickFont=Font.init(Size=15.),TickColor=Color.fromString "rgba(0,0,0,0)",TickLen=5,ShowLine=true,ShowGrid=true)

let markerSymbol =  StyleParam.MarkerSymbol.Modified(StyleParam.MarkerSymbol.Circle, StyleParam.SymbolStyle.Open)

Chart.ScatterTernary(A=A,B=B,C=C,Mode=StyleParam.Mode.Markers,Sum=100.)
|> Chart.withMarkerStyle(Size=14,Color=Color.fromString "#DB7365",Outline=Line.init(Width=2.),Symbol=markerSymbol)
|> Chart.withAAxis(makeAxis "Journalist" 0)
|> Chart.withBAxis(makeAxis "<br>Developer" 45)
|> Chart.withCAxis(makeAxis "<br>Designer" -45)
```
