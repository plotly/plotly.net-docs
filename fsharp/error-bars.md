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
    description: How to add error-bars to charts in F# with Plotly.
    display_as: statistical
    language: fsharp
    layout: base
    name: Error Bars
    order: 1
    page_type: example_index
    permalink: fsharp/error-bars/
    thumbnail: thumbnail/error-bar.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Newtonsoft.Json, 12.0.3"
#r "nuget: Plotly.NET, 2.0.0-preview.10"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.10"
#r "nuget: FSharp.Data"
```

For functions representing 2D data points such as Chart.Scatter, Chart.Line, Chart.Bar etc., error bars are given by setting the ErrorX (for the error on x position) and ErrorY (for the error on y position).


# Basic Symmetric Error Bars

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

Chart.Scatter(x = [ 0; 1; 2 ], y = [ 6; 10; 2 ], mode = StyleParam.Mode.Lines_Markers)
|> Chart.withYErrorStyle (Array = [ 1; 2; 3 ])
```

# Asymmetric Error Bars

```fsharp
open Plotly.NET

Chart.Scatter(x = [ 1; 2; 3; 4 ], y = [ 2; 1; 3; 4 ], mode = StyleParam.Mode.Lines_Markers)
|> Chart.withYErrorStyle (Array = [ 0.1; 0.2; 0.1; 0.1 ], Arrayminus = [ 0.2; 0.4; 1.; 0.2 ], Symmetric = false)
```

# Error Bars as a Percentage of the y Value

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.TraceObjects

Chart.Scatter(x = [ 0; 1; 2 ], y = [ 6; 10; 2 ], mode = StyleParam.Mode.Lines_Markers)
|> Chart.withYError (Error.init (Type = StyleParam.ErrorType.Percent, Value = 50.)) // value of error bar given as percentage of y value
```

# Asymmetric Error Bars with a Constant Offset

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

Chart.Scatter(x = [ 1; 2; 3; 4 ], y = [ 2; 1; 3; 4 ], mode = StyleParam.Mode.Lines_Markers)
|> Chart.withYError (
    Error.init (
        Array = [ 0.1; 0.2; 0.1; 0.1 ],
        Arrayminus = [ 0.2; 0.4; 1.; 0.2 ],
        Symmetric = false,
        Value = 15.,
        Valueminus = 25.
    )
)
```

# Horizontal Error Bars

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

Chart.Scatter(x = [ 1; 2; 3; 4 ], y = [ 2; 1; 3; 4 ], mode = StyleParam.Mode.Lines_Markers)
|> Chart.withXError (Error.init (Type = StyleParam.ErrorType.Percent, Value = 10.))
```

# Bar Chart with Error Bars

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

[ 
    Chart.Column(Keys = [ "Trial 1"; "Trial 2"; "Trial 3" ], values = [ 3; 6; 4 ], Name = "Control", ShowLegend = true)
    |> Chart.withYErrorStyle (Array = [ 1.; 0.5; 1.5 ])

    Chart.Column(
      Keys = [ "Trial 1"; "Trial 2"; "Trial 3" ],
      values = [ 4; 7; 3 ],
      Name = "Experimental",
      ShowLegend = true)
    |> Chart.withYErrorStyle (Array = [ 0.5; 1.; 2. ])
]
|> Chart.combine
```

# Colored and Styled Error Bars

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open System

let x_theo = [-4. .. 0.08 ..4.]
let sincx = [for x in x_theo -> Math.Sin(Math.PI*x)/(Math.PI*x)]

let x = [-3.8; -3.03; -1.91; -1.46; -0.89; -0.24; -0.0; 0.41; 0.89; 1.01; 1.91; 2.28; 2.79; 3.56]
let y = [-0.02; 0.04; -0.01; -0.27; 0.36; 0.75; 1.03; 0.65; 0.28; 0.02; -0.11; 0.16; 0.04; -0.15]

[ Chart.Scatter(x = x_theo, y = sincx, mode = StyleParam.Mode.Lines, Name = "sinc(x)")

  Chart.Scatter(x = x, y = y, mode = StyleParam.Mode.Markers, Name = "measured")
  |> Chart.withYError (
      Error.init (
          Type = StyleParam.ErrorType.Constant,
          Value = 0.1,
          Color = Color.fromString "purple",
          Thickness = 1.5,
          Width = 3.
      )
  )
  |> Chart.withXError (
      Error.init (
          Type = StyleParam.ErrorType.Constant,
          Value = 0.2,
          Color = Color.fromString "purple",
          Thickness = 1.5,
          Width = 3.
      )
  )
  |> Chart.withMarkerStyle (Size = 8, Color = Color.fromString "purple") ]
|> Chart.combine
```

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data

let data= CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/iris.csv")

let sepalWidth = data.Rows |> Seq.map (fun row -> float <| row.GetColumn("SepalWidth"))
let sepalLength = data.Rows |> Seq.map (fun row -> float <| row.GetColumn("SepalLength"))
let color = data.Rows 
                |> Seq.map (fun row -> row.GetColumn("Name"))
                |> Seq.map (function
                                    |"Iris-setosa" -> Color.fromString "red"
                                    |"Iris-versicolor" -> Color.fromString "blue"
                                    |_ -> Color.fromString "yellow")
                |> Color.fromColors

let error = sepalWidth |> Seq.map (fun w -> float w/100.)
Chart.Scatter(x=sepalWidth,y=sepalLength,mode=StyleParam.Mode.Markers,Color=color)
|>Chart.withXErrorStyle(Array=error)
|>Chart.withYErrorStyle(Array=error)
|>Chart.withSize(Width=800)
```
