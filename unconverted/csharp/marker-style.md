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
    description: How to style markers in F# with Plotly.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Styling Markers
    order: 20
    page_type: u-guide
    permalink: fsharp/marker-style/
    thumbnail: thumbnail/marker-style.gif
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.9"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.9"

```

# Styling Marker

Point Markers can be styled either using Chart.withMarkerStyle() or Chart.withMarker()

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x  = [1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.; ]
let y1 = [2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]
let y2 = [1.; 2.5; 4.; 2.5; 4.; 6.5; 3.5; 5.5; 4.5; 6.]

[
    Chart.Point(x,y1,Name="plot-1") |> Chart.withMarkerStyle(Size=10,
                                                                Color=Color.fromString "deeppink",
                                                                Symbol=StyleParam.MarkerSymbol.Cross);
    Chart.Point(x,y2,Name="plot-2") |> Chart.withMarkerStyle(Size=20,
                                                                Color=Color.fromString "blue",
                                                                Symbol=StyleParam.MarkerSymbol.Diamond)
]
|> Chart.combine
```

# Add Marker Border


In order to make markers look more distinct, you can add a border to the markers. This can be achieved by adding the Line property to the Marker object.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x  = [1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.; ]
let y1 = [2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]
let y2 = [1.; 2.5; 4.; 2.5; 4.; 6.5; 3.5; 5.5; 4.5; 6.]

[
    Chart.Point(x,y1,Name="plot-1") |> Chart.withMarkerStyle(Size=20,
                                                                Color=Color.fromString "deeppink",
                                                                Symbol=StyleParam.MarkerSymbol.StarSquare,
                                                                Outline=Line.init(Width=2., Color=Color.fromString "black"));
    Chart.Point(x,y2,Name="plot-2") |> Chart.withMarkerStyle(Size=20,
                                                                Color=Color.fromString "blue",
                                                                Symbol=StyleParam.MarkerSymbol.Diamond,
                                                                Outline=Line.init(Width=2.,Color=Color.fromString "black"))
]
|> Chart.combine
```

# Marker Opacity


To maximise visibility of density, it is recommended to set the opacity inside the marker marker:{Opacity=0.5}. If mulitple traces exist with high density, consider using marker opacity in conjunction with trace opacity.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open System
open Plotly.NET.TraceObjects

let rand = new Random()

let x  = [for i in 0..100 -> 100+i]
let y1 = [for i in 0..100 -> rand.NextDouble()]
let y2 = [for i in 0..100 -> rand.NextDouble()]

[
    Chart.Point([for i in 0..2 -> 50+i],[0.5;0.8],Name="plot-1",ShowLegend=false) 
        |> Chart.withMarker(Marker.init(Size=150,
                                            Color=Color.fromString "green",
                                            Opacity=0.5, 
                                            Symbol=StyleParam.MarkerSymbol.Circle,
                                            Outline=Line.init(Width=10.,Color=Color.fromString "red")));
    
    Chart.Point(x,y1,Name="plot-2",ShowLegend=false) 
        |> Chart.withMarkerStyle(Size=25,
                                    Color=Color.fromString "deeppink",
                                    Opacity=0.5, 
                                    Symbol=StyleParam.MarkerSymbol.Circle);
    
    Chart.Point(x,y2,Name="plot-3",ShowLegend=false) 
        |> Chart.withMarkerStyle(Size=25,
                                    Color=Color.fromString "blue",
                                    Opacity=0.5,                                     
                                    Symbol=StyleParam.MarkerSymbol.Circle)
]
|> Chart.combine
```

# Color Opacity


To maximise visibility of each point, set the color opacity by using alpha: Marker:{Color=Color.fromString "rgba(0,0,0,0.5)"}. Here, the marker line will remain opaque.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open System

let rand = new Random()

let x  = [for i in 0..100 -> 100+i]
let y1 = [for i in 0..100 -> rand.NextDouble()]
let y2 = [for i in 0..100 -> rand.NextDouble()]


[ Chart.Point([ for i in 0 .. 2 -> 50 + i ], [ 0.5; 0.8 ], Name = "plot-1", ShowLegend = false)
  |> Chart.withMarker (
      Marker.init (
          Size = 150,
          Color = Color.fromString "rgba(17, 157, 255,0.5)",
          Opacity = 0.5,
          Symbol = StyleParam.MarkerSymbol.Circle,
          Outline = Line.init (Width = 10., Color = Color.fromString "red")
      )
  )
  Chart.Point(x, y1, Name = "plot-2", ShowLegend = false)
  |> Chart.withMarkerStyle (
      Size = 25,
      Color = Color.fromString "rgba(17, 157, 255,0.5)",
      Opacity = 0.5,
      Symbol = StyleParam.MarkerSymbol.Circle
  )
  Chart.Point(x, y2, Name = "plot-3", ShowLegend = false)
  |> Chart.withMarkerStyle (
      Size = 25,
      Color = Color.fromString "rgba(17, 157, 255,0.5)",
      Opacity = 0.5,
      Symbol = StyleParam.MarkerSymbol.Circle
  ) ]
|> Chart.combine
```

# Custom Marker Symbols

The MarkerSymbol attribute allows you to choose from a wide array of symbols to represent markers in your figures.

The basic symbols are: circle, square, diamond, cross, x, triangle, pentagon, hexagram, star, diamond, hourglass, bowtie, asterisk, hash, y, and line.

MarkerSymbol.Modified lets you choose SymbolStyle that can be open, dot, open-dot. 

```fsharp dotnet_interactive={"language": "fsharp"}
open Microsoft.FSharp.Reflection


let rawSymbols = (FSharpType.GetUnionCases typeof<StyleParam.MarkerSymbol>).[1..] |> Array.rev

let symbols = [for symbol in rawSymbols -> 
                    let markerStyle = FSharpValue.MakeUnion(symbol,[||]) :?> StyleParam.MarkerSymbol
                    [markerStyle;
                        StyleParam.MarkerSymbol.Modified(markerStyle, StyleParam.SymbolStyle.Open);
                        StyleParam.MarkerSymbol.Modified(markerStyle, StyleParam.SymbolStyle.Dot);
                        StyleParam.MarkerSymbol.Modified(markerStyle, StyleParam.SymbolStyle.OpenDot)] ]
                        |> Seq.concat
let y = [|for symbol in rawSymbols -> [|symbol.Name|] |> Array.replicate 4 |> Array.concat|]
            |> Array.concat

let marker = 
    Marker.init(MultiSymbol=symbols,
                Color = Color.fromString "lightskyblue",
                Outline=Line.init(Color=Color.fromString "midnightblue",Width=2.),
                Size=15)
let x = [|"";"Open";"Dot";"OpenDot"|] |>Array.replicate rawSymbols.Length
            |> Array.concat

Chart.Scatter(x=x,
                y=y,
                mode=StyleParam.Mode.Markers)

|> Chart.withMarker(marker)
|> Chart.withYAxisStyle(title="",MinMax=(-1.,float rawSymbols.Length))
|> Chart.withSize(500,1400)
|> Chart.withMarginSize(Bottom=0,Right=0)
|> Chart.withXAxisStyle(title="",Side=StyleParam.Side.Top)
|> GenericChart.mapTrace (Trace2DStyle.Scatter(HoverTemplate="name: %{y}%{x}<br>number: %{marker.symbol}<extra></extra>"))


```
