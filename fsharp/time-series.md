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
    description: How to plot date and time in F#.
    display_as: financial
    language: fsharp
    layout: base
    name: Time Series and Date Axes
    order: 1
    page_type: example_index
    permalink: fsharp/time-series/
    thumbnail: thumbnail/time-series.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.10"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.10"
#r "nuget: Deedle"
#r "nuget: FSharp.Data"

```

# Time Series using Axes of type date

For financial applications, Plotly can also be used to create Candlestick charts and OHLC charts, which default to date axes.
Plotly auto-sets the axis type to a date format when the corresponding data are either ISO-formatted date strings


```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open FSharp.Data
open Deedle

let dataset = 
  Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv"
   |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumn column=
        dataset
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

Chart.Scatter(getColumn "Date",getColumn "AAPL.High",mode = StyleParam.Mode.Lines_Markers)

```

# Different Chart Types on Date Axes

Any kind of cartesian chart can be placed on date axes, for example this bar chart of relative stock ticker values.

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data

let data = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/2014_apple_stock.csv")

let x = data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL_x"))
let y = data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL_y"))

Chart.Column(Keys=x,values=y)
|> Chart.withTitle("AAPL stock price")

```

# Configuring Tick Labels

By default, the tick labels (and optional ticks) are associated with a specific grid-line, and represent an instant in time, for example, "00:00 on February 1, 2018". Tick labels can be formatted using the tickformat attribute (which accepts the d3 time-format formatting strings) to display only the month and year, but they still represent an instant by default, so in the figure below, the text of the label "Feb 2018" spans part of the month of January and part of the month of February. The dtick attribute controls the spacing between gridlines, and the "M1" setting means "1 month". This attribute also accepts a number of milliseconds, which can be scaled up to days by multiplying by 24*60*60*1000.

Date axis tick labels have the special property that any portion after the first instance of "\n" in tickformat will appear on a second line only once per unique value, as with the year numbers in the example below. To have the year number appear on every tick label, "<br>" should be used instead of "\n".

Note that by default, the formatting of values of X and Y values in the hover label matches that of the tick labels of the corresponding axes, so when customizing the tick labels to something broad like "month", it"s usually necessary to customize the hover label to something narrower like the actual date, as below.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/stockdata.csv")

let getChart (stock: string) =
    let y =
        data.Rows
        |> Seq.map (fun row -> row.GetColumn(stock))
        |> Seq.take 300

    let x =
        data.Rows
        |> Seq.map (fun row -> row.GetColumn("Date"))
        |> Seq.take 300

    Chart.Line(x = x, y = y, Name = stock)


[ getChart "AAPL"
  getChart "SBUX"
  getChart "IBM"
  getChart "MSFT" ]
|> Chart.combine
|> Chart.withXAxis (LinearAxis.init (DTick = "M1", TickFormat = "%b\n%Y"))
|> Chart.withTitle("custom tick labels")

```

# Moving Tick Labels to the Middle of the Period
By setting the TickLabelMode attribute to "period" (the default is "instant") we can move the tick labels to the middle of the period they represent. The gridlines remain at the beginning of each month (thanks to DTick="M1") but the labels now span the month they refer to.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/stockdata.csv")

let getChart (stock: string) =
    let y =
        data.Rows
        |> Seq.map (fun row -> row.GetColumn(stock))
        |> Seq.take 250

    let x =
        data.Rows
        |> Seq.map (fun row -> row.GetColumn("Date"))
        |> Seq.take 250

    Chart.Line(x = x, y = y, Name = stock)


[ getChart "AAPL"
  getChart "SBUX"
  getChart "IBM"
  getChart "MSFT" ]
|> Chart.combine
|> Chart.withXAxis (LinearAxis.init (DTick = "M1", TickFormat = "%b\n%Y", TickLabelMode=StyleParam.TickLabelMode.Period))
|> Chart.withTitle("custom tick labels with TickLabelMode='Period'")

```

