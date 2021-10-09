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
    description: How to make Pie charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Pie Charts
    order: 4
    page_type: u-guide
    permalink: fsharp/pie-charts/
    thumbnail: thumbnail/pie-chart.jpg
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
```

A pie chart is a circular statistical chart, which is divided into sectors to illustrate numerical proportion.

If you're looking instead for a multilevel hierarchical pie-like chart, go to the Sunburst tutorial.


# Basic Pie Chart

In Chart.Pie, data visualized by the sectors of the pie is set in values. The sector labels are set in labels. The sector colors are set in SectionColors.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500; 2500; 1053; 500]

Chart.Pie(Labels=labels, values=values)
```

# Styled Pie Chart

Colors can be given as RGB triplets or hexadecimal strings, or with CSS color names as below.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects

let colors = ["gold"; "mediumturquoise"; "darkorange"; "lightgreen"] |> Seq.map (fun c -> Color.fromString c)
let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500; 2500; 1053; 500]


let marker = Marker.init(Line=Line.init(Color=Color.fromString "black",Width=2.))
Chart.Pie(Labels=labels, values=values,SectionColors = colors)
|> GenericChart.mapTrace (TraceDomainStyle.Pie(HoverInfo= "label+percent",TextInfo=StyleParam.TextInfo.Value,TextFont=Font.init(Size=20.),Marker=marker))
```

# Controlling text orientation inside pie sectors

The InsideTextOrientation attribute controls the orientation of text inside sectors. With "Auto" the texts may automatically be rotated to fit with the maximum size inside the slice. Using "Horizontal" (resp. "Radial", "Tangential") forces text to be horizontal (resp. radial or tangential)

Example below shows how to change Inside text orientation

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET


let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500; 2500; 1053; 500]

Chart.Pie(Labels=labels, values=values)
|> GenericChart.mapTrace (TraceDomainStyle.Pie(InsideTextOrientation=StyleParam.InsideTextOrientation.Radial))
```

# Donut Chart

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500; 2500; 1053; 500]

let colors = ["gold"; "mediumturquoise"; "darkorange"; "lightgreen"] |> Seq.map (fun c -> Color.fromString c)
Chart.Doughnut(Labels=labels, values=values, Hole=0.3,SectionColors=colors)
```

# Pulling sectors out from the center

For a "pulled-out" or "exploded" layout of the pie chart, use the pull argument. 

```fsharp  dotnet_interactive={"language": "fsharp"}

open Plotly.NET

let labels = ["Oxygen"; "Hydrogen"; "Carbon_Dioxide"; "Nitrogen"]
let values = [4500.; 2500.; 1053.; 500.]

Chart.Doughnut(Labels=labels, values=values)
|> GenericChart.mapTrace(fun t -> t?pull <- [0.;0.;0.2;0.];t) //Workaround
```

# Pie Charts in subplots

Domain=Domain.init(Row=0,Column=0) or Domain.init(X=StyleParam.Range.MinMax(0.,0.5),Y=StyleParam.Range.MinMax(0.5,1.)) & Chart.withLayoutGrid() can be set configure sub plots for multiple pie charts


```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let labels = ["US"; "China"; "European Union"; "Russian Federation"; "Brazil"; "India"; "Rest of the World"]

let CHG = Chart.Pie(Name="CHG Emissions",Labels=labels,values=[16; 15; 12; 6; 5; 4; 42])
            |> GenericChart.mapTrace(TraceDomainStyle.Pie(Domain=Domain.init(Row=0,Column=0),HoverInfo="label+percent+name",Hole=0.4))
            
let CO2 = Chart.Pie(Name="CO2 Emissions",Labels=labels,values=[27; 11; 25; 8; 1; 3; 25])
            |> GenericChart.mapTrace(TraceDomainStyle.Pie(Domain=Domain.init(Row=0,Column=1),HoverInfo="label+percent+name",Hole=0.4))

let CHGAnnotation = Annotation.init(X= 0.20,Y = 0.5,ShowArrow=false,Text="CHG",Font=Font.init(Size=20.))
let CO2Annotation = Annotation.init(X= 0.80,Y = 0.5,ShowArrow=false,Text="CO2",Font=Font.init(Size=20.))

[CHG;CO2] 
|> Chart.combine
|> Chart.withLayoutGrid(LayoutGrid.init(Rows=1,Columns=2))
|> Chart.withAnnotations([CHGAnnotation;CO2Annotation])
|> Chart.withTitle("Global Emissions 1990-2011")

