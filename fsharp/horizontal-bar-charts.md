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
    description: How to make horizontal bar charts in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Horizontal Bar
    order: 8
    page_type: u-guide
    permalink: fsharp/horizontal-bar-charts/
    thumbnail: thumbnail/horizontal-bar.jpg
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.8"
open Plotly.NET
```

# Basic Horizontal Bar Chart

```fsharp  dotnet_interactive={"language": "fsharp"}
Chart.Bar(["giraffes"; "orangutans"; "monkeys"], [20;14;23])
```

# Colored Horizontal Bar Chart


```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects

let markerStyle1 = Marker.init(Color=Color.fromString "rgba(246, 78, 139, 0.6)",Line=Line.init(Color=Color.fromString "rgba(246, 78, 139, 1.0)",Width=3.))
let markerStyle2 = Marker.init(Color=Color.fromString "rgba(58, 71, 80, 0.6)",Line=Line.init(Color=Color.fromString "rgba(58, 71, 80, 1.0)",Width=3.))

[
    Chart.Bar(["giraffes"; "orangutans"; "monkeys"], [20;14;23],Marker=markerStyle1,Name="SF Zoo")    
    Chart.Bar(["giraffes"; "orangutans"; "monkeys"], [12;18;29],Marker=markerStyle2,Name="LA Zoo")    
]
|> Chart.combine
|> Chart.withLayout(Layout.init(BarMode = StyleParam.BarMode.Stack))

```

# Color Palette for Bar Chart

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET.TraceObjects
open Plotly.NET.LayoutObjects

let n = 4
let topLabels = ["Strongly<br>agree"; "Agree"; "Neutral"; "Disagree"; "Strongly<br>disagree"]
let colors = [|"rgba(38, 24, 74, 0.8)"; "rgba(71, 58, 131, 0.8)"; "rgba(122, 120, 168, 0.8)"; "rgba(164, 163, 204, 0.85)"; "rgba(190, 192, 213, 1)"|]
let xData = [[|21; 30; 21; 16; 12;|];
             [|24; 31; 19; 15; 11;|];
             [|27; 26; 23; 11; 13;|];
             [|29; 24; 15; 18; 14;|]]
let yData = ["The course was effectively<br>organized";
             "The course developed my<br>abilities and skills " +
             "for<br>the subject"; "The course developed " +
             "my<br>ability to think critically about<br>the subject";
             "I would recommend this<br>course to a friend"]

let fSum x = (Array.scan (+) 0 x).[0..n]

let cumX j= fSum xData.[j]
            |> Array.mapi (fun i x -> if i > 0 then x+xData.[0].[i]/2 else xData.[0].[0]/2)

let top_annotation =[ for i in 0..4 -> Annotation.init(XRef="x",YRef="paper",
                                                        X=(cumX 0 |> Array.item i),
                                                        Y=1.1,
                                                        ShowArrow = false,
                                                        Text=topLabels.[i])]

let label_annotations = [for i in 0..4 -> 
                                [for j in 0..3 -> 
                                        Annotation.init(XRef="x",YRef="y",
                                                        X=(cumX j |> Array.item i),
                                                        Y=yData.[j],
                                                        ShowArrow = false,
                                                        Font = Font.init(Family = StyleParam.FontFamily.Arial, Size=14., Color =Color.fromString "white"),
                                                        Text=string xData.[j].[i]+"%")]] |> Seq.concat |> Seq.toList

let annotations = top_annotation @ label_annotations

let markerStyle i= Marker.init(Color=Color.fromString (colors.[i]),Line=Line.init(Color=Color.fromString "rgb(248, 248, 249)",Width=1.))

let y i= Array.init n (fun _ -> yData.[i])

[for j in 0..n  -> [for i in 0..3 -> Chart.Bar(keys=y i,values=[xData.[i].[j]],Marker=markerStyle j)] ] |> Seq.concat
|> Chart.combine
|> Chart.withLayout(Layout.init(BarMode=StyleParam.BarMode.Stack,
                        Margin = Margin.init(Left = 120, Right = 10, Top = 140, Bottom = 80),
                        ShowLegend=false,
                        Annotations=annotations,
                        PaperBGColor =Color.fromString "rgb(248, 248, 255)", PlotBGColor =Color.fromString "rgb(248, 248, 255)",
                        Font = Font.init(Family = StyleParam.FontFamily.Arial, Size=14., Color =Color.fromString "rgb(67, 67, 67)")))
|> Chart.withSize(1100,700)
|> Chart.withXAxis(LinearAxis.init(Domain = StyleParam.Range.MinMax (0.15, 1.), ZeroLine = false, ShowTickLabels = false, ShowLine = false, ShowGrid = false ))
|> Chart.withYAxis(LinearAxis.init(ZeroLine = false, ShowTickLabels = false, ShowLine = false, ShowGrid = false ))

```