# Summarizing Time-series Data with Histograms
Plotly histograms are powerful data-aggregation tools which even work on date axes. In the figure below, we pass in daily data and display it as monthly averages by setting histfunc="avg and xbins_size="M1".

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

let y = data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL.Close"))
let x = data.Rows |> Seq.map (fun row -> row.GetColumn("Date"))

[
    Chart.Histogram (y)
    |> GenericChart.mapTrace (Trace2DStyle.Histogram(X=x,Y=y,nBinsx=30,HistFunc=StyleParam.HistFunc.Avg))

    Chart.Point(x=x,y=y)
]
|> Chart.combine
|> Chart.withXAxis (LinearAxis.init (DTick = "M1", TickFormat = "%b\n%Y"))
|> Chart.withLayout (Layout.init(BarGap=0.1))
```

# Displaying Period Data

If your data coded "January 1" or "January 31" in fact refers to data collected throughout the month of January, for example, you can configure your traces to display their marks at the start end, or middle of the month with the xperiod and xperiodalignment attributes. In the example below, the raw data is all coded with an X value of the 10th of the month, but is binned into monthly periods with xperiod="M1" and then displayed at the start, middle and end of the period.


```fsharp dotnet_interactive={"language": "fsharp"}
let date =
    [ "2020-01-10"
      "2020-02-10"
      "2020-03-10"
      "2020-04-10"
      "2020-05-10"
      "2020-06-10" ]

let value = [ 1; 2; 3; 1; 2; 3 ]

[ Chart.Scatter(
    date,
    value,
    mode = StyleParam.Mode.Lines_Markers,
    Name = "Raw Data",
    MarkerSymbol = StyleParam.MarkerSymbol.Asterisk
  )
  Chart.Scatter(date, value, mode = StyleParam.Mode.Lines_Markers, Name = "Start-aligned")
  |> GenericChart.mapTrace (Trace2DStyle.Scatter(XPeriod = "M1", XPeriodAlignment = StyleParam.PeriodAlignment.Start))

  Chart.Scatter(date, value, mode = StyleParam.Mode.Lines_Markers, Name = "Middle-aligned")
  |> GenericChart.mapTrace (Trace2DStyle.Scatter(XPeriod = "M1", XPeriodAlignment = StyleParam.PeriodAlignment.Middle))

  Chart.Scatter(date, value, mode = StyleParam.Mode.Lines_Markers, Name = "End-aligned")
  |> GenericChart.mapTrace (Trace2DStyle.Scatter(XPeriod = "M1", XPeriodAlignment = StyleParam.PeriodAlignment.End))

  Chart.Column(Keys=date,values=value, Name = "Bar-Middle-aligned", Color = Color.fromString "rgba(247, 156, 83, 0.86)")
  |> GenericChart.mapTrace (Trace2DStyle.Scatter(XPeriod = "M1", XPeriodAlignment = StyleParam.PeriodAlignment.Middle))

  ]

|> Chart.combine
|> Chart.withXAxis (LinearAxis.init(TickLabelMode = StyleParam.TickLabelMode.Period))

```

# Hover Templates with Mixtures of Period data


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

# Time Series With Range Slider

A range slider is a small subplot-like area below a plot which allows users to pan and zoom the X-axis while maintaining an overview of the chart.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

let y = data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL.Close"))
let x = data.Rows |> Seq.map (fun row -> row.GetColumn("Date"))

Chart.Line(x=x,y=y)
|> Chart.withXAxisRangeSlider(RangeSlider.init(Visible=true))
```

# Time Series with Range Selector Buttons

Range selector buttons are special controls that work well with time series and range sliders, and allow users to easily set the range of the x-axis. 

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

let y = data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL.Close"))
let x = data.Rows |> Seq.map (fun row -> row.GetColumn("Date"))

