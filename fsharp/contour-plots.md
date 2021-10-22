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
    description: How to make Contour plots in F# with Plotly.
    display_as: scientific
    language: fsharp
    layout: base
    name: Contour Plots
    order: 1
    page_type: example_index
    permalink: fsharp/contour-plots/
    thumbnail: thumbnail/contour.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Newtonsoft.Json, 12.0.3"
#r "nuget: Plotly.NET, 2.0.0-preview.10"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.10"
#r "nuget: FSharp.Data"
```

# Basic Contour Plot

A 2D contour plot shows the <a href="https://en.wikipedia.org/wiki/Contour_line" target="_blank">contour lines</a> of a 2D numerical array z, i.e. interpolated lines of isovalues of z.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let z = [[10.; 10.625; 12.5; 15.625; 20.];
           [5.625; 6.25;8.125;11.25;15.625];
           [2.5; 3.125; 5.; 8.125; 12.5];
           [0.625; 1.25; 3.125; 6.25; 10.625];
           [0.; 0.625; 2.5; 5.625; 10.]]

z|> Chart.Contour
```

# Setting X and Y Coordinates in a Contour Plot

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let z = [[10.; 10.625; 12.5; 15.625; 20.];
           [5.625; 6.25;8.125;11.25;15.625];
           [2.5; 3.125; 5.; 8.125; 12.5];
           [0.625; 1.25; 3.125; 6.25; 10.625];
           [0.; 0.625; 2.5; 5.625; 10.]]

Chart.Contour(data=z,X=[-9; -6; -5 ; -3; -1],Y=[0; 1; 4; 5; 7],zSmooth=StyleParam.SmoothAlg.Best)
```

# Colorscale for Contour Plot

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let z = [[10.; 10.625; 12.5; 15.625; 20.];
           [5.625; 6.25;8.125;11.25;15.625];
           [2.5; 3.125; 5.; 8.125; 12.5];
           [0.625; 1.25; 3.125; 6.25; 10.625];
           [0.; 0.625; 2.5; 5.625; 10.]]

Chart.Contour(data=z,Colorscale=StyleParam.Colorscale.Electric)
```

# Customizing Size and Range of a Contour Plot's Contours (ABSTRACTION MISSING)


# Customizing Spacing Between X and Y Axis Ticks

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let z = [[10.; 10.625; 12.5; 15.625; 20.];
           [5.625; 6.25;8.125;11.25;15.625];
           [2.5; 3.125; 5.; 8.125; 12.5];
           [0.625; 1.25; 3.125; 6.25; 10.625];
           [0.; 0.625; 2.5; 5.625; 10.]]

Chart.Contour(data=z,Colorscale=StyleParam.Colorscale.Electric)
|> GenericChart.mapTrace (Trace2DStyle.Contour(X0=5,dX=10,Y0=10,dY=10))
```

# Connect the Gaps Between None Values in the Z Matrix

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let z = [[Double.NaN;Double.NaN ; Double.NaN; 12.; 13.; 14.; 15.; 16.];
     [Double.NaN; 1.; Double.NaN; 11.; Double.NaN; Double.NaN; Double.NaN; 17.];
     [Double.NaN; 2.; 6.; 7.; Double.NaN; Double.NaN; Double.NaN; 18.];
     [Double.NaN; 3.; Double.NaN; 8.; Double.NaN; Double.NaN; Double.NaN; 19.];
     [5.; 4.; 10.; 9.; Double.NaN; Double.NaN; Double.NaN; 20.];
     [Double.NaN; Double.NaN; Double.NaN; 27.; Double.NaN; Double.NaN; Double.NaN; 21.];
     [Double.NaN; Double.NaN; Double.NaN; 26.; 25.; 24.; 23.; 22.]]

[
    Chart.Contour(data=z,Showscale=false)
    Chart.Contour(data=z,Showscale=false)
    |> GenericChart.mapTrace(fun t -> t?connectgaps<-true;t)
    Chart.Contour(data=z,Showscale=false,zSmooth=StyleParam.SmoothAlg.Best)
    Chart.Contour(data=z,Showscale=false,zSmooth=StyleParam.SmoothAlg.Best)
    |> GenericChart.mapTrace(fun t -> t?connectgaps<-true;t)
] |> Chart.Grid(2,2)

```