```

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let labels = ["1st"; "2nd"; "3rd"; "4th"; "5th"]
let nightColors = ["rgb(56, 75, 126)"; "rgb(18, 36, 37)"; "rgb(34, 53, 101)"; "rgb(36, 55, 57)"; "rgb(6, 4, 4)"] |> Seq.map (fun c -> Color.fromString c)
let sunflowersColors = ["rgb(177; 127; 38)"; "rgb(205; 152; 36)"; "rgb(99; 79; 37)"; "rgb(129; 180; 179)"; "rgb(124; 103; 37)"] |> Seq.map (fun c -> Color.fromString c)
let irisesColors = ["rgb(33; 75; 99)"; "rgb(79; 129; 102)"; "rgb(151; 179; 100)";"rgb(175; 49; 35)"; "rgb(36; 73; 147)"] |> Seq.map (fun c -> Color.fromString c)
let cafeColors =  ["rgb(146; 123; 21)"; "rgb(177; 180; 34)"; "rgb(206; 206; 40)"; "rgb(175; 51; 21)"; "rgb(35; 36; 21)"] |> Seq.map (fun c -> Color.fromString c)

let starryNight = Chart.Pie(Name="Starry Night",Labels=labels,values=[38; 27; 18; 10; 7],SectionColors=nightColors)
                    |> GenericChart.mapTrace(TraceDomainStyle.Pie(Domain=Domain.init(X=StyleParam.Range.MinMax(0.,0.5),Y=StyleParam.Range.MinMax(0.5,1.)),HoverInfo="label+percent+name",TextInfo=StyleParam.TextInfo.None))

let sunflowers = Chart.Pie(Name="Sunflowers",Labels=labels,values=[28; 26; 21; 15; 10],SectionColors=sunflowersColors)
                    |> GenericChart.mapTrace(TraceDomainStyle.Pie(Domain=Domain.init(X=StyleParam.Range.MinMax(0.5,1.),Y=StyleParam.Range.MinMax(0.5,1.)),HoverInfo="label+percent+name",TextInfo=StyleParam.TextInfo.None))

let irises = Chart.Pie(Name="Irises",Labels=labels,values=[38; 19; 16; 14; 13],SectionColors=irisesColors)
                    |> GenericChart.mapTrace(TraceDomainStyle.Pie(Domain=Domain.init(X=StyleParam.Range.MinMax(0.,0.5),Y=StyleParam.Range.MinMax(0.0,0.5)),HoverInfo="label+percent+name",TextInfo=StyleParam.TextInfo.None))

let nightCafe = Chart.Pie(Name="The Night Cafe",Labels=labels,values=[31; 24; 19; 18; 8],SectionColors=cafeColors)
                    |> GenericChart.mapTrace(TraceDomainStyle.Pie(Domain=Domain.init(X=StyleParam.Range.MinMax(0.5,1.0),Y=StyleParam.Range.MinMax(0.0,0.5)),HoverInfo="label+percent+name",TextInfo=StyleParam.TextInfo.None))
    
[starryNight;sunflowers;irises;nightCafe] 
|> Chart.combine
|> Chart.withLayoutGrid(LayoutGrid.init(Rows=2,Columns=2))
|> Chart.withTitle("Van Gogh: 5 Most Prominent Colors Shown Proportionally")
```

# Plot chart with area proportional to total count

ScaleGroup property can be set to scale pie charts according to the area

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let labels = ["Asia"; "Europe"; "Africa"; "Americas"; "Oceania"]

let gdp1980 = Chart.Pie(Name="World GDP 1980",Labels=labels,values=[4.;7.;1.;7.;0.5])
            |> GenericChart.mapTrace(TraceDomainStyle.Pie(Domain=Domain.init(Row=0,Column=0),HoverInfo="label+percent+name",ScaleGroup="one"))
            
let gdp2007 = Chart.Pie(Name="World GDP 2007",Labels=labels,values=[21.;15.;3.;19.;1.])
            |> GenericChart.mapTrace(TraceDomainStyle.Pie(Domain=Domain.init(Row=0,Column=1),HoverInfo="label+percent+name",ScaleGroup="one"))

[gdp1980;gdp2007] 
|> Chart.combine
|> Chart.withLayoutGrid(LayoutGrid.init(Rows=1,Columns=2))
|> Chart.withTitle("World GDP")
```

# Sunburst charts

For multilevel pie charts representing hierarchical data, you can use the Sunburst chart. A simple example is given below, for more information see the tutorial on Sunburst charts.

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let labels = ["Eve"; "Cain"; "Seth"; "Enos"; "Noam"; "Abel"; "Awan"; "Enoch"; "Azura"]
let parents = [""; "Eve"; "Eve"; "Seth"; "Seth"; "Eve"; "Eve"; "Awan"; "Eve"]
let values = [10.;14.;12.;10.;2.;6.;6.;4.;4.]

Chart.Sunburst(labels = labels, parents = parents, Values = values)
|> Chart.withMarginSize(0)
```
