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
  language_info:
    codemirror_mode:
      name: ipython
      version: 3
    file_extension: .fs
    mimetype: text/x-csharp
    name: C#
    nbconvert_exporter: csharp
    pygments_lexer: csharp
    version: 5.0
  plotly:
    description: Creating and Updating Figures in C# with Plotly.
    display_as: file_settings
    language: csharp
    layout: base
    name: Creating and Updating Figures
    order: 2
    page_type: u-guide
    permalink: csharp/creating-and-updating-figures/
    thumbnail: thumbnail/creating-and-updating-figures.png
---

```csharp dotnet_interactive={"language": "csharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
#r "nuget: Deedle"
#r "nuget: FSharp.Data"
```

The plotly.NET package exists to create, manipulate and render graphical figures (i.e. charts, plots, maps and diagrams) represented by data structures also referred to as figures. The rendering process uses the Plotly.js JavaScript library under the hood although .NET developers using this module very rarely need to interact with the Javascript library directly, if ever. Figures can be represented as 'DynamicObj' an extension of `DynamicObject` which makes it possible to set arbitraryly named and typed properties of these objects via the `?` operator, and are serialized as text in JavaScript Object Notation (JSON) before being passed to Plotly.js.


# Creating Figures using DynamicObject

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using Plotly.NET.LayoutObjects;
using Microsoft.csharp.Core;
using Microsoft.csharp.Collections;

LinearAxis xAxis = new LinearAxis();
xAxis.SetValue("title", "xAxis");
xAxis.SetValue("zerolinecolor", "#ffff");
xAxis.SetValue("gridcolor", "#ffff");
xAxis.SetValue("showline", true);
xAxis.SetValue("zerolinewidth",2);

LinearAxis yAxis = new LinearAxis();
yAxis.SetValue("title", "yAxis");
yAxis.SetValue("zerolinecolor", "#ffff");
yAxis.SetValue("gridcolor", "#ffff");
yAxis.SetValue("showline", true);
yAxis.SetValue("zerolinewidth",2);

Layout layout = new Layout();
layout.SetValue("xaxis", xAxis);
layout.SetValue("yaxis", yAxis);
layout.SetValue("title", "A Figure Specified by DynamicObj");
layout.SetValue("plot_bgcolor", "#e5ecf6");
layout.SetValue("showlegend", true);

Trace trace = new Trace("bar");
trace.SetValue("x", new []{1,2,3});
trace.SetValue("y", new []{1,3,2});


var fig = GenericChart.Figure.create(ListModule.OfSeq(new []{trace}),layout);
GenericChart.fromFigure(fig)
```

# Figures as GenericChart Objects

Plotly.NET is a .NET wrapper for creation of `plotly charts`() written in C#. This means that, under the hood, all functionality creates JSON objects that can be rendered by plotly.
The central type that gets created by all Chart constructors is `GenericChart`, which itself represents either a single chart or a multi chart (as a Discriminate Union type). Plotly.NET has multiple abstraction layers to work with `GenericChart`s.

Chart type provides an C# convience layer that abstracts dynamic object creation. Chart type covers all the plot types(i.e Scatter,Line,3D, Heatmap etc).
The main benefit of creating charts using Chart type is; It provides strongly typed access to all the properties of Plotly figure 

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using Plotly.NET.TraceObjects;
using Plotly.NET.LayoutObjects;

var xAxis = LinearAxis.init<IConvertible, IConvertible, IConvertible, IConvertible, IConvertible, IConvertible>(
                Title:Title.init("xAxis"),
                ZeroLineColor:Color.fromString("#ffff"),
                GridColor:Color.fromString("#ffff"),
                ZeroLineWidth:2);

var yAxis = LinearAxis.init<IConvertible, IConvertible, IConvertible, IConvertible, IConvertible, IConvertible>(
                Title:Title.init("yAxis"),
                ZeroLineColor:Color.fromString("#ffff"),
                GridColor:Color.fromString("#ffff"),
                ZeroLineWidth:2);

var layout = Layout.init<IConvertible>(Title:Title.init("A Plotly.NET Chart"),PlotBGColor : Color.fromString("#e5ecf6"));

Chart2D.Chart.Column<int,int,int>(keys:new []{1,2,3},values:new []{1,3,2})
    .WithXAxis(xAxis)
    .WithYAxis(yAxis)
    .WithLayout(layout)
```

