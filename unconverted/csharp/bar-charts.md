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
    description: How to make Bar Charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Bar Charts
    order: 3
    page_type: example_index
    permalink: fsharp/bar-charts/
    thumbnail: thumbnail/bar.jpg
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
open Plotly.NET

```

<!-- #region dotnet_interactive={"language": "fsharp"} -->
# Basic Bar Chart

you can use F# arrays to construct your bar charts
<!-- #endregion -->

```fsharp  dotnet_interactive={"language": "fsharp"}
let animals = ["giraffes"; "orangutans"; "monkeys"];
let sfValues = [20; 14; 23]
Chart.Column (animals, sfValues);

```

<!-- #region dotnet_interactive={"language": "fsharp"} -->
# Grouped Bar Chart

Chart.combine for grouping the charts
<!-- #endregion -->

```fsharp  dotnet_interactive={"language": "fsharp"}
let animals = ["giraffes"; "orangutans"; "monkeys"];
let sfValues = [20; 14; 23]
let laValues = [12; 18; 29]

[
    Chart.Column (animals, sfValues, Name="SF Zoo");
    Chart.Column (animals, laValues, Name="LA Zoo")
]
|> Chart.combine

```

# Stacked Bar Chart

Chart.StackedColumn for constructing stacked bars as shown below

```fsharp  dotnet_interactive={"language": "fsharp"}
let animals = ["giraffes"; "orangutans"; "monkeys"];
let sfValues = [20; 14; 23]
let laValues = [12; 18; 29]

[
    Chart.StackedColumn (animals, sfValues, Name="SF Zoo");
    Chart.StackedColumn (animals, laValues, Name="LA Zoo")
]
|> Chart.combine

```

# Bar Chart with Hover Text

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let products = ["Product A"; "Product B"; "Product C"];
let labels = ["27% market share"; "24% market share"; "19% market share"]
let sfValues = [20; 14; 23]

Chart.Column (
    products,
    sfValues,
    Labels=labels,
    Opacity=0.6
)
|> Chart.withMarker (
    Marker.init (
        Color=Color.fromString "rgb(158,202,225)", 
        Line=Line.init (Width=1.5, Color=Color.fromString "rgb(8,48,107)")
    )
)
|> Chart.withTitle ("January 2013 Sales Report")

```

# Bar Chart with Direct Labels

```fsharp  dotnet_interactive={"language": "fsharp"}
let products = ["Product A"; "Product B"; "Product C"];
let sfValues = [20; 14; 23]
Chart.Column (    products,
    sfValues,
    Labels= sfValues,
    TextPosition = StyleParam.TextPosition.Auto
) 

    

```

# Rotated Bar Chart Labels

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let months = ["Jan"; "Feb"; "Mar"; "Apr"; "May"; "Jun";
              "Jul"; "Aug"; "Sep"; "Oct"; "Nov"; "Dec"]
let primaryProduct = [20; 14; 25; 16; 18; 22; 19; 15; 12; 16; 14; 17]
let secondProduct = [19; 14; 22; 14; 16; 19; 15; 14; 10; 12; 12; 16]

[
    Chart.Column (months, primaryProduct, Name="Primary Product")
    |> Chart.withMarker (Marker.init (Color=Color.fromString "indianred"));

    Chart.Column (months, secondProduct, Name="Second Product")
    |> Chart.withMarker (Marker.init (Color=Color.fromString "lightSalmon"))
]
|> Chart.combine
|> Chart.withXAxis(LinearAxis.init(TickAngle= -45))

```

# Customizing Individual Bar Colors

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let featureKeys = ["Feature A"; "Feature B"; "Feature C";
                   "Feature D"; "Feature E"]
let featureValues = [20; 14; 23; 25; 22]

let colors = 
    [1..5]
    |> List.mapi (fun i x -> if i = 1 then Color.fromString "crimson" else Color.fromString "lightslategray" )
    |> List.toSeq

let marker = Marker.init(Colors = colors);
marker?color<-colors

Chart.Column (featureKeys, featureValues, Marker=marker)

```

# Customizing Individual Bar Widths

```fsharp  dotnet_interactive={"language": "fsharp"}
let featureKeys = [1.; 2.; 3.; 5.5; 10.]
let featureValues = [10; 8; 6; 4; 2]
let width = [0.8; 0.8; 0.8; 3.5; 4.]
Chart.Column (featureKeys, 
              featureValues)
|> Chart.withMarker(Marker.init(MultiSizes= width))

//|> Chart.withLineStyle(Width = width) Doesnt accept float list

|> GenericChart.mapTrace(fun t-> 
                                t?width<-width;
                                t)  // workaround


```

Bar charts with custom widths can be used to make mekko charts (also known as marimekko charts, mosaic plots, or variwide charts).

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let labels = [|"apples"; "oranges"; "pears"; "bananas"|]
let widths = [|10.; 20.; 20.; 50.|]

