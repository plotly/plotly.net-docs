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
    description: The structure of a figure - data, traces and layout explained.
    display_as: file_settings
    language: fsharp
    layout: base
    name: The Figure Data Structure
    order: 1
    page_type: example_index
    permalink: fsharp/figure-structure/
    thumbnail: thumbnail/violin.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
```

Plotly.NET graphing library can create various graphical figures (i.e. charts, plots, maps and diagrams). The rendering process uses the Plotly.js JavaScript library under the hood. Figures can be represented in F# and serialized as text in JavaScript Object Notation (JSON) before being passed to Plotly.js.

Viewing the underlying data structure for any plotly chart, can be done via GenericChart.toFigure, which gives access to Figure object


# Figures as Trees of Attributes

Plotly.js supports inputs adhering to a well-defined schema, whose overall architecture is explained in this page and which is exhaustively documented in the Figure Reference (which is itself generated from a machine-readable JSON representation of the schema). Figures are represented as trees with named nodes called "attributes". The root node of the tree has three top-level attributes: data, layout and frames (see below).


# Figure Data Structure

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x  = [for i in 0..20 -> i]
let y = [for i in 0..20 -> 2*i*2+3*i+10]

let figure = Chart.Line(x,y)
            |> Chart.withLayout(Layout.init(Width=500,Height=500))
            |> GenericChart.toFigure


figure.Display()
```

# The Top-Level Data Attribute
The first of the three top-level attributes of a figure is Data, whose value must be a list of dicts referred to as "traces".

* Each trace has one of more than 40 possible types (see below for a list organized by subplot type, including e.g. scatter, bar, pie, surface, choropleth etc), and represents a set of related graphical marks in a figure. Each trace * must have a type attribute which defines the other allowable attributes.
* Each trace is drawn on a single subplot whose type must be compatible with the trace's type, or is its own subplot (see below).
* Traces may have a single legend entry, with the exception of pie and funnelarea traces (see below).
* Certain trace types support continuous color, with an associated colorbar, which can be controlled by attributes either within the trace, or within the layout when using the coloraxis attribute.

```fsharp dotnet_interactive={"language": "fsharp"}
figure.Data.[0].GetProperties(true)
```

# The Top-Level Layout Attribute
The second of the three top-level attributes of a figure is Layout, whose value is referred to in text as "the layout" and must be a dict, containing attributes that control positioning and configuration of non-data-related parts of the figure such as:

* Dimensions and margins, which define the bounds of "paper coordinates" (see below)
* Figure-wide defaults: templates, fonts, colors, hover-label and modebar defaults
* Title and legend (positionable in container and/or paper coordinates)
* Color axes and associated color bars (positionable in paper coordinates)
* Subplots of various types on which can be drawn multiple traces and which are positioned in paper coordinates:
* xaxis, yaxis, xaxis2, yaxis3 etc: X and Y cartesian axes, the intersections of which are cartesian subplots
* scene, scene2, scene3 etc: 3d scene subplots
* ternary, ternary2, ternary3, polar, polar2, polar3, geo, geo2, geo3, mapbox, mapbox2, mabox3 etc: ternary, polar, geo or mapbox subplots
* Non-data marks which can be positioned in paper coordinates, or in data coordinates linked to 2d cartesian subplots:
* annotations: textual annotations with or without arrows
* shapes: lines, rectangles, ellipses or open or closed paths
* images: background or decorative images
* Controls which can be positioned in paper coordinates and which can trigger Plotly.js functions when interacted with by a user:
* updatemenus: single buttons, toggles and dropdown menus
* sliders: slider controls

```fsharp dotnet_interactive={"language": "fsharp"}
figure.Layout.GetProperties(true)
```

# The Top-Level frames Attribute
The third of the three top-level attributes of a figure is Frames, whose value must be a list of dicts that define sequential frames in an animated plot. Each frame contains its own data attribute as well as other parameters. Animations are usually triggered and controlled via controls defined in layout.sliders and/or layout.updatemenus

```fsharp dotnet_interactive={"language": "fsharp"}
//figure.Frames.[0].GetProperties(true)
```