# Creating Figures/Charts

This section summarizes several ways to create new Plotly figures with the Plotly.NET.


## Scatter Plot

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using System.Net;
using csharp.Data;

var title = Title.init (Text : "A Plotly Figure");
var csv = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/iris.csv");

IEnumerable<string> GetData(string column) => csv.Rows.Select(row => row.GetColumn(column));

var X = Array.ConvertAll(GetData("SepalWidth").ToArray(),Single.Parse);
var Y = Array.ConvertAll(GetData("SepalLength").ToArray(),Single.Parse);
var Colors = GetData("Name")
                .Select(name => 
                        name switch{
                                "Iris-setosa" => Color.fromString("blue"),
                                "Iris-versicolor" => Color.fromString("orange"),
                                _ => Color.fromString("deeppink")});

var layout = Layout.init<IConvertible>(Title:title, PlotBGColor : Color.fromString("#e5ecf6"));

var xAxis = LinearAxis.init<IConvertible, IConvertible, IConvertible, IConvertible, IConvertible, IConvertible>(
        Title:Title.init("xAxis"),
        ZeroLineColor:Color.fromString("#ffff"),
        GridColor:Color.fromString("#ffff"),
        ZeroLineWidth:2);

var yAxis = LinearAxis.init<IConvertible, IConvertible, IConvertible, IConvertible, IConvertible, IConvertible>(
        Title:Title.init("yAxis"),
        ZeroLineColor:Color.fromString("#ffff"),
        GridColor:Color.fromString("#ffff"),
        ZeroLineWidth:2);

Chart2D.Chart.Scatter<float,float,string>(x:X,y:Y,mode:StyleParam.Mode.Markers,Color:Color.fromColors(Colors))
                .WithLayout(layout)        
                .WithXAxis(xAxis)
                .WithYAxis(yAxis)


```

## Make Subplots

Chart.Grid creates a grid of subplots that traces can be added to

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;

int[] x = {1,2,3};
int[] y = {4,2,1};
var scatter = Chart2D.Chart.Scatter<int,int,string>(x : x, y : y, mode : StyleParam.Mode.Markers, Name : "Scatter");
var bar = Chart2D.Chart.Column<int,int,int>(keys:x,values:y,Name:"Bar");

var chartCombined = new []{scatter,bar};
Chart.Grid<IEnumerable<GenericChart.GenericChart>>(1,2).Invoke(chartCombined)
```

# Updating Figures


## Adding Traces

Traces can be added using Chart.combine that creates a GenericChart object

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;

var scatter = Chart2D.Chart.Scatter<int,int,string>(x : x, y : y, mode : StyleParam.Mode.Markers, Name : "Scatter")
                .WithMarkerStyle(Size:10);

var bar = Chart2D.Chart.Column<int,int,int>(keys:x,values:y,Name:"Bar");

Chart.Combine(new []{scatter,bar})

```

## Updating Figure Layouts

Chart.withLayout updates the default Layout for the plot

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;

var title = Title.init (Text : "Using Layout() With Plotly Figures");
var layout = Layout.init<IConvertible>(Title:title, 
                            PlotBGColor : Color.fromString("#e5ecf6"),
                            Font:Font.init(Size:17));

Chart2D.Chart.Column<int,int,int>(keys:new []{1,2,3},values:new []{4,2,1})
    .WithLayout(layout)
```

# Updating Traces

Plotly.NET provides extensions for updating properties of GenericChart

