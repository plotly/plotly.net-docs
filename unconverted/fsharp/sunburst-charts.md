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

## Basic Sunburst Plot with go.Sunburst

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let labels=["Eve"; "Cain"; "Seth"; "Enos"; "Noam"; "Abel"; "Awan"; "Enoch"; "Azura"]
let parents=[""; "Eve"; "Eve"; "Seth"; "Seth"; "Eve"; "Eve"; "Awan"; "Eve" ]
let values=[10.; 14.; 12.; 10.; 2.; 6.; 6.; 4.; 4.]

Chart.Sunburst(labels=labels, Values=values, parents=parents)
|> Chart.withLayout(Layout.init(Margin = Margin.init(Top = 0., Left = 0., Right = 0., Bottom = 0.)))
```

## Sunburst with Repeated Labels

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

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
|> Chart.withLayout(Layout.init(Margin = Margin.init(Top = 0., Left = 0., Right = 0., Bottom = 0.)))
```

## Branchvalues

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

let labels = [ "Eve"; "Cain"; "Seth"; "Enos"; "Noam"; "Abel"; "Awan"; "Enoch"; "Azura"]
let parents = ["";    "Eve";  "Eve";  "Seth"; "Seth"; "Eve";  "Eve";  "Awan";  "Eve" ]
let values = [  65.;  14.;  12.;  10.;  2.;  6.;  6.;  4.;  4.]

Chart.Sunburst(Values=values, labels=labels, parents=parents, Branchvalues = StyleParam.BranchValues.Total)
|> Chart.withLayout(Layout.init(Margin = Margin.init(Top = 0., Left = 0., Right = 0., Bottom = 0.)))
```

## Large Number of Slices

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data"
open Plotly.NET
open FSharp.Data

type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/sunburst-coffee-flavors-complete.csv">
type DFII = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/coffee-flavors.csv">
let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/sunburst-coffee-flavors-complete.csv")
let df2 = DFII.Load("https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/coffee-flavors.csv")




[
            (Chart.Sunburst(Ids=[for row in df1.Rows do row.Ids], labels=[for row in df1.Rows do row.Labels], parents=[for row in df1.Rows do row.Parents])
                |> GenericChart.mapTrace(fun x -> x.SetValue("domain", Domain.init(Row = 1, Column = 1)); x))
            (Chart.Sunburst(Ids=[for row in df2.Rows do row.Ids], labels=[for row in df2.Rows do row.Labels], parents=[for row in df2.Rows do row.Parents], Maxdepth = 2)
                |> GenericChart.mapTrace(fun x -> x.SetValue("domain", Domain.init(Row = 1, Column = 2)); x))
]
|> Chart.Combine
|> Chart.withLayout(Layout.init(Width = 1500., Margin = Margin.init(Top = 0., Left = 0., Right = 0., Bottom = 0.)))
|> Chart.withLayoutGrid(LayoutGrid.init(Rows = 1, Columns = 2))
```

## Controlling text orientation inside sunburst sectors

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/coffee-flavors.csv">
let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/coffee-flavors.csv")

Chart.Sunburst(Ids=[for row in df1.Rows do row.Ids], labels=[for row in df1.Rows do row.Labels], parents=[for row in df1.Rows do row.Parents], Maxdepth = 2)
|> GenericChart.mapTrace(fun x -> x.SetValue("insidetextorientation", "radial"); x)
|> Chart.withLayout(Layout.init(Margin = Margin.init(Top = 10., Left = 10., Right = 10., Bottom = 10.)))
```

## Controlling text fontsize with uniformtext

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET

type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/sunburst-coffee-flavors-complete.csv">
let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/718417069ead87650b90472464c7565dc8c2cb1c/sunburst-coffee-flavors-complete.csv")

let layout = 
    let tmp = Layout()
    tmp?uniformtext <- {| minsize = 10; mode = "hide" |}
    tmp

Chart.Sunburst(Ids=[for row in df1.Rows do row.Ids], labels=[for row in df1.Rows do row.Labels], parents=[for row in df1.Rows do row.Parents])
|> Chart.withLayout(layout)
```

## Sunburst chart with a continuous colorscale

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data"
open Plotly.NET
open FSharp.Data

type DFI = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/master/sales_success.csv">
let df1 = DFI.Load("https://raw.githubusercontent.com/plotly/datasets/master/sales_success.csv")
type Record = {region: string; county: string; salesperson: string; calls: int; sales: int}

let buildHierarchicalDataframe = 
    let ids = [ for row in df1.Rows do {region = row.Item2; county = row.Item3; salesperson = row.Item4; calls = row.Item5; sales = row.Item6} ]
    ids

let regions = [for x in df1.Rows do x.Item2, "total"] |> Set.ofList
let counties = [for x in df1.Rows do x.Item3, x.Item2] |> Set.ofList
let salesperson = [for x in df1.Rows do x.Item4, x.Item3] |> Set.ofList

let byRegion = [ for region in regions do fst region, snd region, List.sumBy (fun (x: Record) -> if x.region = fst region then x.calls else 0) buildHierarchicalDataframe]
let byCounties = [ for county in counties do fst county, snd county, List.sumBy (fun (x: Record) -> if x.county = fst county then x.calls else 0) buildHierarchicalDataframe]
let bySalesperson = [ for sp in salesperson do fst sp, snd sp, List.sumBy (fun (x: Record) -> if x.salesperson = fst sp then x.calls else 0) buildHierarchicalDataframe]
let data = List.append (List.append (List.append byRegion byCounties) bySalesperson)  ["total", "", List.sumBy (fun x -> x.calls) buildHierarchicalDataframe] |> Array.ofList
let ids = [for x, _, _ in data do x]
let parents = [for _, y, _ in data do y]
let values = [for _, _, z in data do z |> float]
[
    Chart.Sunburst(Ids = ids, labels = ids, parents = parents, Values = values, Branchvalues = StyleParam.BranchValues.Total)
    Chart.Sunburst(Ids = ids, labels = ids, parents = parents, Values = values, Branchvalues = StyleParam.BranchValues.Total, Maxdepth = 1)
]
|>Chart.Combine


```
