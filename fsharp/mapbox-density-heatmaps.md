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
    description: How to make a Mapbox Density Heatmap in F# with Plotly.
    display_as: maps
    language: fsharp
    layout: base
    name: Mapbox Density Heatmap
    order: 5
    page_type: u-guide
    permalink: fsharp/mapbox-density-heatmaps/
    thumbnail: thumbnail/mapbox-density.png
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,2.0.0-preview.8"
#r "nuget: FSharp.Data"
```

# Mapbox Access Token and Base Map Configuration
To plot on Mapbox maps with Plotly you may need a Mapbox account and a public <a href="https://www.mapbox.com/studio">Mapbox Access Token</a>.


# Stamen Terrain base map (no token needed): density mapbox with Plotly.NET

```fsharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Plotly.NET
open Plotly.NET.LayoutObjects

let data = CsvFile.Load("https://raw.githubusercontent.com/plotly/datasets/master/earthquakes-23k.csv")

let latitudes = data.Rows |> Seq.map (fun row -> row.GetColumn("Latitude"))
let longitudes = data.Rows |> Seq.map (fun row -> row.GetColumn("Longitude"))
let magnitudes = data.Rows |> Seq.map (fun row -> row.GetColumn("Magnitude"))

let lonlat = Seq.zip longitudes latitudes

Chart.DensityMapbox(lonlat=lonlat,Z=magnitudes,Radius=10.,Colorscale=StyleParam.Colorscale.Viridis)
|> Chart.withMapbox(Mapbox.init(Style=StyleParam.MapboxStyle.StamenTerrain))
|> Chart.withMarginSize (Left = 0, Right = 0, Top = 0, Bottom = 0)
```