To show some examples, we will start with a chart that contains bar and scatter traces across two subplots.

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using _2DChart = Plotly.NET.Chart2D.Chart;

var fig1 = new []{ 
    _2DChart.Column<int,int,int>(keys:new []{0,1,2},values:new []{2,1,3},Name:"b",Color:Color.fromString("red")),

    _2DChart.Scatter<int,double,int>(x:new []{0,1,2},y:new[]{4,2,3.5},Name:"a",mode:StyleParam.Mode.Markers)
            .WithMarkerStyle(Size:20,Color:Color.fromString("rgb(51, 204, 51)"))
    };

var combinedFig1 = Chart.Combine(fig1);

var fig2 = new []{ 
    _2DChart.Column<int,int,int>(keys:new []{0,1,2},values:new []{1,3,2},Name:"c",Color:Color.fromString("#33cc33")),

    _2DChart.Scatter<int,double,int>(x:new []{0,1,2},y:new[]{2,3.5,4},Name:"a",mode:StyleParam.Mode.Markers)
            .WithMarkerStyle(Size:20,Color:Color.fromString("rgb(255, 0,0)"))
    };

var combinedFig2 = Chart.Combine(fig2);

Chart.Grid<IEnumerable<GenericChart.GenericChart>>(1,2).Invoke(new []{combinedFig1,combinedFig2})
```

Note that both scatter and bar traces have a Marker Color property to control their coloring. Here is an example of using markerStyle() to modify the color of all traces.

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using _2DChart = Plotly.NET.Chart2D.Chart;

var fig1 = new []{ 
    _2DChart.Column<int,int,int>(keys:new []{0,1,2},values:new []{2,1,3},Name:"b",Color:Color.fromString("red")),

    _2DChart.Scatter<int,double,int>(x:new []{0,1,2},y:new[]{4,2,3.5},Name:"a",mode:StyleParam.Mode.Markers)
            .WithMarkerStyle(Size:20,Color:Color.fromString("rgb(51, 204, 51)"))
    };

var combinedFig1 = Chart.Combine(fig1)
                        .WithMarkerStyle(Size:20,Color:Color.fromString("blue"));

var fig2 = new []{ 
    _2DChart.Column<int,int,int>(keys:new []{0,1,2},values:new []{1,3,2},Name:"c",Color:Color.fromString("#33cc33")),

    _2DChart.Scatter<int,double,int>(x:new []{0,1,2},y:new[]{2,3.5,4},Name:"a",mode:StyleParam.Mode.Markers)
            .WithMarkerStyle(Size:20,Color:Color.fromString("rgb(255, 0,0)"))
    };

var combinedFig2 = Chart.Combine(fig2)
                        .WithMarkerStyle(Size:20,Color:Color.fromString("blue"));

Chart.Grid<IEnumerable<GenericChart.GenericChart>>(1,2).Invoke(new []{combinedFig1,combinedFig2})
```

Individual trace marker styles can be updated with markerStyle like as shown above


# Overwrite Existing Properties

It is possible to overwrite the defined properties with the corresponding extension methods / abstractions

For example, Chart.withMarker() overwrites the red color of markers as shown below

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using _2DChart = Plotly.NET.Chart2D.Chart;

var marker = Marker.init<int>(Opacity:0.4);
_2DChart.Column<int,int,int>(keys:new []{1,2,3},values:new []{1,3,2},Color:Color.fromString("red"))
        .WithMarker(marker)