# Smoothing the Contour lines (ABSTRACTION MISSING) (NOT WORKING)

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let z =   [[2; 4; 7; 12; 13; 14; 15; 16];
       [3; 1; 6; 11; 12; 13; 16; 17];
       [4; 2; 7; 7; 11; 14; 17; 18];
       [5; 3; 8; 8; 13; 15; 18; 19];
       [7; 4; 10; 9; 16; 18; 20; 19];
       [9; 10; 5; 27; 23; 21; 21; 21];
       [11; 14; 17; 26; 25; 24; 23; 22]]


[
Chart.Contour(z,Name="Without Smoothing")
|> GenericChart.mapTrace (fun t -> t?line_smoothing <- 0;t)
Chart.Contour(z,Name="With Smoothing")
|> GenericChart.mapTrace (fun t -> t?line_smoothing <- 0.85;t)
]|> Chart.Grid(1,2)
```

# Smooth Contour Coloring (ABSTRACTION MISSING)


# Contour Line Labels (ABSTRACTION MISSING)


# Contour Lines (ABSTRACTION MISSING)


# Custom Contour Plot Colorscale

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let z = [[10.; 10.625; 12.5; 15.625; 20.];
           [5.625; 6.25;8.125;11.25;15.625];
           [2.5; 3.125; 5.; 8.125; 12.5];
           [0.625; 1.25; 3.125; 6.25; 10.625];
           [0.; 0.625; 2.5; 5.625; 10.]]

let colorscale = StyleParam.Colorscale.Custom([(0., "gold"); (0.5, "mediumturquoise"); (1., "lightsalmon")])

Chart.Contour(data=z,Colorscale=colorscale)

```

# Color Bar Title

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let z = [[10.; 10.625; 12.5; 15.625; 20.];
           [5.625; 6.25;8.125;11.25;15.625];
           [2.5; 3.125; 5.; 8.125; 12.5];
           [0.625; 1.25; 3.125; 6.25; 10.625];
           [0.; 0.625; 2.5; 5.625; 10.]]

let colorBar =
    ColorBar.init (
        Title =
            Title.init (
                "Color bar Title",
                Side = StyleParam.Side.Right,
                Font = Font.init (Family = StyleParam.FontFamily.Arial, Size = 14.)
            )
    )

Chart.Contour(data=z,ColorBar=colorBar)
```

# Color Bar Size for Contour Plots

In the example below, both the thickness (given here in pixels) and the length (given here as a fraction of the plot height) are set.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let z = [[10.; 10.625; 12.5; 15.625; 20.];
           [5.625; 6.25;8.125;11.25;15.625];
           [2.5; 3.125; 5.; 8.125; 12.5];
           [0.625; 1.25; 3.125; 6.25; 10.625];
           [0.; 0.625; 2.5; 5.625; 10.]]

let colorBar =
    ColorBar.init (
        Thickness = 25.,
        ThicknessMode = StyleParam.UnitMode.Pixels,
        Len = 0.6,
        LenMode = StyleParam.UnitMode.Fraction,
        OutlineWidth = 0.
    )

Chart.Contour(data=z,ColorBar=colorBar)
```

# Styling Color Bar Ticks for Contour Plots

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let z = [[10.; 10.625; 12.5; 15.625; 20.];
           [5.625; 6.25;8.125;11.25;15.625];
           [2.5; 3.125; 5.; 8.125; 12.5];
           [0.625; 1.25; 3.125; 6.25; 10.625];
           [0.; 0.625; 2.5; 5.625; 10.]]

let colorBar =
    ColorBar.init (
        NTicks = 10,
        Ticks = StyleParam.TickOptions.Outside,
        TickLen = 5.,
        TickWidth = 1.,
        ShowTickLabels = true,
        TickAngle = 0,
        TickFont = Font.init (Size = 12.)
    )

Chart.Contour(data=z,ColorBar=colorBar)
```
