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
    description: How to make bubble charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Bubble Charts
    order: 5
    page_type: u-guide
    permalink: fsharp/bubble-charts/
    thumbnail: thumbnail/bubble.jpg
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: newtonsoft.json"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
open Plotly.NET
```

# Simple Bubble Chart

```fsharp  dotnet_interactive={"language": "fsharp"}

open Plotly.NET

Chart.Bubble([1;2;3;4], [10;11;12;13], [40;60;80;100])
```

# Setting Marker Size and Color

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects

let colors = 
    [|"#4287f5";"#cb23fa";"#23fabd";"#ff7b00"|] 
    |> Seq.map Color.fromString
    |> Color.fromColors

Chart.Bubble(x=[1;2;3;4], y=[10;11;12;13], sizes=[40;60;80;100],Color=colors)
```

# Scaling the size of bubble charts

To scale the bubble size, use the attribute Marker Sizeref property. We recommend using the following formula to calculate a sizeref value:
sizeref = 2. * max(array of size values) / (desired maximum marker size ** 2)

Note that setting 'Sizeref' to a value greater than 1, decreases the rendered marker sizes, while setting 'Sizeref' to less than 1, increases the rendered marker sizes. See https://plotly.com/fsharp/reference/scatter/#scatter-marker-sizeref for more information. Additionally, we recommend setting the sizemode attribute: https://plotly.com/fsharp/reference/scatter/#scatter-marker-sizemode to area.

```fsharp  dotnet_interactive={"language": "fsharp"}

open Plotly.NET

let sizes = [20.; 40.; 60.; 80.; 100.; 80.; 60.; 40.; 20.; 40.]
let x = [1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.]
let y = [11.; 12.; 10.; 11.; 12.; 11.; 12.; 13.; 12.; 11.]

Chart.Bubble(x, y, sizes)

|> Chart.withMarker(Marker.init(//Opacity = [1.; 0.8; 0.6; 0.4],
                                MultiSizes = sizes,
                                Sizeref = 2. * (Seq.max sizes) / System.Math.Pow(40., 2.),
                                Sizemode = StyleParam.MarkerSizeMode.Area,
                                Sizemin = 4.0
                                ))
```

# Hover Text with Bubble Charts

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let x=[1; 2; 3; 4]
let y=[10; 11; 12; 13]

let colors = 
    ["rgb(160, 164, 214)"; "rgb(255, 144, 14)";  "rgb(44, 160, 101)"; "rgb(255, 65, 54)"]
    |> Seq.map (fun c -> Color.fromString(c))
    |> Color.fromColors

let marker = Marker.init(MultiSizes=[40; 60; 80; 100],Color=colors)

let labels = ["A<br>size: 40"; "B<br>size: 60"; "C<br>size: 80"; "D<br>size: 100"];

Chart.Scatter(x,y,StyleParam.Mode.Markers, Labels=labels)
    |> Chart.withMarker(marker)

```

# Bubble Charts with Colorscale

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let x=[1.; 3.2; 5.4; 7.6; 9.8; 12.5;]
let y=[1.; 3.2; 5.4; 7.6; 9.8; 12.5;]

let colors=
    [120; 125; 130; 135; 140; 145] 
    |> Seq.cast<IConvertible>
    |> Color.fromColorScaleValues
    

let marker = Marker.init(MultiSizes=[15; 30; 55; 70; 90; 110],Showscale=true,Color=colors)


Chart.Scatter(x,y,StyleParam.Mode.Markers)
    |> Chart.withMarker(marker)

```
