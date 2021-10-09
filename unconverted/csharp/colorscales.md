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
    description: How to set, create and control continuous color scales and color bars
      in scatter, bar, map and heatmap figures.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Continuous Color Scales and Color Bars
    order: 20
    page_type: example_index
    permalink: fsharp/colorscales/
    thumbnail: thumbnail/heatmap_colorscale.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
#r "nuget: Deedle"
#r "nuget: FSharp.Data"
open Plotly.NET

```

# Custom Discretized Heatmap Color scale

```fsharp dotnet_interactive={"language": "fsharp"}
let  z=[[0;1;2;3;4;5;6;7;8;9]]
let customColorscale = StyleParam.Colorscale.Custom [(0.0,"#000000");(1.0,"#B4B4B4")]

Chart.Heatmap(z,Colorscale=customColorscale)
|> Chart.withSize(800.,600.)
```

# Color scale for Scatter Plots


```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let N = 40
let values = [1..40]

let colors = Color.fromColorScaleValues ([|1..40|] |> Seq.cast<IConvertible>)

let marker = Marker.init(Size= 16,Colorscale=StyleParam.Colorscale.Viridis, Showscale=true,Color=colors)

Chart.Scatter(values,values,StyleParam.Mode.Markers) 
|> Chart.withMarker(marker)
```

# Color scale for Contour Plot


```fsharp dotnet_interactive={"language": "fsharp"}
let z=[| [|10.0; 10.625; 12.5; 15.625; 20.0;|];
        [|5.625; 6.25; 8.125; 11.25; 15.625;|];
        [|2.5; 3.125; 5.0; 8.125; 12.5;|];
        [|0.625; 1.25; 3.125; 6.25; 10.625;|];
        [|0.0; 0.625; 2.5; 5.625; 10.0|]|]


Chart.Contour(data=z,Colorscale=StyleParam.Colorscale.Cividis)
```

# Custom Heatmap Color scale


```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data

type jsondata = JsonProvider<"https://raw.githubusercontent.com/plotly/datasets/master/custom_heatmap_colorscale.json">
let data = jsondata.Load("https://raw.githubusercontent.com/plotly/datasets/master/custom_heatmap_colorscale.json")
let z = data.Z

let customColorscale =
    StyleParam.Colorscale.Custom [ (0.0, "rgb(165,0,38)")
                                   (0.11, "rgb(215,48,39)")
                                   (0.22, "rgb(244,109,67)")
                                   (0.33, "rgb(253,174,97)")
                                   (0.44, "rgb(254,224,144)")
                                   (0.55, "rgb(224,243,248)")
                                   (0.66, "rgb(171,217,233)")
                                   (0.77, "rgb(116,173,209)")
                                   (0.88, "rgb(69,117,180)")
                                   (1.0, "rgb(49,54,149)") ]

Chart.Heatmap(z,Colorscale=customColorscale,Showscale=true)

```

# Setting the Midpoint of a Diverging Color scale

The following example uses the Marker Cmid attribute to set the mid-point of the color domain by scaling 'Cmin' and/or 'Cmax' to be equidistant to this point. It only has impact when Marker Color sets, and 'Marker Cauto' is True.


```fsharp dotnet_interactive={"language": "fsharp"}
let N = 20
let colors = [-3..10] |> Seq.cast<IConvertible> |> Color.fromColorScaleValues
let marker = Marker.init(Size= 25,Colorscale=StyleParam.Colorscale.Viridis,Cmid=0.,Color=colors, Showscale=true)

Chart.Scatter([1..20],[-5..15],StyleParam.Mode.Markers) 
|> Chart.withMarker(marker)
   
```

The heatmap chart uses Marker Zmid attribute to set the mid-point of the color domain.  **NOT IMPLEMENTED YET** 

```fsharp dotnet_interactive={"language": "fsharp"}
// let a = [-10..5]
// let b = [-5..10]
// let c = [-5..15]

// let z = [|a;b;c|]
// let marker = Marker.init(Size= 25,Colorscale=StyleParam.Colorscale.Viridis,Cmid=0.,Color=colors, Showscale=true)

// Chart.Heatmap(z,Colorscale=StyleParam.Colorscale.RdBu)
// |> Chart.withMarker(marker)
```

# Custom Contour Plot Color scale

```fsharp dotnet_interactive={"language": "fsharp"}
let z =
    [| [| 10.0; 10.625; 12.5; 15.625; 20.0 |]
       [| 5.625; 6.25; 8.125; 11.25; 15.625 |]
       [| 2.5; 3.125; 5.0; 8.125; 12.5 |]
       [| 0.625; 1.25; 3.125; 6.25; 10.625 |]
       [| 0.0; 0.625; 2.5; 5.625; 10.0 |] |]

