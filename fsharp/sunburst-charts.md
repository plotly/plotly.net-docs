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
    description: How to make Sunburst Charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Sunburst Charts
    order: 10
    page_type: u-guide
    permalink: fsharp/sunburst-charts/
    thumbnail: thumbnail/sunburst.gif
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
#r "nuget: FSharp.Data"
```

Sunburst plots visualize hierarchical data spanning outwards radially from root to leaves. Similar to Icicle charts and Treemaps, the hierarchy is defined by labels and parents attributes. The root starts from the center and children are added to the outer rings.


# Basic Sunburst Plot

The following example creates a basic Sunburst Plot

Main arguments:

* labels : sets the labels of sunburst sectors.
* parents: sets the parent sectors of sunburst sectors. An empty string "" is used for the root node in the hierarchy. In this example, the root is "Eve".
* values: sets the values associated with sunburst sectors, determining their width (See the branchvalues section below for different modes for setting the width).

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let labels=["Eve"; "Cain"; "Seth"; "Enos"; "Noam"; "Abel"; "Awan"; "Enoch"; "Azura"]
let parents=[""; "Eve"; "Eve"; "Seth"; "Seth"; "Eve"; "Eve"; "Awan"; "Eve" ]
let values=[10.; 14.; 12.; 10.; 2.; 6.; 6.; 4.; 4.]

Chart.Sunburst(labels=labels, Values=values, parents=parents)
|> Chart.withLayout(Layout.init(Margin = Margin.init(Top = 0., Left = 0., Right = 0., Bottom = 0.)))
```

# Sunburst with Repeated Labels

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let ids=[
    "North America"; "Europe"; "Australia"; "North America - Football"; "Soccer";
    "North America - Rugby"; "Europe - Football"; "Rugby";
    "Europe - American Football";"Australia - Football"; "Association";
    "Australian Rules"; "Autstralia - American Football"; "Australia - Rugby";
    "Rugby League"; "Rugby Union"
]
let labels= [
    "North<br>America"; "Europe"; "Australia"; "Football"; "Soccer"; "Rugby";
    "Football"; "Rugby"; "American<br>Football"; "Football"; "Association";
    "Australian<br>Rules"; "American<br>Football"; "Rugby"; "Rugby<br>League";
    "Rugby<br>Union"
]
let  parents=[
    ""; ""; ""; "North America"; "North America"; "North America"; "Europe";
    "Europe"; "Europe";"Australia"; "Australia - Football"; "Australia - Football";
    "Australia - Football"; "Australia - Football"; "Australia - Rugby";
    "Australia - Rugby"
]

Chart.Sunburst(Ids=ids, labels=labels, parents=parents)
|> Chart.withMargin(Margin.init(Top = 0., Left = 0., Right = 0., Bottom = 0.))
```

# Branchvalues

With branchvalues "total", the value of the parent represents the width of its wedge. In the example below, "Enoch" is 4 and "Awan" is 6 and so Enoch's width is 4/6ths of Awans. With branchvalues "remainder", the parent's width is determined by its own value plus those of its children. So, Enoch's width is 4/10ths of Awan's (4 / (6 + 4)).

Note that this means that the sum of the values of the children cannot exceed the value of their parent when branchvalues is set to "total". When branchvalues is set to "remainder" (the default), children will not take up all of the space below their parent (unless the parent is the root and it has a value of 0).

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let labels = [ "Eve"; "Cain"; "Seth"; "Enos"; "Noam"; "Abel"; "Awan"; "Enoch"; "Azura"]
let parents = ["";    "Eve";  "Eve";  "Seth"; "Seth"; "Eve";  "Eve";  "Awan";  "Eve" ]
let values = [  65.;  14.;  12.;  10.;  2.;  6.;  6.;  4.;  4.]

Chart.Sunburst(Values=values, labels=labels, parents=parents, Branchvalues = StyleParam.BranchValues.Total)
|> Chart.withMargin(Margin.init(Top = 0., Left = 0., Right = 0., Bottom = 0.))
```

# Large Number of Slices

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open FSharp.Data

type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/sunburst-coffee-flavors-complete.csv">
type DFII = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/coffee-flavors.csv">
let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/sunburst-coffee-flavors-complete.csv")
let df2 = DFII.Load("https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/coffee-flavors.csv")


