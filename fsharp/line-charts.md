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
    description: How to make line charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Line Charts
    order: 2
    page_type: u-guide
    permalink: fsharp/line-charts/
    thumbnail: thumbnail/line-plot.jpg
---
# Line Charts in F#

How to make line charts in F# with Plotly.NET. Examples on creating and styling line charts in F# with Plotly.NET.

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: newtonsoft.json"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"

open Plotly.NET
open System

let random = System.Random();
let nextFloat (min, max) = (random.NextDouble() * (max - min) + min);
```

# Sime Line Plot

Line Plots can be rendered either by Chart.Scatter or Chart.Line 

```fsharp  dotnet_interactive={"language": "fsharp"}
let xs = [0.0 .. 9.0]
let ys = xs |> Seq.map (fun x -> x ** 2.0)

Chart.Scatter(xs, ys, StyleParam.Mode.Lines_Markers)
```

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [1952; 1957; 1962; 1967; 1972; 1977; 1982; 1987; 1992; 1997; 2002; 2007]
let y = [68.75; 69.96; 71.3; 72.13; 72.88; 74.21; 75.76; 76.86; 77.95; 78.61; 79.77; 80.653]

Chart.Line(x, y)
|> Chart.withXAxisStyle("year")
|> Chart.withYAxisStyle("lifeExp")
|> Chart.withTitle("Life expectancy in Canada")
|> Chart.withLineStyle(Width=2.0, Dash=StyleParam.DrawingStyle.Solid)
```

# MultiLine Chart

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x  = [1952; 1957; 1962; 1967; 1972; 1977; 1982; 1987; 1992; 1997; 2002; 2007]

// Australia
let y1 = [69.12; 70.30; 70.93; 71.1; 71.93; 73.49; 74.74; 76.32; 77.56; 78.3; 80.37; 81.235]
// New Zealand
let y2 = [69.39; 70.26; 71.24; 71.52; 71.89; 72.22; 73.84; 74.32; 76.33; 77.55; 79.11; 80.204]

[
        Chart.Line(x, y1)
        |> Chart.withTraceName(Name="Australia")
        |> Chart.withLineStyle(Width=2.0, Dash=StyleParam.DrawingStyle.Solid)

        Chart.Line(x, y2)
        |> Chart.withTraceName(Name="New Zealand")
        |> Chart.withLineStyle(Width=2.0, Dash=StyleParam.DrawingStyle.Solid) 
] 
|> Chart.combine
|> Chart.withXAxisStyle("year")
|> Chart.withYAxisStyle("lifeExp")
```

# Data Order in Line Charts

Plotly line charts are implemented as connected scatterplots (see below), meaning that the points are plotted and connected with lines in the order they are provided, with no automatic reordering.

This makes it possible to make charts like the one below, but also means that it may be required to explicitly sort data before passing it to Plotly.NET to avoid lines moving "backwards" across the chart.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x  = [1.0; 3.0; 2.0; 4.0]
let y = [1.0; 2.0; 3.0; 4.0]

// How to align title to the left
Chart.Line(x, y)
|> Chart.withTitle("Unsorted Input")
|> Chart.withXAxisStyle("X")
|> Chart.withYAxisStyle("Y")
|> Chart.withLineStyle(Width=2.0, Dash=StyleParam.DrawingStyle.Solid)
```

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let y = [1.0; 3.0; 2.0; 4.0]
let x = Seq.sort x

