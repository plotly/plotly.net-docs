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
    description: How to use hover text and formatting in F# with Plotly.
    display_as: file_settings
    language: fsharp
    layout: base
    name: Hover Text and Formatting
    order: 22
    page_type: example_index
    permalink: fsharp/hover-text-and-formatting/
    thumbnail: thumbnail/hover-text.png
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Newtonsoft.Json, 12.0.3"
#r "nuget: Plotly.NET,  2.0.0-preview.9"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.9"
#r "nuget: FSharp.Data"
```

# Hover Labels

One of the most deceptively-powerful features of interactive visualization using Plotly.NET is the ability for the user to reveal more information about a data point by moving their mouse cursor over the point and having a hover label appear.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [for i in 0..10 -> i]
let y = [for i in x -> i*2]
let labels = [for i in x -> "Text "+ string i]

Chart.Point(x,y,Labels=labels)
```

# Customizing Hover Mode

There are three hover modes available in Plotly.NET. The default setting is Layout.HoverMode='Closest', wherein a single hover label appears for the point directly underneath the cursor.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let x = [for i in 0..10 -> i]
let y1 = [for i in x -> 2.0*Math.Cos(float i)]
let y2 = [for i in x -> 5.0*Math.Sin(float i)]

let labels = [for i in x -> "Text "+ string i]

[
Chart.Line(x,y1,Labels=labels,ShowMarkers=true);
Chart.Line(x,y2,Labels=labels,ShowMarkers=true);
]
|> Chart.combine
|> Chart.withLayout(Layout.init(HoverMode=StyleParam.HoverMode.Closest))
```

# HoverMode X or Y

If Layout.HoverMode='X' (or 'Y'), a single hover label appears per trace, for points at the same x (or y) value as the cursor. 
If multiple points in a given trace exist at the same coordinate, only one will get a hover label. In the line plot below we have forced markers to appear, to make it clearer what can be hovered over:

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data

let csv = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv")

let Oceania = Seq.filter (fun (row:CsvRow) -> row.GetColumn("continent") = "Oceania") csv.Rows
                |> Seq.groupBy (fun c -> c.GetColumn("country"))

[for country,countryDetails in Oceania -> 
                let x = countryDetails |> Seq.map (fun x -> x.GetColumn("year"))
                let y = countryDetails |> Seq.map (fun x -> x.GetColumn("lifeExp"))
                
                Chart.Line(x,y,Name=country,ShowMarkers=true)]
|> Chart.combine
|> Chart.withLayout(Layout.init(HoverMode=StyleParam.HoverMode.X))
|> Chart.withTitle("LayoutMode.HoverMode='X'")
```

# HoverMode = XUnified (Will Be Implemented)


# Customizing Hover Label Appearance

Hover Label color and font can be set through Layout.HoverLabel attribute as shown below

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET.LayoutObjects

let csv = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv")

let Oceania = Seq.filter (fun (row:CsvRow) -> row.GetColumn("continent") = "Oceania") csv.Rows
                |> Seq.groupBy (fun c -> c.GetColumn("country"))


let hoverLabel = Hoverlabel.init(BgColor=Color.fromString "white",
                                    Font=Font.init(Size=16.,Family=StyleParam.FontFamily.Custom "Rockwell"))

[for country,countryDetails in Oceania -> 
                let x = countryDetails |> Seq.map (fun x -> x.GetColumn("year"))
                let y = countryDetails |> Seq.map (fun x -> x.GetColumn("lifeExp"))
                
                Chart.Line(x,y,Name=country,ShowMarkers=true)]
|> Chart.combine
|> Chart.withLayout(Layout.init(Hoverlabel=hoverLabel))
|> Chart.withTitle("LayoutMode.HoverMode='X'")
```

# Customizing hover text with a HoverTemplate

To customize the tooltip on your graph you can use the HoverTemplate attribute of corresponding TraceStyle (i.e Trace2DStyle,TraceDomainStyle etc), which is a template string used for rendering the information that appear on hoverbox. This template string can include variables in %{variable} format, numbers in d3-format's syntax, and date in d3-time-format's syntax. In the example below, the empty <extra></extra> tag removes the part of the hover where the trace name is usually displayed in a contrasting color. The <extra> tag can be used to display other parts of the hovertemplate, it is not reserved for the trace name.

Note that a HoverTemplate customizes the tooltip text, while a TextTemplate customizes the text that appears on your chart.

Set the horizontal alignment of the text within tooltip with Hoverlabel.Align.

```fsharp dotnet_interactive={"language": "fsharp"}
let hoverLabel = Hoverlabel.init(BgColor=Color.fromString "white",
                                   Align=StyleParam.Align.Right)

