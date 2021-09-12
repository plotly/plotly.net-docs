---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.12.0
  kernelspec:
    display_name: .NET (C#)
    language: C#
    name: .net-csharp
---

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: newtonsoft.json"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET
```

## Simple Bubble Chart

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

Chart.Bubble([1;2;3;4], [10;11;12;13], [40;60;80;100])
```

## Setting Marker Size and Color

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let colors = ["rgb(93, 164, 214)"; "rgb(255, 144, 14)"; "rgb(44, 160, 101)"; "rgb(255, 65, 54)"]

Chart.Bubble([1;2;3;4], [10;11;12;13], [40;60;80;100])
|> GenericChart.mapTrace(fun x -> x.SetValue("mode", "markers"); x.SetValue("marker", {|color = colors; opacity = [1.; 0.8; 0.6; 0.4]; size = [40;60;80;100]|}); x)
```

## Scaling the size of bubble charts

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let sizes = [20.; 40.; 60.; 80.; 100.; 80.; 60.; 40.; 20.; 40.]
let x = [1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.]
let y = [11.; 12.; 10.; 11.; 12.; 11.; 12.; 13.; 12.; 11.]
Chart.Bubble(x, y, sizes)

(*|> Chart.withMarker(Marker.init(//Opacity = [1.; 0.8; 0.6; 0.4],
                                MultiSizes = sizes,
                                Sizeref = 2. * (Seq.max sizes) / System.Math.Pow(40., 2.),
                                Sizemode = StyleParam.SizeMode.Area,
                                Sizemin = 4.0
                                ))*)
                                
|> GenericChart.mapTrace(fun x -> x.SetValue("mode", "markers"); 
                                  x.SetValue("marker", {|opacity = [1.; 0.8; 0.6; 0.4]; 
                                                         size = sizes; 
                                                         sizemode = "area"; 
                                                         sizeref=(2.*(Seq.max sizes)/System.Math.Pow(40., 2.)); 
                                                         sizemin = 4|}); 
                                  x)
```

## Hover Text with Bubble Charts

```csharp dotnet_interactive={"language": "fsharp"}
let x=[1; 2; 3; 4]
let y=[10; 11; 12; 13]

let marker = Marker.init(MultiSizes=[40; 60; 80; 100])
marker?color <- ["rgb(93, 164, 214)"; "rgb(255, 144, 14)";  "rgb(44, 160, 101)"; "rgb(255, 65, 54)"] //workaround

let labels = ["A<br>size: 40"; "B<br>size: 60"; "C<br>size: 80"; "D<br>size: 100"];
Chart.Scatter(x,y,StyleParam.Mode.Markers, Labels=labels)
    |> Chart.withMarker(marker)

```

## Bubble Charts with Colorscale

```csharp dotnet_interactive={"language": "fsharp"}
let x=[1.; 3.2; 5.4; 7.6; 9.8; 12.5;]
let y=[1.; 3.2; 5.4; 7.6; 9.8; 12.5;]

let marker = Marker.init(MultiSizes=[15; 30; 55; 70; 90; 110],Showscale=true)
marker?color <- [120; 125; 130; 135; 140; 145] //workaround

Chart.Scatter(x,y,StyleParam.Mode.Markers)
    |> Chart.withMarker(marker)

```