// How to align title to the left
Chart.Line(x, y)
|> Chart.withTitle("Sorted Input")
|> Chart.withXAxisStyle("X")
|> Chart.withYAxisStyle("Y")
|> Chart.withLineStyle(Width=2.0, Dash=StyleParam.DrawingStyle.Solid) 
```

# Connected Scatterplots

In a connected scatterplot, two continuous variables are plotted against each other, with a line connecting them in some meaningful order, usually a time variable. In the plot below, we show the "trajectory" of a pair of countries through a space defined by GDP per Capita and Life Expectancy. 

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let labels = ["1952"; "1957"; "1962"; "1967"; "1972"; "1977"; "1982"; "1987"; "1992"; "1997"; "2002"; "2007"]

// Botswana
let x1 = [47.622; 49.618; 51.52; 53.298; 56.024; 59.319; 61.484; 63.622; 62.745; 52.556; 46.634; 50.728]
let y1 = [851.2411; 918.2325; 983.654; 1214.709; 2263.611; 3214.858; 4551.142; 6205.884; 7954.112; 8647.142; 11003.61; 12569.85]
// Canada
let x2 = [68.75; 69.96; 71.3; 72.13; 72.88; 74.21; 75.76; 76.86; 77.95; 78.61; 79.77; 80.653]
let y2 = [11367.86; 12489.95; 13462.49; 16076.59; 18970.57; 22090.88; 22898.79; 26626.52; 26342.88; 28954.93; 33328.97; 36319.24]

[
        Chart.Line(
                x1, y1,
                Name="Botswana",
                Labels=labels,
                TextPosition=StyleParam.TextPosition.BottomRight,
                ShowMarkers=true,
                MarkerSymbol=StyleParam.Symbol.Circle
        )


        Chart.Line(
                x2, y2,
                Name="Canada",
                Labels=labels,
                TextPosition=StyleParam.TextPosition.BottomRight,
                ShowMarkers=true,
                MarkerSymbol=StyleParam.Symbol.Circle
        )
]
|> Chart.combine
|> Chart.withXAxisStyle("lifeExp")
|> Chart.withYAxisStyle("gdpPercap")
```

# Line charts with markers

The ShowMarkers argument can be set to True to show markers on lines.
The MarkerSymbol sets the type of Marker like StyleParam.Symbol.Circle or StyleParam.Symbol.Diamond

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x  = [1952; 1957; 1962; 1967; 1972; 1977; 1982; 1987; 1992; 1997; 2002; 2007]

// Australia
let y1 = [69.12; 70.30; 70.93; 71.1; 71.93; 73.49; 74.74; 76.32; 77.56; 78.3; 80.37; 81.235]
// New Zealand
let y2 = [69.39; 70.26; 71.24; 71.52; 71.89; 72.22; 73.84; 74.32; 76.33; 77.55; 79.11; 80.204]

[
        Chart.Line(x, y1, ShowMarkers=true, MarkerSymbol=StyleParam.Symbol.Circle)
        |> Chart.withTraceName(Name="Australia")
        |> Chart.withLineStyle(Width=2.0, Dash=StyleParam.DrawingStyle.Solid)

        Chart.Line(x, y2, ShowMarkers=true, MarkerSymbol=StyleParam.Symbol.Diamond)
        |> Chart.withTraceName(Name="New Zealand")
        |> Chart.withLineStyle(Width=2.0, Dash=StyleParam.DrawingStyle.Solid) 
] 
|> Chart.combine
|> Chart.withXAxisStyle("year")
|> Chart.withYAxisStyle("lifeExp")
```

# Line Plot Modes

```fsharp  dotnet_interactive={"language": "fsharp"}
let n = 100
let series = [0..n]

let generate () = series |> Seq.map (fun _-> nextFloat(-2.0, 2.0))

let random_xs = series

let random_ys0 = generate () |> Seq.map(fun x -> x + 5.0)
let random_ys1 = generate ()
let random_ys2 = generate () |> Seq.map(fun x -> x - 5.0)

// Create traces
[
    Chart.Scatter(random_xs, random_ys0, StyleParam.Mode.Lines)
    |> Chart.withTraceName(Name="lines")

    Chart.Scatter(random_xs, random_ys1, StyleParam.Mode.Lines_Markers)
    |> Chart.withTraceName(Name="lines+markers")

    Chart.Scatter(random_xs, random_ys2, StyleParam.Mode.Markers)
    |> Chart.withTraceName(Name="markers")
]
|> Chart.combine

```

# Style Line Plots
This example styles the color and dash of the traces, adds trace names, modifies line width, and adds plot and axes titles.

```fsharp  dotnet_interactive={"language": "fsharp"}

//  Add data
let month = ["January";"February";"March";"April";"May";"June";"July";"August";"September";"October";"November";"December"]
let high_2000 = [32.5; 37.6; 49.9; 53.0; 69.1; 75.4; 76.5; 76.6; 70.7; 60.6; 45.1; 29.3]
let low_2000 = [13.8; 22.3; 32.5; 37.2; 49.9; 56.1; 57.7; 58.3; 51.2; 42.8; 31.6; 15.9]
let high_2007 = [36.5; 26.6; 43.6; 52.3; 71.5; 81.4; 80.5; 82.2; 76.0; 67.3; 46.1; 35.0]
let low_2007 = [23.6; 14.0; 27.0; 36.8; 47.6; 57.7; 58.9; 61.2; 53.3; 48.5; 31.0; 23.6]
let high_2014 = [28.8; 28.5; 37.0; 56.8; 69.7; 79.7; 78.5; 77.8; 74.1; 62.6; 45.3; 39.9]
let low_2014 = [12.7; 14.3; 18.6; 35.5; 49.9; 58.0; 60.0; 58.6; 51.7; 45.2; 32.2; 29.1]