let buttons = [
    Button.init(Count=1,Label="1m",Step=StyleParam.TimeStep.Month,StepMode=StyleParam.TimeStepMode.Backward)
    Button.init(Count=6,Label="6m",Step=StyleParam.TimeStep.Month,StepMode=StyleParam.TimeStepMode.Backward)
    Button.init(Count=1,Label="YTD",Step=StyleParam.TimeStep.Year,StepMode=StyleParam.TimeStepMode.ToDate)
    Button.init(Count=1,Label="1y",Step=StyleParam.TimeStep.Year,StepMode=StyleParam.TimeStepMode.Backward)
    Button.init(Step=StyleParam.TimeStep.All)
    ]

Chart.Line(x=x,y=y)
|> Chart.withXAxisRangeSlider(RangeSlider.init(Visible=true))
|> Chart.withXAxis(LinearAxis.init(RangeSelector=RangeSelector.init(Buttons=buttons)))
```

# Customizing Tick Label Formatting by Zoom Level (NOT WORKING Issue#228)

The TickFormatStops attribute can be used to customize the formatting of tick labels depending on the zoom level. Try zooming in to the chart below and see how the tick label formatting changes

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

let y = data.Rows |> Seq.map (fun row -> row.GetColumn("AAPL.Close"))
let x = data.Rows |> Seq.map (fun row -> row.GetColumn("Date"))

let tickFormatStops = [
    TickFormatStop.init(DTickRange=[("nothing","1000")],Value="%H:%M:%S.%L ms")
    TickFormatStop.init(DTickRange=[("1000","60000")],Value="%H:%M:%S s")
    TickFormatStop.init(DTickRange=[("60000", "3600000")],Value="%H:%M m")
    TickFormatStop.init(DTickRange=[("3600000", "86400000")],Value="%H:%M h")
    TickFormatStop.init(DTickRange=[("86400000", "604800000")],Value="%e. %b d")
    TickFormatStop.init(DTickRange=[("604800000", "M1")],Value="%e. %b w")
    TickFormatStop.init(DTickRange=[("M1", "M12")],Value="%b %y M")
    TickFormatStop.init(DTickRange=[("M12", "nothing")],Value="%Y Y")
    ]

Chart.Line(x=x,y=y)
|> Chart.withXAxisRangeSlider(RangeSlider.init(Visible=true))
|> Chart.withXAxis(LinearAxis.init(TickFormatStops=tickFormatStops))
```

# Hiding Weekends and Holidays
The Rangebreaks attribute available on x- and y-axes of type date can be used to hide certain time-periods. In the example below, we show two plots: one in default mode to show gaps in the data, and one where we hide weekends and holidays to show an uninterrupted trading history. Note the smaller gaps between the grid lines for December 21 and January 4, where holidays were removed.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

let filteredData =
    data.Rows
    |> Seq.filter
        (fun row ->
            DateTime.Parse(row.GetColumn("Date"))
            >= DateTime.Parse("2015-12-01")
            && DateTime.Parse(row.GetColumn("Date"))
               <= DateTime.Parse("2016-01-15"))

let y =
    filteredData
    |> Seq.map (fun row -> row.GetColumn("AAPL.Close"))

let x =
    filteredData
    |> Seq.map (fun row -> row.GetColumn("Date"))

Chart.Point(x = x, y = y)
|> Chart.withTitle("Default Display with Gaps")

```

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv")

let filteredData =
    data.Rows
    |> Seq.filter
        (fun row ->
            DateTime.Parse(row.GetColumn("Date"))
            >= DateTime.Parse("2015-12-01")
            && DateTime.Parse(row.GetColumn("Date"))
               <= DateTime.Parse("2016-01-15"))

let y =
    filteredData
    |> Seq.map (fun row -> row.GetColumn("AAPL.Close"))

let x =
    filteredData
    |> Seq.map (fun row -> row.GetColumn("Date"))

let rangeBreaks = [
    Rangebreak.init(Bounds=("sat", "mon")) // hide weekends
    Rangebreak.init(Values=["2015-12-25"; "2016-01-01"]) // hide Christmas and New Year"s
]

Chart.Point(x=x,y=y)
|> Chart.withXAxis(LinearAxis.init(Rangebreaks=rangeBreaks))
|> Chart.withTitle("Hide Weekend and Holiday Gaps with rangebreaks")
```
