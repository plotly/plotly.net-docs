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
    description: How to make sankey charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Sankey Charts
    order: 5
    page_type: u-guide
    permalink: fsharp/sankey-charts/
    thumbnail: thumbnail/sankey.jpg
---

# Basic Sankey Diagram

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,2.0.0-preview.8"
#r "nuget: FSharp.Data"
```

```fsharp  dotnet_interactive={"language": "fsharp"}

open Plotly.NET

let nodes = [|
 Node.Create("A1")
 Node.Create("A2")
 Node.Create("B1")
 Node.Create("B2")
 Node.Create("C1")
 Node.Create("C2")
|]

Chart.Sankey(
    nodePadding = 15.,    
    nodeColor = "blue",
    nodeThickness = 20.0,
    nodeLineWidth = 0.5,
    nodes = (nodes |> Seq.ofArray),
    links = [
        Link.Create(src = nodes.[0], tgt = nodes.[2], value = 8.)
        Link.Create(src = nodes.[1], tgt = nodes.[3], value = 4.)
        Link.Create(src = nodes.[0], tgt = nodes.[3], value = 3.)
        Link.Create(src = nodes.[2], tgt = nodes.[4], value = 8.)
        Link.Create(src = nodes.[3], tgt = nodes.[4], value = 4.)
        Link.Create(src = nodes.[3], tgt = nodes.[5], value = 2.)
])
|> Chart.withLayout(Layout.init(Title = Title.init("Basic Sankey Diagram"), Font = Font.init(Size = 10.)))
```

# More complex Sankey diagram with colored links

```fsharp  dotnet_interactive={"language": "fsharp"}

open FSharp.Data

type remoteData = JsonProvider<"https://raw.githubusercontent.com/plotly/plotly.js/master/test/image/mocks/sankey_energy.json">
let data = remoteData.Load("https://raw.githubusercontent.com/plotly/plotly.js/master/test/image/mocks/sankey_energy.json")

let node = data.Data.[0].Node
let node_labels = data.Data.[0].Node.Label
let node_color = data.Data.[0].Node.Color
let source = data.Data.[0].Link.Source
let target = data.Data.[0].Link.Target
let values = data.Data.[0].Link.Value

let nodes = [for i in 0..node_labels.Length-1 -> Node.Create(label=node_labels.[i],color=node_color.[i])]
let links = [for i in 0..source.Length-1 -> Link.Create(src=nodes.[source.[i]],tgt=nodes.[target.[i]],value=float values.[i])]

let title = "Energy forecast for 2050<br>Source: Department of Energy & Climate Change, Tom Counsell via <a href='https://bost.ocks.org/mike/sankey/'>Mike Bostock</a>"
Chart.Sankey(nodes=nodes,links=links,
    nodePadding=float node.Pad,
    nodeThickness=float node.Thickness
    )
// |> GenericChart.mapTrace (fun x ->  x.SetValue("valueformat", ".0f")
//                                     x.SetValue("valuesuffix", ".TWh")
//                                     x)
|> Chart.withLayout(Layout.init(Width = 1000, Font = Font.init(Size = 10.), Title = Title.init(title)))
```

# Style Sankey Diagram

```fsharp  dotnet_interactive={"language": "fsharp"}
open FSharp.Data

type remoteData = JsonProvider<"https://raw.githubusercontent.com/plotly/plotly.js/master/test/image/mocks/sankey_energy.json">
let data = remoteData.Load("https://raw.githubusercontent.com/plotly/plotly.js/master/test/image/mocks/sankey_energy.json")

let node = data.Data.[0].Node
let node_labels = data.Data.[0].Node.Label
let node_color = data.Data.[0].Node.Color
let source = data.Data.[0].Link.Source
let target = data.Data.[0].Link.Target
let values = data.Data.[0].Link.Value

let nodes = [for i in 0..node_labels.Length-1 -> Node.Create(label=node_labels.[i],color=node_color.[i])]
let links = [for i in 0..source.Length-1 -> Link.Create(src=nodes.[source.[i]],tgt=nodes.[target.[i]],value=float values.[i])]

let title = "Energy forecast for 2050<br>Source: Department of Energy & Climate Change, Tom Counsell via <a href='https://bost.ocks.org/mike/sankey/'>Mike Bostock</a>"
Chart.Sankey(nodes=nodes,links=links,
    nodePadding=float node.Pad,
    nodeThickness=float node.Thickness
    )
// |> GenericChart.mapTrace (fun x ->  x.SetValue("valueformat", ".0f")
//                                     x.SetValue("valuesuffix", ".TWh")
//                                     x)
|> Chart.withLayout(Layout.init(Width = 1000, Font = Font.init(Size = 10.,Color=Color.fromString "white"), Title = Title.init(title),PlotBGColor=Color.fromString "gray",PaperBGColor=Color.fromString "gray",HoverMode=StyleParam.HoverMode.X))
```

# Define Node Position