// Create and style traces
let high2014Chart = Chart.Scatter(month, high_2014, StyleParam.Mode.Lines_Markers,  Name="High 2014")
                        |> Chart.withLineStyle(Color =Color.fromString "firebrick", Width=4.)

let low2014Chart = Chart.Scatter(month, low_2014, StyleParam.Mode.Lines_Markers,  Name="Low 2014")
                        |> Chart.withLineStyle(Color = Color.fromString "royalblue", Width=4.)

let high2007Chart = Chart.Scatter(month, high_2007, StyleParam.Mode.Lines_Markers,  Name="High 2007")
                        |> Chart.withLineStyle(Color =Color.fromString "firebrick", Width=4., Dash=StyleParam.DrawingStyle.Dash)  
                        //dash options include 'dash', 'dot', and 'dashdot'

let low2007Chart = Chart.Scatter(month, low_2007, StyleParam.Mode.Lines_Markers,  Name="Low 2007")
                        |> Chart.withLineStyle(Color = Color.fromString "royalblue", Width=4., Dash=StyleParam.DrawingStyle.Dash)  


let high2000Chart = Chart.Scatter(month, high_2000, StyleParam.Mode.Lines_Markers,  Name="High 2000")
                        |> Chart.withLineStyle(Color = Color.fromString "firebrick", Width=4., Dash=StyleParam.DrawingStyle.Dot)

let low2000Chart = Chart.Scatter(month, low_2000, StyleParam.Mode.Lines_Markers,  Name="Low 2000")
                        |> Chart.withLineStyle(Color = Color.fromString "royalblue", Width=4., Dash=StyleParam.DrawingStyle.Dot)  


[
    high2014Chart;
    low2014Chart;
    high2007Chart;
    low2007Chart;
    high2000Chart;
    low2000Chart

] 
    |> Chart.combine
    |> Chart.withTitle("Average High and Low Temperatures in New York")
    |> Chart.withXAxisStyle ("Month")
    |> Chart.withYAxisStyle ("Temperature (degrees F)")

```

# Connect Data Gaps
ConnectGaps determines if missing values in the provided data are shown as a gap in the graph or not

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let xs = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15]

let chart = Chart.Scatter(xs,
             [10.; 20.; nan; 15.; 10.; 5.; 15.;nan; 20.; 10.; 10.; 15.; 25.; 20.; 10.], 
             StyleParam.Mode.Lines_Markers, Name="<b>No</b> Gaps")             
             |> GenericChart.mapTrace (Trace2DStyle.Scatter(ConnectGaps = true))
[
    
    chart;
    Chart.Scatter(xs,
             [5.; 15.; nan; 10.; 5.; 0.; 10.; nan; 15.; 5.; 5.; 10.; 20.; 15.; 5.], 
             StyleParam.Mode.Lines_Markers, Name="Gaps")
] |> Chart.combine
```

# Interpolation with Line Plots

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.LayoutObjects

let xs = [1; 2; 3; 4; 5]
let ys = [1; 3; 2; 3; 1]

let linear = Chart.Scatter(xs, ys, StyleParam.Mode.Lines_Markers,Name="linear") 
            |> Chart.withLineStyle(Shape =StyleParam.Shape.Linear)

let spline = Chart.Scatter(xs, ys |> Seq.map(fun y->y+5) ,StyleParam.Mode.Lines_Markers,Labels=["tweak line smoothness<br>with 'smoothing' in line object"],Name="spline") 
            |> Chart.withLineStyle(Shape =StyleParam.Shape.Spline)

let vhv = Chart.Scatter(xs, ys |> Seq.map(fun y->y+10), StyleParam.Mode.Lines_Markers,Name="vhv") 
            |> Chart.withLineStyle(Shape =StyleParam.Shape.Vhv)

let hvh = Chart.Scatter(xs, ys |> Seq.map(fun y->y+15), StyleParam.Mode.Lines_Markers,Name="hvh") 
            |> Chart.withLineStyle(Shape =StyleParam.Shape.Hvh)