//let customColorscale = StyleParam.Colorscale.Custom [(0.0,"#A6CEE3");(1.0,"#E31A1C")]

let customColorscale =
    StyleParam.Colorscale.Custom [ (0.0, "rgb(166,206,227)")
                                   (0.25, "rgb(31,120,180)")
                                   (0.45, "rgb(178,223,138)")
                                   (0.65, "rgb(51,160,44)")
                                   (0.85, "rgb(251,154,153)")
                                   (1.0, "rgb(227,26,28)") ]
Chart.Contour(z,Colorscale=customColorscale)
    |> Chart.withSize(600.,600.)
```

# Custom Color bar Title, Labels, and Ticks 
Like axes, you can customize the color bar ticks, labels, and values with ticks, ticktext, and tickvals.

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET.LayoutObjects
open Plotly.NET.TraceObjects

type jsondata = JsonProvider<"https://raw.githubusercontent.com/plotly/datasets/master/custom_heatmap_colorscale.json">
let data = jsondata.Load("https://raw.githubusercontent.com/plotly/datasets/master/custom_heatmap_colorscale.json")

let z = data.Z
//let customColorscale = StyleParam.Colorscale.Custom [(0.0,"#A6CEE3");(1.0,"#E31A1C")]

let customColorscale = StyleParam.Colorscale.Custom [(0.0,"rgb(165,0,38)");
                                                     (0.11,"rgb(215,48,39)");
                                                     (0.22,"rgb(244,109,67)");
                                                     (0.33,"rgb(253,174,97)");
                                                     (0.44,"rgb(254,224,144)");
                                                     (0.55,"rgb(224,243,248)");
                                                     (0.66,"rgb(171,217,233)");
                                                     (0.77,"rgb(116,173,209)");
                                                     (0.88,"rgb(69,117,180)");
                                                      (1.0,"rgb(49,54,149)");]

let colorBar = ColorBar.init(Title=Title.init("Surface Heat",Side=StyleParam.Side.Top),
                                TickLabelPosition=StyleParam.TickLabelPosition.Outside,
                                TickMode=StyleParam.TickMode.Array,
                                TickVals=[|2;50;100|],
                                TickText=[|"Cool";"Mild";"Hot"|])

Chart.Heatmap(z,Colorscale=customColorscale)
|> Chart.withColorBar(colorBar)

```

# Sharing a Color Axis

To share colorscale information in multiple subplots, you can use ColorAxis. (**NOT IMPLEMENETED YET**)


```fsharp dotnet_interactive={"language": "fsharp"}

let seq1 = [|[|1; 2; 3; 4|]; [|4; -3; -1; 1|]|]
let seq2 = [|[|10; 2; 1; 0|]; [|4; 3; 5; 6|]|]
let marker = Marker.init(Size= 25, Showscale=false);

let colorAxis = ColorAxis.init(AutoColorScale=true)

let heatmap1=
           Chart.Heatmap(data=seq1)
           |> Chart.withMarker(marker)
           |> Chart.withColorAxis(colorAxis, Id=StyleParam.SubPlotId.ColorAxis 1)

let heatmap2=
           Chart.Heatmap(seq2)
           |> Chart.withMarker(marker)
           |> Chart.withColorAxis(colorAxis, Id=StyleParam.SubPlotId.ColorAxis 1)

[|heatmap1;heatmap2|]
|> Chart.Grid(1,2)
|> Chart.withSize(Width=800,Height=500)
```

# Logarithmic Color scale


```fsharp dotnet_interactive={"language": "fsharp"}
let z=[| [|10.; 100.625; 1200.5; 150.625; 2000.;|];
        [|5000.625; 60.25; 8.125; 100000.0; 150.625|];
        [|2000.5; 300.125; 50.; 8.125; 12.5|];
        [|10.625; 1.25; 3.125; 6000.25; 100.625|];
        [|0.; 0.625; 2.5; 50000.625; 10.;|]|]

let customColorscale = StyleParam.Colorscale.Custom [(0.,"rgb(250, 250, 250)");
                                                     (1./10000.,"rgb(200, 200, 200)");
                                                     (1./1000.,"rgb(150, 150, 150)");
                                                     (1./100.,"rgb(100, 100, 100)");
                                                     (1./10.,"rgb(50, 50, 50");
                                                     (1.,"rgb(0, 0, 0)");
                                                     ]

let colorBar = ColorBar.init(   Tick0=0,
                                TickMode=StyleParam.TickMode.Array,
                                TickVals=[|0;1000;10000;100000|])

Chart.Heatmap(z,Colorscale=customColorscale,ColorBar=colorBar)
|> Chart.withSize(800.,600.)
```
