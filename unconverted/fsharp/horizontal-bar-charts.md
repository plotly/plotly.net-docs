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

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: newtonsoft.json"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET
```

## Horizontal Bar Chart with go.Bar
### Basic Horizontal Bar Chart

```csharp dotnet_interactive={"language": "fsharp"}

[
    Chart.Bar(["giraffes"; "orangutans"; "monkeys"], [20;14;23])
    |> GenericChart.mapTrace(fun x -> 
        x.SetValue("orientation", "h")
        x.SetValue("name", "SF Zoo")
        x.SetValue("marker", {| color = "rgba(246, 78, 139, 0.6)"; line = {| color = "rgba(246, 78, 139, 1.0)"; width = 3 |} |})
        x)
    Chart.Bar(["giraffes"; "orangutans"; "monkeys"], [12;18;29])
    |> GenericChart.mapTrace(fun x -> 
        x.SetValue("orientation", "h")
        x.SetValue("name", "LA Zoo")
        x.SetValue("marker", {| color = "rgba(58, 71, 80, 0.6)"; line = {| color = "rgba(58, 71, 80, 1.0)"; width = 3 |} |})
        x)
]
|> Chart.Combine
|> Chart.withLayout(Layout.init(Barmode = StyleParam.Barmode.Stack))

```

## Color Palette for Bar Chart

```csharp dotnet_interactive={"language": "fsharp"}
let topLabels = ["Strongly<br>agree"; "Agree"; "Neutral"; "Disagree"; "Strongly<br>disagree"]
let colors = [|"rgba(38, 24, 74, 0.8)"; "rgba(71, 58, 131, 0.8)"; "rgba(122, 120, 168, 0.8)"; "rgba(164, 163, 204, 0.85)"; "rgba(190, 192, 213, 1)"|]
let xData = [[21; 30; 21; 16; 12;];
             [24; 31; 19; 15; 11;];
             [27; 26; 23; 11; 13;];
             [29; 24; 15; 18; 14;]]
let yData = ["The course was effectively<br>organized";
             "The course developed my<br>abilities and skills " +
             "for<br>the subject"; "The course developed " +
             "my<br>ability to think critically about<br>the subject";
             "I would recommend this<br>course to a friend"]

let annotations = 
    Seq.map3
        (fun label x y ->
            Annotation.init(
                X = -10.,
                Y = y,
                Text = label,
                Font = Font.init(Family = StyleParam.FontFamily.Arial, Size=14., Color = "rgb(67, 67, 67)"),
                ShowArrow = false
            )
        )
        topLabels xData yData
List.mapi2
    (fun i (x: int list) (y: string) ->
        Chart.Bar(y, x)
        |> GenericChart.mapTrace(
            fun t ->
                t.SetValue("orientation", "h")
                t.SetValue("marker", {| color = colors.[i]; line = {| color = "rgb(248, 248, 249)"; width = 1 |} |})
                t)
    ) xData yData
|> Chart.Combine
|> Chart.withLayout(Layout.init(Width = 1000., Annotations = annotations, Paper_bgcolor = "rgb(248, 248, 255)", Plot_bgcolor = "rgb(248, 248, 255)", Showlegend = false, Barmode = StyleParam.Barmode.Stack, Margin = Margin.init(Left = 120, Right = 10, Top = 140, Bottom = 80)))
|> Chart.withX_Axis(Axis.LinearAxis.init(Domain = StyleParam.Range.MinMax (0.15, 1.), Zeroline = false, Showticklabels = false, Showline = false, Showgrid = false ))
|> Chart.withY_Axis(Axis.LinearAxis.init(Zeroline = false, Showticklabels = false, Showline = false, Showgrid = false ))
```

## Bar Chart with Line Plot

```csharp dotnet_interactive={"language": "fsharp"}
let ySaving = [1.3586; 2.2623000000000002; 4.9821999999999997; 6.5096999999999996; 7.4812000000000003; 7.5133000000000001;15.2148;17.520499999999998]
let yNetWorth = [93453.919999999998; 81666.570000000007; 69889.619999999995; 78381.529999999999; 141395.29999999999; 92969.020000000004; 66090.179999999993; 122379.3]
let x = ["Japan"; "United Kingdom"; "Canada"; "Netherlands"; "United States"; "Belgium"; "Sweden"; "Switzerland"]
let xs = Seq.zip yNetWorth x
Chart.Grid(
    [
        [
            (Chart.Bar(x, ySaving, Name="Household savings, percentage of household disposable income", Marker = Marker.init(Color = "rgba(50, 171, 96, 0.6)", Line = Line.init(Color = "rgba(50, 171, 96, 1.0)", Width =1.)))
                |> Chart.withY_Axis(Axis.LinearAxis.init(Showgrid = false, Showline = false, Showticklabels = true))
                |> Chart.withX_Axis(Axis.LinearAxis.init(Showgrid = true, Showline = false, Showticklabels = true, Zeroline = false)))
            (Chart.Line(xs, Color = "rgb(128, 0, 128)", Name = "Household net worth, Million USD/capita")
                |> Chart.withY_Axis(Axis.LinearAxis.init(Showgrid = false, Showline = true, Showticklabels = false, Linecolor = "rgba(102, 102, 102, 0.8)", Linewidth = 2.))
                |> Chart.withX_Axis(Axis.LinearAxis.init(Showgrid = true, Showline = false, Showticklabels = true, Zeroline = false, Side = StyleParam.Side.Top, dTick = 2500)))
        ]
    ],
    sharedAxes=true
)
|> Chart.withLayout(Layout.init(Width = 1000., Margin = Margin.init(Top = 70., Bottom = 70., Left = 100., Right = 20.), Legend = Legend.init(X = 0.029, Y = 1.100)))
```
