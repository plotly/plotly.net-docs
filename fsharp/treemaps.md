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
    description: How to make Treemap Charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Treemap Charts
    order: 13
    page_type: u-guide
    permalink: fsharp/treemaps/
    thumbnail: thumbnail/treemap.png
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
#r "nuget: Deedle"
#r "nuget: FSharp.Data"
```

Treemap charts visualize hierarchical data using nested rectangles. The input data format is the same as for Sunburst Charts and Icicle Charts: the hierarchy is defined by labels and parents attributes. Click on one sector to zoom in/out, which also displays a pathbar in the upper-left corner of your treemap. To zoom out you can use the path bar as well.


# Basic Treemap

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let labels = ["Eve";"Cain"; "Seth"; "Enos"; "Noam"; "Abel"; "Awan"; "Enoch"; "Azura"]
let parents = [""; "Eve"; "Eve"; "Seth"; "Seth"; "Eve"; "Eve"; "Awan"; "Eve"] 

Chart.Treemap(labels,parents)
|> Chart.withMarginSize(Top=50,Left=25,Right=25,Bottom=25)
```

# Set Different Attributes in Treemap

This example uses the following attributes:

* Values: sets the values associated with each of the sectors.
* Text: determines which trace information appear on the graph that can be 'text', 'value', 'current path', 'percent root', 'percent entry', and 'percent parent', or any combination of them.
* PathBar: a main extra feature of treemap to display the current path of the visible portion of the hierarchical map. It may also be useful for zooming out of the graph.
* Branchvalues: determines how the items in values are summed. When set to "total", items in values are taken to be value of all its descendants. In the example below Eva = 65, which is equal to 14 + 12 + 10 + 2 + 6 + 6 + 1 + 4. When set to "remainder", items in values corresponding to the root and the branches sectors are taken to be the extra part not part of the sum of the values at their leaves.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let labels = ["Eve"; "Cain"; "Seth"; "Enos"; "Noam"; "Abel"; "Awan"; "Enoch"; "Azura"]
let parents = [""; "Eve"; "Eve"; "Seth"; "Seth"; "Eve"; "Eve"; "Awan"; "Eve"]

let values1 = [10.0; 14.0; 12.0; 10.0; 2.0; 6.0; 6.0; 1.0; 4.0]
let values2 = [65.0; 14.0; 12.0; 10.0; 2.0; 6.0; 6.0; 1.0; 4.0]

[
    Chart.Treemap(labels,
            parents,
            Values = values1,                  
            Text = ["label+value+percent parent+percent entry+percent root"],
            Color = Color.fromString "lightgray" )
        |> GenericChart.mapTrace((fun x -> x.SetValue("domain", Domain.init (Row = 0, Column = 0)); x) ) //Workaround

    Chart.Treemap(labels,
            parents,
            Branchvalues = StyleParam.BranchValues.Total,
            Values = values2, 
            Text = ["label+value+percent parent+percent entry"],
            Color = Color.fromString "lightgray") 
            |> GenericChart.mapTrace((fun x -> x.SetValue("domain", Domain.init (Row = 0, Column = 1)); x) ) //Workaround
]
|> Chart.combine
|> Chart.withLayoutGridStyle(Rows=1,Columns=2)
|> Chart.withSize(Width=1100)
|> Chart.withMarginSize(Top=50,Left=25,Right=25,Bottom=25)
```

# Set Color of Treemap Sectors

There are three different ways to change the color of the sectors in Treemap:

1. Marker Color through Color property, 
2. ColorWay 
3. Colorscale
 
The following examples show how to use each of them.


## Marker Colors (Not Working)

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let values = [0.0; 11.0; 12.0; 13.0; 14.0; 15.0; 20.0; 30.0]
let labels = ["container"; "A1"; "A2"; "A3"; "A4"; "A5"; "B1"; "B2"]
let parents = [""; "container"; "A1"; "A2"; "A3"; "A4"; "container"; "B1"]

let markerColors = ["pink"; "royalblue"; "lightgray"; "purple"; 
                        "cyan"; "lightgray"; "lightblue"; "lightgreen"]
                        |> Seq.map (fun c-> Color.fromString c)
                        |> Color.fromColors

Chart.Treemap(labels,
              parents,
              Values = values, 
              Color = markerColors) 

|> Chart.withMarginSize(Top=50,Left=25,Right=25,Bottom=25)

```

## TreemapColorWay

```fsharp dotnet_interactive={"language": "fsharp"}
let labels = ["container"; "A1"; "A2"; "A3"; "A4"; "A5"; "B1"; "B2"]
let parents = [""; "container"; "A1"; "A2"; "A3"; "A4"; "container"; "B1"]
let values = [0.0; 11.0; 12.0; 13.0; 14.0; 15.0; 20.0; 30.0]

let markerColor = [Color.fromString "pink";Color.fromString "lightgray"] |> Color.fromColors
Chart.Treemap(labels,
              parents,
              Values = values) 
              
|> Chart.withLayout(Layout.init(TreeMapColorWay= markerColor))
|> Chart.withMarginSize(Top=50,Left=25,Right=25,Bottom=25)
```

## Colorscale (Not Working)

```fsharp dotnet_interactive={"language": "fsharp"}
let values = [0.0; 11.0; 12.0; 13.0; 14.0; 15.0; 20.0; 30.0]
let labels = ["container"; "A1"; "A2"; "A3"; "A4"; "A5"; "B1"; "B2"]
let parents = [""; "container"; "A1"; "A2"; "A3"; "A4"; "container"; "B1"]

Chart.Treemap(labels,
              parents,
              Values = values ) 
//|> Chart.withLayout(Layout.init(Colorscale= DefaultColorScales.init(Diverging=StyleParam.Colorscale.Viridis)))
|> Chart.withMarginSize(Top=50,Left=25,Right=25,Bottom=25)
```

# Nested Layers in Treemap

The following example uses hierarchical data that includes layers and grouping. Treemap and Sunburst charts reveal insights into the data, and the format of your hierarchical data. maxdepth attribute sets the number of rendered sectors from the given level.

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data

let data = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/96c0bd/sunburst-coffee-flavors-complete.csv")

let Ids = [for row in data.Rows -> row.GetColumn("ids")]
let labels = [for row in data.Rows -> row.GetColumn("labels")]
let parents = [for row in data.Rows -> row.GetColumn("parents")]

Chart.Treemap(labels=labels,            
            parents=parents,
            Ids=Ids,
            Maxdepth=3) 
|> Chart.withSize(Width=1100)
|> Chart.withMarginSize(Top=50,Left=25,Right=25,Bottom=25)
```

# Controlling text fontsize with uniformtext

If you want all the text labels to have the same size, you can use the uniformtext layout parameter. The minsize attribute sets the font size, and the mode attribute sets what happens for labels which cannot fit with the desired fontsize: either hide them or show them with overflow.

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET.TraceObjects

let data = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/96c0bd/sunburst-coffee-flavors-complete.csv")

let Ids = [for row in data.Rows -> row.GetColumn("ids")]
let labels = [for row in data.Rows -> row.GetColumn("labels")]
let parents = [for row in data.Rows -> row.GetColumn("parents")]

Chart.Treemap(labels=labels,            
            parents=parents,
            Ids=Ids,            
            PathBar=Pathbar.init(Textfont=Font.init(Size=15.))) 
|> Chart.withSize(Width=1100)
|> Chart.withLayout(Layout.init(
                            UniformText=UniformText.init(MinSize=10,Mode=StyleParam.UniformTextMode.Hide),
                            Margin = Margin.init(Top=50,Left=25,Right=25,Bottom=25)))
```
