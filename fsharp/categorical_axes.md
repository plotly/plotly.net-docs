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
    description: How to make categorical charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Categorical Axes
    order: 16
    page_type: u-guide
    permalink: fsharp/categorical-axes/
    thumbnail: thumbnail/bar.jpg
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"

```

This page shows examples of how to configure 2-dimensional Cartesian axes to visualize categorical (i.e. qualitative, nominal or ordinal data as opposed to continuous numerical data). Such axes are a natural fit for bar charts, waterfall charts, funnel charts, heatmaps, violin charts and box plots, but can also be used with scatter plots and line charts. Configuring gridlines, ticks, tick labels and axis titles on logarithmic axes is done the same was as with linear axes.


# 2-D Cartesian Axis Type and Auto-Detection

The different types of Cartesian axes are configured via the LinearAxis.AxisType attribute, which can take on the following values:

'Linear' (see the linear axes tutorial)
'Log' (see the log plot tutorial)
'Date' (see the tutorial on timeseries)
'Category' see below
'MultiCategory' see below
The axis type is auto-detected by looking at data from the first trace linked to this axis:

First check for MultiCategory, then date, then category, else default to linear (log is never automatically selected)
MultiCategory is just a shape test: is the array nested?
date and category: require more than twice as many distinct date or category strings as distinct numbers in order to choose that axis type.
Both of these test an evenly-spaced sample of at most 1000 values


# Forcing an axis to be categorical

It is possible to force the axis type by setting explicitly AxisType. In the example below the automatic X axis type would be linear (because there are not more than twice as many unique strings as unique numbers) but we force it to be category.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects


let x = [|"a"; "a"; "b"; "c"|]
let y = [|1;2;3;4|]
let xy = Array.zip x y
Chart.Bar(xy)
|> Chart.withYAxis(LinearAxis.init(AxisType=StyleParam.AxisType.Category))

```

Box plots and violin plots are often shown with one categorical and one continuous axis.

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Deedle"
#r "nuget: FSharp.Data"
```

```fsharp  dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/tips.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")
    

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let x = getColumnData "sex" |> Seq.cast<string>
let y = getColumnData "total_bill" |> Seq.cast<decimal>


Chart.BoxPlot(x,y,Jitter=0.1,Boxpoints=StyleParam.Boxpoints.All)
```

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

Chart.Violin(x=x,y=y)
```

# Automatically Sorting Categories by Name or Total Value

Categories can be sorted alphabetically or by value using the CategoryOrder attribute for Axis:

Set CategoryOrder to "StyleParam.CategoryOrder.CategoryAscending" or "StyleParam.CategoryOrder.CategoryDecending" for the alphanumerical order of the category names or "TotalAscending" or "TotalDescending" for numerical order of values. CategoryOrder for more information. Note that sorting the bars by a particular trace isn't possible right now - it's only possible to sort by the total values. Of course, you can always sort your data before plotting it if you need more customization.

This example orders the categories alphabetically with CategoryOrder: 'CategoryAscending'

```fsharp  dotnet_interactive={"language": "fsharp"}

open Plotly.NET
open Plotly.NET.LayoutObjects

let x = ['b'; 'a'; 'c'; 'd']

[
    Chart.Column(x, [2.;5.;1.;9.], Name = "Montreal")
    Chart.Column(x, [1.;4.;9.;16.], Name = "Ottawa")
    Chart.Column(x, [6.;8.;4.5;8.], Name = "Toronto")
]
|> Chart.combine
|> Chart.withLayout(Layout.init(BarMode=StyleParam.BarMode.Stack))
|> Chart.withXAxis(LinearAxis.init(CategoryOrder=StyleParam.CategoryOrder.CategoryAscending))
```

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

[
    Chart.Column(x, [2.;5.;1.;9.], Name = "Montreal")
    Chart.Column(x, [1.;4.;9.;16.], Name = "Ottawa")
    Chart.Column(x, [6.;8.;4.5;8.], Name = "Toronto")
]
|> Chart.combine
|> Chart.withXAxis(LinearAxis.init(CategoryOrder=StyleParam.CategoryOrder.TotalAscending))
```

This example shows how to control category order by defining CategoryOrder to "Array" to derive the ordering from the attribute CategoryArray.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

[
    Chart.Column(x, [2.;5.;1.;9.], Name = "Montreal")
    Chart.Column(x, [1.;4.;9.;16.], Name = "Ottawa")
    Chart.Column(x, [6.;8.;4.5;8.], Name = "Toronto")
]
|> Chart.combine
|> Chart.withLayout(Layout.init(BarMode=StyleParam.BarMode.Stack))
|> Chart.withXAxis(LinearAxis.init(CategoryOrder=StyleParam.CategoryOrder.Array,CategoryArray=['d';'a';'c';'b']))
```

# Gridlines, Ticks and Tick Labels

By default, gridlines and ticks are not shown on categorical axes but they can be activated:

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = ['b'; 'a'; 'c'; 'd']

Chart.Column(["A";"B";"C"], [1;3;2])
|> Chart.withXAxis(LinearAxis.init(ShowGrid = true, Ticks = StyleParam.TickOptions.Outside))
```

# Multi-categorical Axes

A two-level categorical axis (also known as grouped or hierarchical categories, or sub-categories) can be created by specifying a trace's x or y property as a 2-dimensional lists. The first sublist represents the outer categorical value while the second sublist represents the inner categorical value. 

Passing in a two-dimensional list as the x or y value of a trace causes the type of the corresponding axis to be set to multicategory.

Here is an example that creates a figure with a 2-level categorical x-axis.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let trace x y name =  //Workaround
    let tmp = Trace("bar")
    tmp?x <- x
    tmp?y <- y
    tmp?name <- name
    tmp
[
    GenericChart.ofTraceObject(trace [["First"; "First";"Second";"Second"];["A"; "B"; "A"; "B"]] [2;3;1;5] "Adults")
    GenericChart.ofTraceObject(trace [["First"; "First";"Second";"Second"];["A"; "B"; "A"; "B"]] [8;3;6;5] "Children")        
]
|> Chart.combine
|> Chart.withLayout(Layout.init(Title = Title.init("Multi-category axis"), Width = 700))

```