# Bar Chart with Line Plot

```fsharp  dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let ySaving = [|1.3586; 2.2623000000000002; 4.9821999999999997; 6.5096999999999996; 7.4812000000000003; 7.5133000000000001;15.2148;17.520499999999998|]
let yNetWorth = [|93453.919999999998; 81666.570000000007; 69889.619999999995; 78381.529999999999; 141395.29999999999; 92969.020000000004; 66090.179999999993; 122379.3|]
let x = [|"Japan"; "United Kingdom"; "Canada"; "Netherlands"; "United States"; "Belgium"; "Sweden"; "Switzerland"|]
let xs = Seq.zip yNetWorth x

let barChart = (Chart.Bar(x, ySaving, Name="Household savings, percentage of household disposable income", Marker = Marker.init(Color =Color.fromString "rgba(50, 171, 96, 0.6)", Line = Line.init(Color =Color.fromString "rgba(50, 171, 96, 1.0)", Width =1.)))
                |> Chart.withYAxis(LinearAxis.init(ShowGrid = false, ShowLine = false, ShowTickLabels = true,Domain=StyleParam.Range.MinMax(0.,0.85)))
                |> Chart.withXAxis(LinearAxis.init(ShowGrid = true, ShowLine = false, ShowTickLabels = true, ZeroLine = false,Domain=StyleParam.Range.MinMax(0.,0.42))))

let lineChart =  (Chart.Line(xs, Color =Color.fromString "rgb(128, 0, 128)", Name = "Household net worth, Million USD/capita")
                    |> Chart.withYAxis(LinearAxis.init(ShowGrid = false, ShowLine = true, ShowTickLabels = false, LineColor =Color.fromString "rgba(102, 102, 102, 0.8)", LineWidth = 2.,Domain=StyleParam.Range.MinMax(0.,0.85)))
                    |> Chart.withXAxis(LinearAxis.init(ShowGrid = true, ShowLine = false, ShowTickLabels = true, ZeroLine = false, Side = StyleParam.Side.Top, DTick = 25000,Domain=StyleParam.Range.MinMax(0.47,1.))))


let annotations = [for (ydn, yd, xd) in Array.zip3 yNetWorth ySaving x->

                                                     [|Annotation.init(XRef="x1",YRef="y1",
                                                        X=yd+3.,
                                                        Y=xd,
                                                        ShowArrow = false,
                                                        Font = Font.init(Family = StyleParam.FontFamily.Arial, Size=14., Color =Color.fromString "rgb(50, 171, 96)"),
                                                        Text=string yd+"%");

                                                        Annotation.init(XRef="x2",YRef="y2",
                                                        X=ydn-20000.,
                                                        Y=xd,
                                                        ShowArrow = false,
                                                        Font = Font.init(Family = StyleParam.FontFamily.Arial, Size=14., Color =Color.fromString "rgb(128, 0, 128)"),
                                                        Text=string ydn+"M")|] ] |> Array.concat

let labelAnnotation = Annotation.init(XRef="paper",YRef="paper",
                                            X= 0,
                                            Y= -0.109,
                                            ShowArrow = false,
                                            Font = Font.init(Family = StyleParam.FontFamily.Arial, Size=10., Color =Color.fromString "rgb(150,150,150)"),
                                            Text="OECD (2015), Household savings (indicator), Household net worth (indicator). doi: 10.1787/cfc6f499-en (Accessed on 05 June 2015")

let allAnnotations = annotations|> Array.append [|labelAnnotation|]

[barChart;lineChart]
|> Chart.Grid(1,2)
|> Chart.withLayout(Layout.init(Width = 1000, Margin = Margin.init(Top = 70., Bottom = 70., Left = 100., Right = 20.), Legend = Legend.init(X = 0.029, Y = 1.100)))
|> Chart.withAnnotations(allAnnotations)
```
