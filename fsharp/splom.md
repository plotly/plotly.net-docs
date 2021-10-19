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
    description: How to make scatterplot matrices or sploms natively in F# with Plotly.
    display_as: statistical
    language: fsharp
    layout: base
    name: Scatterplot Matrix
    order: 6
    page_type: example_index
    permalink: fsharp/splom/
    thumbnail: thumbnail/splom_image.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.10"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.10"
#r "nuget: FSharp.Data"
```

# ScatterPlot Matrix (splom)

A scaterplot matrix is a matrix associated to n numerical arrays (data variables), $X^1,X^2,.,X_n$ , of the same length. The cell (i,j) of such a matrix displays the scatter plot of the variable Xi versus Xj ,

The Plotly splom trace implementation for the scaterplot matrix does not require to set $x=Xi$ , and $y=Xj$, for each scatter plot. All arrays, $X^1,X^2,.,X_n$ , are passed once, through a list of lists called dimensions, i.e. each array/variable represents a dimension.


## Basic a scatterplot matrix (splom)

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let data = 
    [
        "A",[|1.;4.;3.4;0.7;|]
        "B",[|3.;1.5;1.7;2.3;|]
        "C",[|2.;4.;3.1;5.|]
        "D",[|4.;2.;2.;4.;|]
    ]

Chart.Splom(data,Color=Color.fromString "blue")
|> Chart.withLayout(Layout.init(PlotBGColor=Color.fromString "#e5ecf6"))
```

The label in each dimension is assigned to the axes titles of the corresponding matrix cell.

text is either a unique string assigned to all points displayed by splom or a list of strings of the same length as the dimensions, $X_i$. The text[k] is the tooltip for the $k^{th}$ point in each cell.

marker sets the markers attributes in all scatter plots.


## Splom of the Iris data set

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/iris-data.csv")

let getHeader i =
    match data.Headers with
    | Some header -> header.[i]
    | _ -> String.Empty

let splomData =
    [ for i in 0 .. data.NumberOfColumns - 2 -> getHeader i, [ for row in data.Rows -> row.GetColumn(i) ] ]


Chart.Splom(dims = splomData)
|> Chart.withLayout (Layout.init (PlotBGColor = Color.fromString "#e5ecf6"))
|> GenericChart.mapTrace
    (fun trace ->
        trace?text <- [ for row in data.Rows -> row.GetColumn(4) ]
        trace) //Workaround
|> Chart.withMarkerStyle (Outline = Line.init (Color = Color.fromString "white", Width = 0.5))

```

The scatter plots on the principal diagonal can be removed by setting diagonal_visible=false: (NOT WORKING YET)

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/iris-data.csv")

let getHeader i =
    match data.Headers with
    | Some header -> header.[i]
    | _ -> String.Empty

let splomData =
    [ for i in 0 .. data.NumberOfColumns - 2 -> getHeader i, [ for row in data.Rows -> row.GetColumn(i) ] ]


Chart.Splom(dims = splomData)
|> Chart.withLayout (Layout.init (PlotBGColor = Color.fromString "#e5ecf6"))
|> GenericChart.mapTrace
    (fun trace ->
        trace?text <- [ for row in data.Rows -> row.GetColumn(4) ]
        trace?diagonal_visible <- false 
        trace) //Workaround
|> Chart.withMarkerStyle (Outline = Line.init (Color = Color.fromString "white", Width = 0.5))

```

To plot only the lower/upper half of the splom we switch the default showlowerhalf=True/showupperhalf=True to False:

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET.TraceObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/iris-data.csv")

let getHeader i =
    match data.Headers with
    | Some header -> header.[i]
    | _ -> String.Empty

let splomData =
    [ for i in 0 .. data.NumberOfColumns - 2 -> getHeader i, [ for row in data.Rows -> row.GetColumn(i) ] ]


Chart.Splom(dims = splomData)
|> Chart.withLayout (Layout.init (PlotBGColor = Color.fromString "#e5ecf6"))
|> GenericChart.mapTrace
    (fun trace ->
        trace?text <- [ for row in data.Rows -> row.GetColumn(4) ]
        trace?showupperhalf <- false 
        trace) //Workaround
|> Chart.withMarkerStyle (Outline = Line.init (Color = Color.fromString "white", Width = 0.5))

```

Each scatter plot can be explicitly configured through Dimension object as shown below. We can choose to remove a variable from splom, by setting visible=False in its corresponding dimension. In this case the default grid associated to the scatterplot matrix keeps its number of cells, but the cells in the row and column corresponding to the visible false dimension are empty:

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET.TraceObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/iris-data.csv")

let getHeader i =
    match data.Headers with
    | Some header -> header.[i]
    | _ -> String.Empty

let splomData =
    [ for i in 0 .. data.NumberOfColumns - 2 -> getHeader i, [ for row in data.Rows -> row.GetColumn(i) ] ]

let dimensions =
    splomData
    |> Seq.mapi
        (fun i dim ->
            Dimensions.init (
                Values = snd dim,
                Label = fst dim,
                Visible = if i % 2 = 0 then true else false
            ))

Chart.Splom(dims = dimensions)
|> Chart.withLayout (Layout.init (PlotBGColor = Color.fromString "#e5ecf6"))
|> Chart.withMarkerStyle (Outline = Line.init (Color = Color.fromString "white", Width = 0.5))

```

## Splom for the diabetes dataset

Diabetes dataset is downloaded from <a href="https://www.kaggle.com/uciml/pima-indians-diabetes-database/data" target="_blank">kaggle</a>. It is used to predict the onset of diabetes based on 8 diagnostic measures. The diabetes file contains the diagnostic measures for 768 patients, that are labeled as non-diabetic (Outcome=0), respectively diabetic (Outcome=1). The splom associated to the 8 variables can illustrate the strength of the relationship between pairs of measures for diabetic/nondiabetic patients.

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET.TraceObjects

let data =
    CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/diabetes.csv")

let getHeader i =
    match data.Headers with
    | Some header -> header.[i]
    | _ -> String.Empty

let splomData =
    [ for i in 0 .. data.NumberOfColumns - 2 -> getHeader i, [ for row in data.Rows -> row.GetColumn(i) ] ]

let color =
    [ for row in data.Rows ->
          if row.GetColumn("Outcome") = "1" then
              Color.fromString "blue"
          else
              Color.fromString "red" ]

let title =
    "Scatterplot Matrix (SPLOM) for Diabetes Dataset<br>Data source:
         <a href='https://www.kaggle.com/uciml/pima-indians-diabetes-database/data'>[1]</a>"

Chart.Splom(splomData)
|> GenericChart.mapTrace
    (fun trace ->
        trace?text <- [ for row in data.Rows ->
                            if row.GetColumn("Outcome") = "1" then
                                "diabetic"
                            else
                                "non-diabetic" ]

        trace) //Workaround
|> Chart.withLayout (
    Layout.init (
        Title = Title.init (title),
        PlotBGColor = Color.fromString "#e5ecf6",
        DragMode = StyleParam.DragMode.Select,
        HoverMode = StyleParam.HoverMode.Closest
    )
)
|> Chart.withMarkerStyle (
    Outline = Line.init (Color = Color.fromString "white", Width = 0.5),
    Color = Color.fromColors color
)
|> Chart.withSize (Width = 1000, Height = 1000)

```