let hoverTemplate = "<i>Price</i>: $%{y:.2f}"+
                    "<br><b>X</b>: %{x}<br>"+
                    "<b>%{text}</b>";

let text = [for i in 1..5 -> $"Custom text {i+1}"] 

let chart1 = Chart.Line(x=[1..5],
                        y = [2.02825;1.63728;6.83839;4.8485;4.73463],
                        ShowMarkers=true, ShowLegend=false)
                
                |> GenericChart.mapTrace (Trace2DStyle.Scatter(HoverTemplate=hoverTemplate,MultiText=text))

let chart2 = Chart.Line(x=[1..5],
                        y = [3.02825;2.63728;4.83839;3.8485;1.73463],
                        ShowMarkers=true, ShowLegend=false)
                
                |> GenericChart.mapTrace (Trace2DStyle.Scatter(HoverTemplate="Price: %{y:$.2f}<extra></extra>"))

[chart1;chart2]
|> Chart.combine
|> Chart.withLayout(Layout.init(Hoverlabel=hoverLabel))
|> Chart.withTitle("Set hover text with HoverTemplate")
```

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

Chart.Pie(values=[2.; 5.; 3.; 2.5],Name="",
            Labels = ["R"; "Python"; "Java Script"; "Matlab"])
    |> GenericChart.mapTrace(TraceDomainStyle.Pie(Text=["TextA"; "TextB"; "TextC"; "TextD"],
                                                    HoverTemplate="%{label}: <br>Popularity: %{percent} </br> %{text}"))
```

# Hover Templates with Mixtures of Period data

When displaying periodic data with mixed-sized periods (i.e. quarterly and monthly) in conjunction with x or x unified hovermodes and using hovertemplate, the XHoverFormat attribute can be used to control how each period's X value is displayed, and the special %{xother} hover-template directive can be used to control how the X value is displayed for points that do not share the exact X coordinate with the point that is being hovered on. %{xother} will return an empty string when the X value is the one being hovered on, otherwise it will return (%{x}). The special %{_xother}, %{xother_} and %{_xother_} variations will display with spaces before, after or around the parentheses, respectively.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET.LayoutObjects

let chart1 = Chart.Column([1000; 1500; 1700],["2020-01-01"; "2020-04-01"; "2020-07-01"])
                |> GenericChart.mapTrace(Trace2DStyle.Bar(XPeriod="M3",
                                            XPeriodAlignment=StyleParam.PeriodAlignment.Middle,
                                            XHoverFormat="Q%q",
                                            HoverTemplate = "%{y}%{_xother}"))
                                            
let x=["2020-01-01"; "2020-02-01"; "2020-03-01";
                            "2020-04-01"; "2020-05-01"; "2020-06-01";
                            "2020-07-01"; "2020-08-01"; "2020-09-01"]
let y=[1100;1050;1200;1300;1400;1700;1500;1400;1600]

let chart2 =Chart.Line(x=x,y=y,ShowMarkers=true)
                |> GenericChart.mapTrace(Trace2DStyle.Scatter(XPeriod="M1",
                                            XPeriodAlignment=StyleParam.PeriodAlignment.Middle,
                                            XHoverFormat="Q%q",
                                            HoverTemplate = "%{y}%{_xother}"))

let layout = //Workaround
    let tmp  = new Layout()
    tmp?hovermode <- "x unified"
    tmp

[chart1;chart2]
|>  Chart.combine
|>  Chart.withLayout(layout)

