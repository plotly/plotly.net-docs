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
    description: How to make tables in F# with Plotly.
    display_as: basic
    language: fsharp
    layout: base
    name: Tables
    order: 5
    page_type: u-guide
    permalink: fsharp/table/
    thumbnail: thumbnail/table.gif
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
#r "nuget: FSharp.Data, 4.2.2"

open Plotly.NET
```

## Basic Table

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let header = ["A Scores";"B Scores"]
let rows =
    [
        [100; 95]
        [90; 85]
        [80; 75]
        [90; 95]
    ]

Chart.Table(header, rows)
```

## Styled Table

```fsharp dotnet_interactive={"language": "fsharp"}
let header = ["A Scores";"B Scores"]
let rows =
    [
        [100; 95]
        [90; 85]
        [80; 75]
        [90; 95]
    ]

let headerLineStyle = Line.init(Color="#2f4f4f")
let cellLineStyle = Line.init(Color="#2f4f4f")
let width = 500.0
let height = 300.0

Chart.Table(header,
            rows,
            AlignHeader = [StyleParam.HorizontalAlign.Left],
            AlignCells = [StyleParam.HorizontalAlign.Left],
            ColorHeader = "#87CEFA",
            ColorCells = "#E0FFFF",
            LineHeader = headerLineStyle,
            LineCells = cellLineStyle)
    |> Chart.withSize (width, height)
```

## Use a Pandas Dataframe

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET

type UsaStatesDataset = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/master/2014_usa_states.csv">

let data = UsaStatesDataset.GetSample()
let headers = match data.Headers with
              | Some h -> h
              | None -> [||]

let rows = data.Rows |> Seq.map(fun r -> [r.Rank.ToString()
                                          r.State
                                          r.Postal
                                          r.Population.ToString("0")])

Chart.Table(headers,
            rows,
            AlignHeader = [StyleParam.HorizontalAlign.Left],
            AlignCells = [StyleParam.HorizontalAlign.Left],
            ColorHeader = "#AFEEEE",
            ColorCells = "#E6E6FA")
```

## Changing Row and Column Size

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET

let loremIpsum = "Lorem ipsum dolor sit amet, tollit discere inermis pri ut. Eos ea iusto timeam, an prima laboramus vim. Id usu aeterno adversarium, summo mollis timeam vel ad"

let headers = [ "<b>EXPENSES</b><br>as of July 2017"; "<b>DESCRIPTION</b>"]
let rows = [
     ["Salaries"; loremIpsum]
     ["Office"; loremIpsum]
     ["Merchandise"; loremIpsum]
     ["Legal"; loremIpsum]
     ["<b>TOTAL<br>EXPENSES</b>"; loremIpsum]
]

Chart.Table(headers,
            rows,
            AlignHeader = [StyleParam.HorizontalAlign.Left],
            AlignCells = [StyleParam.HorizontalAlign.Left],
            ColumnWidth = [80; 400],
            ColumnOrder = [1;2],
            ColorHeader = "#4169E1",
            FontHeader = Font.init(Color="#FFFFFF"),
            ColorCells = ["#AFEEEE"; "#FFFFFF"])
    |> Chart.withSize (800.0, 500.0)
```

## Alternating Row Colors

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open System

let headers = ["<b>EXPENSES</b>";"<b>Q1</b>";"<b>Q2</b>";"<b>Q3</b>";"<b>Q4</b>"]

type CellValue = | Subtitle of string | Amount of int
let renderCellValue value = match value with
                            | Subtitle v -> v
                            | Amount v -> v.ToString()

let rows = [ ["Salaries"; "1200000" ;  "1300000" ;  "1300000" ;  "1400000" ];
             [ "Office"; "20000"; "20000"; "20000"; "20000"];
             [ "Merchandise"; "80000"; "70000"; "120000"; "90000"];
             ["Legal"; "2000"; "2000"; "2000"; "2000" ];
             ["<b>TOTAL</b>"; "12120000"; "130902000"; "131222000"; "1410200"] ]

let headerColor = "grey"
let rowEvenColor = "lightgrey"
let rowOddColor = "white"

Chart.Table(headers,
            rows,
            AlignHeader = [StyleParam.HorizontalAlign.Left],
            AlignCells = [StyleParam.HorizontalAlign.Left; StyleParam.HorizontalAlign.Center],
            ColorHeader = headerColor,
            FontHeader = Font.init(Color="#FFFFFF"),
            ColorCells = [
                            [rowOddColor; rowEvenColor; rowOddColor; rowEvenColor; rowOddColor]
                         ])
```

## Row Color Based on Variable

```fsharp dotnet_interactive={"language": "fsharp"}
let headers = ["Color"; "<b>YEAR</b>"]

let rows = [
                ["#EFF3FF"; "2010"];
                ["#BDD7E7"; "2011"];
                ["#6BAED6"; "2012"];
                ["#3182BD"; "2013"];
                ["#08519C"; "2014"]
            ];

Chart.Table(headers,
            rows,
            ColorCells = [["#EFF3FF"; "#BDD7E7"; "#6BAED6"; "#3182BD"; "#08519C"]] )
```

## Cell Color Based on Variable

```fsharp dotnet_interactive={"language": "fsharp"}
let headers = ["<b>Column A</b>"; "<b>Column B</b>"; "<b>Column C</b>"]

let rows = [
                ["5"; "5"; "6"]
                ["8"; "2"; "7"]
                ["5"; "4"; "6"]
                ["0"; "2"; "1"]
                ["0"; "4"; "0"]
                ["1"; "7"; "1"]
                ["7"; "7"; "8"]
                ["6"; "1"; "8"]
                ["2"; "7"; "3"]
                ["4"; "0"; "8"]
            ];

Chart.Table(headers,
            rows,
            ColorCells = [["#FFC8C8"; "#FFC8C8"; "#D63232"]
                          ["#FFC8C8";"#F19696"; "#F8AFAF"]
                          ["#D63232"; "#E46464"; "#D63232"]],
            FontCells = Font.init(Color="#FFFFFF"))
```