let data = 
   new Map<string,float[]>([
        "South", [|50.;80.;60.;70.|]
        "North", [|50.; 20.;40.;30.|]]
   )

let cumSum x=
   (Array.scan (+) 0. x).[1..]

let tickVals = Array.map2 (fun x y-> x-y/2.) (cumSum(widths)) widths
let ticks = Array.map2 (fun l w -> $"{l} <br> {w}") labels widths
let textLabels key= Array.map2 (fun h w -> $"{h} x {w} = <br>"+ string (h*w))  data.[key] widths

[ 
   for kvp in data ->               
               let keys = Array.map2 (fun x y-> x-y) (cumSum(widths)) widths
               Chart.Column(values=kvp.Value,keys=keys,Marker=Marker.init(Line=Line.init(Color= Color.fromString "white",Width=0.5)),Labels=textLabels kvp.Key)
               |> GenericChart.mapTrace(fun t-> 
                                                
                                                t.SetValue("width", widths)
                                                t.SetValue("offset", 0.)
                                                t.SetValue("name", kvp.Key)
                                                t.SetValue("textangle", 0)
                                                t.SetValue("textposition", "inside")
                                                t)  // workaround 
]
|> Chart.combine
|> Chart.withLayout(Layout.init(BarMode=StyleParam.BarMode.Stack))
|> Chart.withXAxis(LinearAxis.init(TickVals=tickVals,TickText=ticks,ShowGrid=true))



```

# Customizing Individual Bar Base

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let years = [ "2016"; "2017"; "2018" ]

[
    Chart.Column(years, [500; 600; 700], Name="expenses", Marker=Marker.init(Color=Color.fromString "crimson"))
        |> GenericChart.mapTrace(fun t-> 
                        t.SetValue("base",[-500;-600;-700])// workaround
                        t) 

    ;Chart.Column(years, [300; 400; 700], Name="revenue", Marker=Marker.init(Color=Color.fromString "lightslategrey"))
         |> GenericChart.mapTrace(fun t-> 
                            t.SetValue("base",0)
                            t)  // workaround
]
|> Chart.combine
```

# Bar Chart with Relative Barmode


With "relative" barmode, the bars are stacked on top of one another, with negative values below the axis, positive values above.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [1; 2; 3; 4]

[
    Chart.Column(keys=x, values= [1.; 4.; 9.; 16.])
    Chart.Column(keys=x, values= [6.; -8.; -4.5; 8.])
    Chart.Column(keys=x, values= [-15.; -3.; 4.5; -8.])
    Chart.Column(keys=x, values= [-1.; 3.; -3.; -4.])
]
|> Chart.combine
|> Chart.withLayout(Layout.init(BarMode=StyleParam.BarMode.Relative,Title=Title.init("Relative BarMode")))
```

# Bar Chart with Sorted or Ordered Categories


Set CategoryOrder to CategoryOrder.CategoryAscending or CategoryDescending for the alphanumerical order of the category names or TotalAscending or TotalDescending for numerical order of values. CategoryOrder for more information. Note that sorting the bars by a particular trace isn"t possible right now - it"s only possible to sort by the total values. Of course, you can always sort your data before plotting it if you need more customization.

This example orders the bar chart alphabetically with CategoryOrder= StyleParam.CategoryOrder.CategoryAscending

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
|> Chart.withXAxis(LinearAxis.init(CategoryOrder=StyleParam.CategoryOrder.CategoryAscending))
```

This example shows how to customise sort ordering by defining CategoryOrder to StyleParam.CategoryOrder.Array to derive the ordering from the attribute CategoryArray.

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

This example orders the bar chart by descending value with CategoryOrder=StyleParam.CategoryOrder.TotalDescending

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
|> Chart.withXAxis(LinearAxis.init(CategoryOrder=StyleParam.CategoryOrder.TotalDescending))
```

# Horizontal Bar Charts

See examples of horizontal bar charts here.

# Bar Charts With Multicategory Axis Type

If your plots have arrays for x or y, then the axis type is automatically inferred to be multicategory.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x :Object list = [["BB+"; "BB+"; "BB+"; "BB"; "BB"; "BB"];[16; 17; 18; 16; 17; 18;]]

[
    Chart.Column(keys=[], values = [1;2;3;4;5;6])
    Chart.Column(keys=[], values = [6;5;4;3;2;1])
] 
|> Chart.combine 
// |> Chart.withX_Axis(Axis.LinearAxis.init(Tickvals = ["BB+"; "BB+"; "BB+"; "BB"; "BB"; "BB"]))
|> GenericChart.mapTrace(fun t-> 
                                t?x<-x // workaround
                                t) 
|> Chart.withLayout( Layout.init(BarMode = StyleParam.BarMode.Stack))
```