let vh = Chart.Scatter(xs, ys |> Seq.map(fun y->y+20), StyleParam.Mode.Lines_Markers,Name="vh") 
            |> Chart.withLineStyle(Shape =StyleParam.Shape.Vh)

let hv = Chart.Scatter(xs,  ys |> Seq.map(fun y->y+25), StyleParam.Mode.Lines_Markers,Name="hv") 
            |> Chart.withLineStyle(Shape =StyleParam.Shape.Hv)

[
    linear;
    spline;
    vhv;
    hvh;
    vh;
    hv  ]
|> Chart.combine
|> Chart.withLegend(Legend.init(Y=0.5,TraceOrder=StyleParam.TraceOrder.Reversed))
|> Chart.withLayout(Layout.init(Font=Font.init(Size=16.)))

```

# Label Lines with Annotations

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let title = "Main Source for News"
let labels = ["Television"; "Newspaper"; "Internet"; "Radio"]
let colors = ["rgb(67,67,67)"; "rgb(115,115,115)"; "rgb(49,130,189)"; "rgb(189,189,189)"]
                |> Seq.map (fun c -> Color.fromString c)
                |> Seq.toArray

let mode_size = [|8; 8; 12; 8|]
let line_size = [|2.; 2.; 4.; 2.|]

let x_data = [1 ..4 ] |> Seq.map(fun _-> [|2001 .. 2014|]) |> Seq.toArray

let y_data = [|
    [|74; 82; 80; 74; 73; 72; 74; 70; 70; 66; 66; 69|];
    [|45; 42; 50; 46; 36; 36; 34; 35; 32; 31; 31; 28|];
    [|13; 14; 20; 24; 20; 24; 24; 40; 35; 41; 43; 50|];
    [|18; 21; 18; 21; 16; 14; 13; 18; 17; 16; 19; 23|]|]

let annotations = seq {
        for (y_trace, label, color) in Seq.zip3 y_data labels colors do

        // labeling the left_side of the plot     
        let a1 = Annotation.init(XRef="paper", X=0.05, Y=y_trace.[0],
                                  Text=  $"{label} {y_trace.[0]}%%",
                                  ShowArrow=false,
                                  Font=Font.init(Family=StyleParam.FontFamily.Arial, Size=16.), 
                                  XAnchor = StyleParam.XAnchorPosition.Right,
                                  YAnchor = StyleParam.YAnchorPosition.Middle)

        //labeling the right_side of the plot
        let a2 = Annotation.init(XRef="paper", X=0.95, Y=y_trace.[11],
                                  Text=  $"{y_trace.[11]}%%",
                                  ShowArrow=false,
                                  Font=Font.init(Family=StyleParam.FontFamily.Arial, Size=16.),
                                  XAnchor = StyleParam.XAnchorPosition.Left,
                                  YAnchor = StyleParam.YAnchorPosition.Middle);

        // Title
        let a3 =  Annotation.init(XRef="paper",YRef="paper", X=0., Y=1.05,
                                  Text=  "Main Source for News",
                                  ShowArrow=false,
                                  Font=Font.init(Family=StyleParam.FontFamily.Arial, 
                                                 Size=30.,
                                                 Color=Color.fromString "rgb(37,37,37)"),
                                  XAnchor=StyleParam.XAnchorPosition.Left,
                                  YAnchor = StyleParam.YAnchorPosition.Bottom);
        
        // Source
        let a4 = Annotation.init(XRef="paper",YRef="paper", X=0.5, Y= -0.1,
                                  Text=  "Source: PewResearch Center & Storytelling with data",
                                  ShowArrow=false,
                                  Font=Font.init(Family=StyleParam.FontFamily.Arial, 
                                                 Size=12.,
                                                 Color=Color.fromString "rgb(150,150,150)"),
                                  XAnchor=StyleParam.XAnchorPosition.Center,
                                  YAnchor = StyleParam.YAnchorPosition.Top)

                            
        yield! [a1;a2;a3;a4]
    }


seq {
    for i in 0..3 do
        yield! [
                Chart.Scatter(x_data.[i], y_data.[i], StyleParam.Mode.Lines,Name= labels.[i])
                    |> Chart.withLineStyle(Width=line_size.[i], Color=colors.[i])

                // endpoints
                Chart.Scatter([x_data.[i].[0]; x_data.[i].[^0]],
                              [y_data.[i].[0]; y_data.[i].[^0]],
                              mode=StyleParam.Mode.Markers)
                    
                |> Chart.withMarkerStyle(Size=mode_size.[i], Color=colors.[i])
        ]        
} |> Chart.combine
  |> Chart.withLayout(Layout.init(AutoSize=false, ShowLegend=false, PlotBGColor=Color.fromString "white"))
  |> Chart.withXAxis(LinearAxis.init(ShowLine=true,
                                            ShowGrid=false,
                                            ShowTickLabels=true,
                                            LineColor=Color.fromString "rgb(204, 204, 204)",
                                            LineWidth=2.,
                                            Ticks=StyleParam.TickOptions.Outside,
                                            TickFont = Font.init(Family=StyleParam.FontFamily.Arial,
                                                                 Size=12.,
                                                                 Color=Color.fromString "rgb(82, 82, 82)")))

    |> Chart.withYAxis(LinearAxis.init(ShowGrid=false,
                                             ZeroLine=false,
                                             ShowLine=false,
                                             ShowTickLabels=false))
    |> Chart.withMarginSize(Autoexpand=false, Left=100, Right=20,Top=110)
        // Adding labels
    |> Chart.withAnnotations(annotations)
```

