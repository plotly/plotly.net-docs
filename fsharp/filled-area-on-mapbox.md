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
    description: How to make an area on Map F# with Plotly.
    display_as: maps
    language: fsharp
    layout: base
    name: Filled Area on Maps
    order: 3
    page_type: u-guide
    permalink: fsharp/filled-area-on-mapbox/
    thumbnail: thumbnail/area.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,2.0.0-preview.8"
```

# Mapbox Access Token and Base Map Configuration
To plot on Mapbox maps with Plotly you may need a Mapbox account and a public <a href="https://www.mapbox.com/studio">Mapbox Access Token</a>.

There are three different ways to show a filled area in a Mapbox map:

1. Use a Scattermapbox trace and set fill attribute to 'ToSelf'
2. Use a Mapbox layout (i.e. by minimally using an empty Scattermapbox trace) and add a GeoJSON layer
3. Use the Choroplethmapbox trace type


# Filled Scattermapbox Trace

The following example uses Scattermapbox and sets fill = 'ToSelf'

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

Chart.ScatterMapbox(
    longitudes = [ -74; -70; -70; -74 ],
    latitudes = [ 47; 47; 45; 45 ],
    Fill = StyleParam.Fill.ToSelf,
    mode = StyleParam.Mode.Lines_Markers
)
|> Chart.withMarkerStyle (Size = 10, Color = Color.fromString "orange")
|> Chart.withMarginSize (Left = 0, Right = 0, Top = 0, Bottom = 0)
|> Chart.withMapbox (Mapbox.init (Center = (-73., 46.), Style = StyleParam.MapboxStyle.StamenTerrain, Zoom = 5.))

```

# Multiple Filled Areas with a Scattermapbox trace

The following example shows how to use NaN in your data to draw multiple filled areas. Such gaps in trace data are unconnected by default, but this can be controlled via the connectgaps attribute.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

Chart.ScatterMapbox(
    longitudes = [ -10.; -10.; 8.; 8.; -10.; Double.NaN; 30.; 30.; 50.; 50.; 30.; Double.NaN; 100.; 100.; 80.; 80.; 100. ],
    latitudes = [ 30.; 6.; 6.; 30.; 30.;    Double.NaN; 20.; 30.; 30.; 20.; 20.; Double.NaN; 40.; 50.; 50.; 40.; 40.],
    Fill = StyleParam.Fill.ToSelf,
    mode = StyleParam.Mode.Lines_Markers
)
|> Chart.withMarginSize (Left = 0, Right = 0, Top = 0, Bottom = 0)
|> Chart.withMapbox (Mapbox.init (Center = (30., 30.), Style = StyleParam.MapboxStyle.StamenTerrain, Zoom = 2.))

```

# GeoJSON Layers
In this map we add a GeoJSON layer.

```fsharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Plotly.NET.LayoutObjects

let coorindates = [(-73.606352888, 45.507489991); (-73.606133883, 45.50687600);
                            (-73.605905904, 45.506773980); (-73.603533905, 45.505698946);
                            (-73.602475870, 45.506856969); (-73.600031904, 45.505696003);
                            (-73.599379992, 45.505389066); (-73.599119902, 45.505632008);
                            (-73.598896977, 45.505514039); (-73.598783894, 45.505617001);
                            (-73.591308727, 45.516246185); (-73.591380782, 45.516280145);
                            (-73.596778656, 45.518690062); (-73.602796770, 45.521348046);
                            (-73.612239983, 45.525564037); (-73.612422919, 45.525642061);
                            (-73.617229085, 45.527751983); (-73.617279234, 45.527774160);
                            (-73.617304713, 45.527741334); (-73.617492052, 45.527498362);
                            (-73.617533258, 45.527512253); (-73.618074188, 45.526759105);
                            (-73.618271651, 45.526500673); (-73.618446320, 45.526287943);
                            (-73.618968507, 45.525698560); (-73.619388002, 45.525216750);
                            (-73.619532966, 45.525064183); (-73.619686662, 45.524889290);
                            (-73.619787038, 45.524770086); (-73.619925742, 45.524584939);
                            (-73.619954486, 45.524557690); (-73.620122362, 45.524377961);
                            (-73.620201713, 45.524298907); (-73.620775593, 45.523650879)]

let layers =
    MapboxLayer.init (
        SourceType = StyleParam.MapboxLayerSourceType.Vector,
        Type = StyleParam.MapboxLayerType.Fill,
        Coordinates = coorindates,
        Below = "traces",
        Color = Color.fromString "royalblue"
    )

let mapBox =
    Mapbox.init (
        Center = (-73.605, 45.51),
        Style = StyleParam.MapboxStyle.StamenTerrain,
        Zoom = 12.,
        Layers = [ layers ]
    )

Chart.ScatterMapbox(longitudes = [ -73.605 ], latitudes = [ 45.51 ], mode = StyleParam.Mode.Markers)
|> Chart.withMarkerStyle (Size = 20, Color = Color.fromString "cyan")
|> Chart.withMarginSize (Left = 0, Right = 0, Top = 0, Bottom = 0)
|> Chart.withMapbox mapBox


```
