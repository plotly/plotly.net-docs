---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.4.2
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
    description: How to make Box Plots in F# with Plotly.
    display_as: statistical
    language: fsharp
    layout: base
    name: Box Plots
    order: 2
    page_type: example_index
    permalink: fsharp/box-plots/
    thumbnail: thumbnail/box.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
```

# Basic Boxplot

```fsharp dotnet_interactive={"language": "fsharp"}

open Plotly.NET
let y =  [2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]
let x = ["bin1";"bin2";"bin1";"bin2";"bin1";"bin2";"bin1";"bin1";"bin2";"bin1"]

Chart.BoxPlot(x,y,Jitter=0.1,Boxpoints=StyleParam.Boxpoints.All)


```

# Choosing The Algorithm For Computing Quartiles


By default, quartiles for box plots are computed using the linear method (for more about linear interpolation, see #10 listed on http://www.amstat.org/publications/jse/v14n3/langford.html and https://en.wikipedia.org/wiki/Quartile for more details).

However, you can also choose to use an exclusive or an inclusive algorithm to compute quartiles.

The exclusive algorithm uses the median to divide the ordered dataset into two halves. If the sample is odd, it does not include the median in either half. Q1 is then the median of the lower half and Q3 is the median of the upper half.

The inclusive algorithm also uses the median to divide the ordered dataset into two halves, but if the sample is odd, it includes the median in both halves. Q1 is then the median of the lower half and Q3 the median of the upper half.

```fsharp dotnet_interactive={"language": "fsharp"}
let y' =  [2.; 1.5; 5.; 1.5; 2.; 2.5; 2.1; 2.5; 1.5; 1.;2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]


Chart.BoxPlot(x,y',Boxpoints=StyleParam.Boxpoints.All,QuartileMethod=StyleParam.QuartileMethod.Exclusive) //Inclusive or "Linear" by default


```

# Modifying The Algorithm For Computing Quartiles


For an explanation of how each algorithm works, see  <a href="https://plotly.com/r/box-plots/#choosing-the-algorithm-for-computing-quartiles" target="_blank">Choosing The Algorithm For Computing Quartiles</a>

```fsharp dotnet_interactive={"language": "fsharp"}
let y =  [1;2;3;4;5]

[
    Chart.BoxPlot(y=y,Boxpoints=StyleParam.Boxpoints.All,QuartileMethod=StyleParam.QuartileMethod.Linear,Name="Linear Quartile");
    Chart.BoxPlot(y=y,Boxpoints=StyleParam.Boxpoints.All,QuartileMethod=StyleParam.QuartileMethod.Inclusive,Name="Inclusive Quartile");
    Chart.BoxPlot(y=y,Boxpoints=StyleParam.Boxpoints.All,QuartileMethod=StyleParam.QuartileMethod.Exclusive,Name="Exclusive Quartile")]

|> Chart.combine

```

# Horizontal Boxplot

```fsharp dotnet_interactive={"language": "fsharp"}
let x1 =  [1;2;3;4;5]

let x2 =  [1;2;4;5;6;9]

[
    Chart.BoxPlot(x=x1,Boxpoints=StyleParam.Boxpoints.All);
    Chart.BoxPlot(x=x2,Boxpoints=StyleParam.Boxpoints.All)
]
|> Chart.combine
```

# Adding Jittered Points

```fsharp dotnet_interactive={"language": "fsharp"}
let y =  [2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]

Chart.BoxPlot(y=y,Boxpoints=StyleParam.Boxpoints.All,Jitter=0.5,Pointpos= -1.8)
```

# Styled box plot

```fsharp dotnet_interactive={"language": "fsharp"}
let y =  [2.; 1.5; 5.; 1.5; 3.; 2.5; 2.5; 1.5; 3.5; 1.]

Chart.BoxPlot(y=y,Boxpoints=StyleParam.Boxpoints.All,Jitter=0.5,Notched=true,Color="red",Name="Styled box plot")
```

# Box Plot Styling Mean & Standard Deviation

```fsharp dotnet_interactive={"language": "fsharp"}
let y=[2.37; 2.16; 4.82; 1.73; 1.04; 0.23; 1.32; 2.91; 0.11; 4.51; 0.51; 3.75; 1.35; 2.98; 4.50; 0.18; 4.66; 1.30; 2.06; 1.19]

[
    Chart.BoxPlot(y=y,Boxpoints=StyleParam.Boxpoints.All,Jitter=0.5,Notched=true,Marker=Marker.init(Color="red"),Boxmean=StyleParam.BoxMean.True,Name="Only Mean");
    Chart.BoxPlot(y=y,Boxpoints=StyleParam.Boxpoints.All,Jitter=0.5,Notched=true,Marker=Marker.init(Color="blue"),Boxmean=StyleParam.BoxMean.SD,Name="Mean & SD")]
|> Chart.combine
```

# Grouped Box plots

```fsharp dotnet_interactive={"language": "fsharp"}

```

# Styling Outliers