# Filled Lines

```fsharp  dotnet_interactive={"language": "fsharp"}
let x = [1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.]
let x_rev = x |> Seq.rev

// Line 1
let y1 = [1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.]
let y1_upper = [2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.; 11.]
let y1_lower = [0.; 1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.]|> Seq.rev

// Line 2
let y2 = [5.; 2.5; 5.; 7.5; 5.; 2.5; 7.5; 4.5; 5.5; 5.]
let y2_upper = [5.5; 3.; 5.5; 8.; 6.; 3.; 8.; 5.; 6.; 5.5]
let y2_lower = [4.5; 2.; 4.4; 7.; 4.; 2.; 7.; 4.; 5.; 4.75] |> Seq.rev

// Line 3
let y3 = [10.; 8.; 6.; 4.; 2.; 0.; 2.; 4.; 2.; 0.]
let y3_upper = [11.; 9.; 7.; 5.; 3.; 1.; 3.; 5.; 3.; 1.]
let y3_lower = [9.; 7.; 5.; 3.; 1.; -5.; 1.; 3.; 1.; -1.]|> Seq.rev


[
    Chart.Scatter((Seq.append x x_rev),
                  (Seq.append y1_upper y1_lower),
                  StyleParam.Mode.Lines,
                   ShowLegend=false,
                   Name="Fair") 
        |> Chart.withLineStyle(Color=Color.fromString "rgba(255,255,255,0)")
        |> GenericChart.mapTrace(Trace2DStyle.Scatter(Fill = StyleParam.Fill.ToSelf,FillColor= Color.fromString "rgba(0,100,80,0.2)"))
        

    ;Chart.Scatter((Seq.append x x_rev),
                  (Seq.append y2_upper y2_lower),
                  StyleParam.Mode.Lines,
                   ShowLegend=false,
                   Name="Premium")
        |> Chart.withLineStyle(Color=Color.fromString "rgba(255,255,255,0)")
        |> GenericChart.mapTrace(Trace2DStyle.Scatter(Fill = StyleParam.Fill.ToSelf,FillColor= Color.fromString "rgba(rgba(0,176,246,0.2))"))
        
        
    ;Chart.Scatter((Seq.append x x_rev),
                  (Seq.append y3_upper y3_lower),
                  StyleParam.Mode.Lines,
                   ShowLegend=false,
                   Name="Ideal")
        |> Chart.withLineStyle(Color=Color.fromString "rgba(255,255,255,0)")
        |> GenericChart.mapTrace(Trace2DStyle.Scatter(Fill = StyleParam.Fill.ToSelf,FillColor= Color.fromString "rgba(231,107,243,0.2)"))
            

    ;Chart.Scatter(x,y1,StyleParam.Mode.Lines,Name="Fair") 
        |> Chart.withLineStyle(Color=Color.fromString "rgb(0,100,80)")

    ;Chart.Scatter(x,y2,StyleParam.Mode.Lines,Name="Premium") 
        |> Chart.withLineStyle(Color=Color.fromString "rgb(0,176,246)")

    ;Chart.Scatter(x,y3,StyleParam.Mode.Lines,Name="Ideal") 
        |> Chart.withLineStyle(Color=Color.fromString "rgb(231,107,243)")

] |> Chart.combine
```