```

# Advanced Hover Template

The following example shows how to format a hover template.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects   

let csv = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv")

let continentNames = ["Africa"; "Americas";"Asia"; "Europe"; "Oceania"]

let contientGrouping = csv.Rows |> Seq.groupBy (fun row -> row.GetColumn("continent")) 

let hoverTemplate = "<b>%{text}</b><br><br>" +
                        "GDP per Capita: %{x:$,.0f}<br>" +
                        "Life Expectation: %{y:.0%}<br>" +
                        "Population: %{marker.size:,}" +
                        "<extra></extra>"

let rand = new Random()

[for continent,countryList in contientGrouping -> 
                                                    let x = [for (row:CsvRow) in countryList -> row.GetColumn("gdpPercap")]
                                                    let y = [for (row:CsvRow) in countryList -> row.GetColumn("lifeExp")]
                                                    let size = [for (row:CsvRow) in countryList -> int <| rand.NextDouble()*300. ]
                                                    let text = countryList |> Seq.map (fun c -> c.GetColumn("continent"))
                                                    Chart.Scatter(x,y,StyleParam.Mode.Markers,Name=continent)                                                    
                                                    |> Chart.withMarkerStyle(MultiSize=size,SizeMode=StyleParam.MarkerSizeMode.Area,SizeRef=10)
                                                    |> GenericChart.mapTrace(Trace2DStyle.Scatter(HoverTemplate=hoverTemplate,MultiText=text))]

|> Chart.combine
|> Chart.withXAxis(LinearAxis.init(AxisType=StyleParam.AxisType.Log))       
```

# Adding other data to the hover with CustomData and a HoverTemplate

You can then use CustomData inside a HoverTemplate to display the value of CustomData.

```fsharp dotnet_interactive={"language": "fsharp"}
open System

let rand = new Random()
let hoverTemplate ="<b>y:%{y:.3f}</b><br> custom:%{customdata:.3f}}"

let customdata = [|for i in 1..5 -> rand.NextDouble()|]

Chart.Line(x=[1..5],
            y = [2.02825;1.63728;6.83839;4.8485;4.73463],
            ShowMarkers=true, ShowLegend=false)
                
|> GenericChart.mapTrace (Trace2DStyle.Scatter(HoverTemplate=hoverTemplate,CustomData=customdata))

```

# Setting the Hover Template in Mapbox Maps (Missing Abstraction)

```fsharp dotnet_interactive={"language": "fsharp"}
// let cityNames = [
//         "Montreal"; "Toronto"; "Vancouver"; "Calgary"; "Edmonton";
//         "Ottawa"; "Halifax"; "Victoria"; "Winnepeg"; "Regina"
//     ]
// let hoverTemplate = "<b>%{marker.symbol} </b><br><br>" +
//                     "longitude: %{lon}<br>" +
//                     "latitude: %{lat}<br>"  

// Chart.ScatterMapbox(longitudes=[-75; -80; -50],
//                     latitudes=[45; 20; -20],
//                     mode=StyleParam.Mode.Lines_Markers_Text)
// |> Chart.withMarker(Marker.init(Size=20))
// |> GenericChart.mapTrace (TraceMapboxStyle.ScatterMapbox())
// |> Chart.withMapbox(
//     Mapbox.init(Style=StyleParam.MapboxStyle.OpenStreetMap,
//                 Zoom=1.,
//                 Center=(-84.6,30.45)
//     )
// )
```

# Spike lines

Plotly.NET supports "spike lines" which link a point to the axis on hover, and can be configured per axis.

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data

let csv = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv")

let Oceania = Seq.filter (fun (row:CsvRow) -> row.GetColumn("continent") = "Oceania") csv.Rows
                |> Seq.groupBy (fun c -> c.GetColumn("country"))

[for country,countryDetails in Oceania -> 
                let x = countryDetails |> Seq.map (fun x -> x.GetColumn("year"))
                let y = countryDetails |> Seq.map (fun x -> x.GetColumn("lifeExp"))
                
                Chart.Line(x,y,Name=country,ShowMarkers=true)]
|> Chart.combine
|> Chart.withXAxis(LinearAxis.init(ShowSpikes=true))
|> Chart.withYAxis(LinearAxis.init(ShowSpikes=true))
|> Chart.withTitle("Spike lines active")
```