[ 
    Chart.Sunburst(
        Ids = [ for row in df1.Rows -> row.Ids ],
        labels = [ for row in df1.Rows -> row.Labels ],
        parents = [ for row in df1.Rows -> row.Parents ])
    |> GenericChart.mapTrace //Workaround
        (fun x -> x.SetValue("domain", Domain.init (Row = 0, Column = 0)); x) 
    Chart.Sunburst(Ids = [ for row in df2.Rows -> row.Ids ],
        labels = [ for row in df2.Rows -> row.Labels ],
        parents = [ for row in df2.Rows -> row.Parents ],
        Maxdepth = 2)
    |> GenericChart.mapTrace //Workaround
      (fun x -> x.SetValue("domain", Domain.init (Row = 0, Column = 1)); x) 
] 
|> Chart.combine
|> Chart.withMargin (Margin.init (Top = 0., Left = 0., Right = 0., Bottom = 0.))
|> Chart.withSize (Width = 1100)
|> Chart.withLayoutGrid (LayoutGrid.init (Rows = 1, Columns = 2))
```

# Controlling text orientation inside sunburst sectors

The InsideTextOrientation attribute controls the orientation of text inside sectors. With "Auto" the texts may automatically be rotated to fit with the maximum size inside the slice. Using "Horizontal" (resp. "radial", "tangential") forces text to be horizontal (resp. radial or tangential). Note that plotly may reduce the font size in order to fit the text with the requested orientation.



```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/coffee-flavors.csv">
let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/coffee-flavors.csv")

Chart.Sunburst(
        Ids=[for row in df1.Rows -> row.Ids], 
        labels=[for row in df1.Rows -> row.Labels], 
        parents=[for row in df1.Rows -> row.Parents], 
        Maxdepth = 2)
|> GenericChart.mapTrace(fun x -> x.SetValue("insidetextorientation", "radial"); x) //Workaround
|> Chart.withLayout(Layout.init(Margin = Margin.init(Top = 10., Left = 10., Right = 10., Bottom = 10.)))
```

# Controlling text fontsize with uniformtext

If you want all the text labels to have the same size, you can use the uniformtext layout parameter. The minsize attribute sets the font size, and the mode attribute sets what happens for labels which cannot fit with the desired fontsize: either hide them or show them with overflow.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/sunburst-coffee-flavors-complete.csv">
let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/sunburst-coffee-flavors-complete.csv")

let layout = //Workaround
    let tmp = Layout()
    tmp?uniformtext <- {| minsize = 10; mode = "hide" |}
    tmp

Chart.Sunburst(
        Ids=[for row in df1.Rows -> row.Ids], 
        labels=[for row in df1.Rows -> row.Labels], 
        parents=[for row in df1.Rows -> row.Parents])
|> Chart.withLayout(layout)
```

# Sunburst chart with a continuous colorscale (not finished)
The example below visualizes a breakdown of sales (corresponding to sector width) and call success rate (corresponding to sector color) by region, county and salesperson level. For example, when exploring the data you can see that although the East region is behaving poorly, the Tyler county is still above average -- however, its performance is reduced by the poor success rate of salesperson GT.

```fsharp  dotnet_interactive={"language": "fsharp"}
// open Plotly.NET
// open FSharp.Data

// type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/master/sales_success.csv">
// let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/master/sales_success.csv")
// type Record = {region: string; county: string; salesperson: string; calls: int; sales: int}

// let buildHierarchicalDataframe = 
//     let ids = [ for row in df1.Rows do {region = row.Item2; county = row.Item3; salesperson = row.Item4; calls = row.Item5; sales = row.Item6} ]
//     ids

// let regions = [for x in df1.Rows do x.Item2, "total"] |> Set.ofList
// let counties = [for x in df1.Rows do x.Item3, x.Item2] |> Set.ofList
// let salesperson = [for x in df1.Rows do x.Item4, x.Item3] |> Set.ofList

// let byRegion = [ for region in regions do fst region, snd region, List.sumBy (fun (x: Record) -> if x.region = fst region then x.calls else 0) buildHierarchicalDataframe]
// let byCounties = [ for county in counties do fst county, snd county, List.sumBy (fun (x: Record) -> if x.county = fst county then x.calls else 0) buildHierarchicalDataframe]
// let bySalesperson = [ for sp in salesperson do fst sp, snd sp, List.sumBy (fun (x: Record) -> if x.salesperson = fst sp then x.calls else 0) buildHierarchicalDataframe]
// let data = List.append (List.append (List.append byRegion byCounties) bySalesperson)  ["total", "", List.sumBy (fun x -> x.calls) buildHierarchicalDataframe] |> Array.ofList
// let ids = [for x, _, _ in data do x]
// let parents = [for _, y, _ in data do y]
// let values = [for _, _, z in data do z |> float]
// [
//     Chart.Sunburst(Ids = ids, labels = ids, parents = parents, Values = values, Branchvalues = StyleParam.BranchValues.Total)
//     |> GenericChart.mapTrace //Workaround
//             (fun x -> x.SetValue("domain", Domain.init (Row = 0, Column = 0)); x) 
//     Chart.Sunburst(Ids = ids, labels = ids, parents = parents, Values = values, Branchvalues = StyleParam.BranchValues.Total, Maxdepth = 2)
//     |> GenericChart.mapTrace //Workaround
//             (fun x -> x.SetValue("domain", Domain.init (Row = 0, Column = 1)); x) 
// ]
// |>Chart.combine
// |> Chart.withLayoutGridStyle(Rows=1,Columns=2)
// |> Chart.withSize(Width=1100)


```
