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
    description: How to make choropleth maps in F# with Plotly.
    display_as: maps
    language: fsharp
    layout: base
    name: Choropleth Maps
    order: 7
    page_type: u-guide
    permalink: fsharp/choropleth-maps/
    thumbnail: thumbnail/choropleth.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
```

A Choropleth Map is a map composed of colored polygons. It is used to represent spatial variations of a quantity. This page documents how to build outline choropleth maps, but you can also build choropleth tile maps using our Mapbox trace types.


# Base Map Configuration


# Introduction: main parameters for choropleth outline maps


Making choropleth maps requires two main types of input:

Geometry information:
This can either be a supplied GeoJSON file where each feature has either an id field or some identifying value in properties; or
one of the built-in geometries within plot_ly: US states and world countries (see below)
A list of values indexed by feature identifier.
The GeoJSON data is passed to the geojson argument, and the data is passed into the z argument of choropleth traces.

**Note** the geojson attribute can also be the URL to a GeoJSON file, which can speed up map rendering in certain cases.


# Choropleth Map Using GeoJSON

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: FSharp.Data"
#r "nuget: Newtonsoft.Json"
open FSharp.Data
open Newtonsoft.Json

#r "nuget: Deedle"
open Deedle
open System.IO
open System.Text

open Plotly.NET

let data =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",",schema="fips=string,unemp=float")

let geoJson =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json"
    |> JsonConvert.DeserializeObject

let locationsGeoJSON: string [] =
    data
    |> Frame.getCol "fips"
    |> Series.values
    |> Array.ofSeq
let zGeoJSON: int [] =
    data
    |> Frame.getCol "unemp"
    |> Series.values
    |> Array.ofSeq

Chart.ChoroplethMap(
    locations = locationsGeoJSON,
    z = zGeoJSON,
    Locationmode=StyleParam.LocationFormat.GeoJson_Id,
    GeoJson = geoJson,
    FeatureIdKey="id"
)

|> Chart.withGeo(
    Geo.init(
        Scope=StyleParam.GeoScope.NorthAmerica,
        Projection=GeoProjection.init(StyleParam.GeoProjectionType.AzimuthalEqualArea),
        ShowLand=true,

        LandColor = "lightgrey"
    )
)

|> Chart.withSize (800.,800.)


```

# Indexing by GeoJSON Properties


If the GeoJSON you are using either does not have an id field or you wish you use one of the keys in the properties field, you may use the featureidkey parameter to specify where to match the values of locations.

In the following GeoJSON object/data-file pairing, the values of properties.district match the values of the district column:

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: FSharp.Data"

open FSharp.Data

open Newtonsoft.Json

let data =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/election.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let geoJson =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/election.geojson"
    |> JsonConvert.DeserializeObject

let locationsGeoJSON: string [] =
    data
    |> Frame.getCol "district"
    |> Series.values
    |> Array.ofSeq

let zGeoJSON: int [] =
    data
    |> Frame.getCol "Bergeron"
    |> Series.values
    |> Array.ofSeq


Chart.ChoroplethMap(locations = locationsGeoJSON,
    z = zGeoJSON,
    GeoJson = geoJson,
    Colorscale= StyleParam.Colorscale.Viridis,
    FeatureIdKey="properties.district")

|> Chart.withGeoStyle(FitBounds=StyleParam.GeoFitBounds.Locations,Visible=false)
|> Chart.withColorBarStyle(Title.init("Bergeron Votes"))
|> Chart.withTitle(title="2013 Montreal Election")
|> Chart.withSize (800.,800.)
```

# Using Built-in Country and State Geometries


Plotly comes with two built-in geometries which do not require an external GeoJSON file:

USA States
Countries as defined in the Natural Earth dataset.
Note and disclaimer: cultural (as opposed to physical) features are by definition subject to change, debate and dispute. Plotly includes data from Natural Earth "as-is" and defers to the Natural Earth policy regarding disputed borders which read:


## Natural Earth Vector draws boundaries of countries according to defacto status. We show who actually controls the situation on the ground.


To use the built-in countries geometry, provide locations as three-letter ISO country codes.

```fsharp dotnet_interactive={"language": "fsharp"}
let data =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

data.Print()
```

```fsharp dotnet_interactive={"language": "fsharp"}

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

Chart.ChoroplethMap(locations=(getColumnData "CODE"),z=getColumnData "GDP (BILLIONS)",Text=getColumnData "COUNTRY",Colorscale=StyleParam.Colorscale.Bluered)
```

To use the USA States geometry, set locationmode='USA-states' and provide locations as two-letter state abbreviations

```fsharp dotnet_interactive={"language": "fsharp"}
let data =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

data?hover <- [ for k in data.RowKeys ->
                    let dataRow = (data.GetRowAt(k))
                    let state = string (dataRow |> Series.get "state")
                    let beef = string (dataRow |> Series.get "beef")
                    let dairy = string (dataRow |> Series.get "dairy")
                    let fruits = string (dataRow |> Series.get "total fruits")
                    let veggies = string (dataRow |> Series.get "total veggies")
                    let wheat = string (dataRow |> Series.get "wheat")
                    let corn = string (dataRow |> Series.get "corn")
                    String.Format(" {0} <br> Beef {1} Dairy {2} <br> Fruits {3} Veggies {4} <br> Wheat {5} Corn {6}",state, beef,dairy,fruits,veggies,wheat,corn) ]

Chart.ChoroplethMap(locations=(getColumnData "code"),z=getColumnData "total exports",Locationmode=StyleParam.LocationFormat.USA_states,Text=getColumnData "hover", Colorscale=StyleParam.Colorscale.Bluered)
```

# Customize choropleth chart

**Note** In this example we set layout.geo.scope to usa to automatically configure the map to display USA-centric data in an appropriate projection.

```fsharp dotnet_interactive={"language": "fsharp"}

Chart.ChoroplethMap(locations=(getColumnData "code"),z=getColumnData "total exports",Locationmode=StyleParam.LocationFormat.USA_states,Text=getColumnData "hover", Colorscale=StyleParam.Colorscale.Bluered)
|> Chart.withGeo(
    Geo.init(
        Scope=StyleParam.GeoScope.Usa,
        Projection=GeoProjection.init(StyleParam.GeoProjectionType.AlbersUSA),
        ShowLakes=true,
        LakeColor = "white"
    )
)
```

# World Choropleth Map

```fsharp dotnet_interactive={"language": "fsharp"}
let data =
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

Chart.ChoroplethMap(locations=(getColumnData "CODE"),z=getColumnData "GDP (BILLIONS)",Text=getColumnData "COUNTRY",Colorscale=StyleParam.Colorscale.Greens,Marker=Marker.init(Line=Line.init(Color="grey",Width=0.5)))
|> Chart.withColorBarStyle(title=Title.init("GDP Billions US$"))
|> Chart.withTitle(title="2014 Global GDP<br>Source:<a href=\"https://www.cia.gov/library/publications/the-world-factbook/fields/2195.html\">CIA World Factbook</a>")
|> Chart.withGeo(
    Geo.init(
        Projection=GeoProjection.init(StyleParam.GeoProjectionType.Mercator),
        ShowCoastLines=false,
        ShowFrame=false
    )
)
```