```

# Updating Figure Axes

Here is an example of using Chart.withXAxis to disable the vertical grid lines across the subplots in a figure produced by Plotly.NET

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using _2DChart = Plotly.NET.Chart2D.Chart;
using System;
using LinearAxisTuple = System.Tuple<Plotly.NET.StyleParam.LinearAxisId,Plotly.NET.StyleParam.LinearAxisId>;

var rand = new Random();
var x = Enumerable.Range(1,100).ToArray();
var y1 = x.Select(_ => rand.NextDouble()*10+5);
var y2 = x.Select(_ => rand.NextDouble()*5);

var subPlots =new []{new []{
            new LinearAxisTuple(StyleParam.LinearAxisId.X.NewX(1),
                                            StyleParam.LinearAxisId.X.NewY(1)),
            new LinearAxisTuple(StyleParam.LinearAxisId.X.NewX(2),
                                            StyleParam.LinearAxisId.X.NewY(1))}};

var layoutGrid = LayoutGrid.init(Rows:1,Columns:2,SubPlots:subPlots);

var chart1 = _2DChart.Point<int,double,int>(x:x,y:y1,Name:"1,1")
                    .WithAxisAnchor(X:1);

var chart2 = _2DChart.Point<int,double,int>(x:x,y:y2,Name:"1,2")
                    .WithAxisAnchor(X:2);

Chart.Combine(new []{chart1,chart2})
    .WithLayoutGrid(layoutGrid)
    .WithXAxisStyle(title=Title.init(),ShowGrid:false,Id:StyleParam.SubPlotId.NewXAxis(1))
    .WithXAxisStyle(title=Title.init(),ShowGrid:false,Id:StyleParam.SubPlotId.NewXAxis(2))   

```

# Other Update Methods
GenericCharts created with the Plotly.NET graphing library also support:

the Chart.withLayoutImages() method in order to update background layout images,
Chart.withAnnotations() in order to update annotations,
and Chart.withShapes() in order to update shapes.


# Chaining Figure Operations

All of the Chart update operations described above are methods that return a reference to the Chart being modified. This makes it possible to chain multiple figure modification operations together into a single expression.

Here is an example of a chained expression that:

sets the title font size using Chart.withTitle,
disables vertical grid lines using LinearAxis,
updates the size and color of the markers and bar,
and then displaying the Chart.

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using _2DChart = Plotly.NET.Chart2D.Chart;

var marker = Marker.init<int>(Size:20,Color:Color.fromString("yellow"),Line:Line.init(Width:1.5));
var fig1 = new []{ 
    _2DChart.Column<int,int,int>(keys:new []{0,1,2},values:new []{2,1,3},Name:"b",Color:Color.fromString("red"))
            .WithMarker(marker),

    _2DChart.Scatter<int,double,int>(x:new []{0,1,2},y:new[]{4,2,3.5},Name:"a",mode:StyleParam.Mode.Markers)
            .WithMarkerStyle(Size:20,Color:Color.fromString("blue"))
    };

Chart.Combine(fig1)
    .WithTitle(title:"Chaining Multiple Chart Operations With A Plotly Chart",TitleFont:Font.init(Size:15))
    .WithXAxisStyle(title:Title.init(),ShowGrid:false)
```

# Property Assignment

Trace and layout properties can be updated using property assignment syntax. Here is an example of setting the figure title using property assignment.

As TraceObjects and LayoutObjects are of DynamicObj, they can be set through dynamic property assignment. But this is not a preferred way, consider using appropriate C# abstractions to set the properties

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using _2DChart = Plotly.NET.Chart2D.Chart;

var layout = new Layout();
layout.SetValue("title", "Using Property Assignment Syntax With GenericChart Object");
layout.SetValue("plot_bgcolor", "#e5ecf6");
layout.SetValue("showlegend", true);

_2DChart.Column<int,int,int>(keys:new []{1,2,3},values:new []{1,3,2},Color:Color.fromString("red"))
        .WithLayout(layout)
```

And here is an example of updating the bar outline using property assignment.

```csharp dotnet_interactive={"language": "csharp"}
using Plotly.NET;
using _2DChart = Plotly.NET.Chart2D.Chart;

var marker = new Marker();
var line = new Line();
line.SetValue("width",4);
line.SetValue("color","black");
marker.SetValue("line",line);

_2DChart.Column<int,int,int>(keys:new []{1,2,3},values:new []{1,3,2},Color:Color.fromString("red"))
        .WithMarker(marker)
```
