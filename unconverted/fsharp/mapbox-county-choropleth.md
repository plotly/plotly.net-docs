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
#r "nuget: Plotly.NET,*-*"
#r "nuget: Plotly.NET.Interactive,*-*"
#r "nuget: FSharp.Data"
#r "nuget:Deedle"
#r "nuget:Newtonsoft.Json"
```

# Introduction: main parameters for choropleth tile maps


Making choropleth Mapbox maps requires two main types of input:

GeoJSON-formatted geometry information where each feature has either an id field or some identifying value in properties.
A list of values indexed by feature identifier.


## GeoJSON with feature.id


Here we load a GeoJSON file containing the geometry information for US counties, where feature.id is a FIPS code.

```csharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data

type jsonProvider = JsonProvider<"https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json">

let counties = jsonProvider.Load("https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json")

counties.Features.[0].Id

```

## Data indexed by id


Here we load unemployment data by county, also indexed by FIPS code.

```csharp dotnet_interactive={"language": "fsharp"}
type csvProvider = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv">

let fips_data = csvProvider.Load("https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv")

printf "%A" fips_data.Headers
fips_data.Rows |> Seq.take 5
```

# Mapbox Choropleth Map Using GeoJSON


With choroplethmapbox, each row of the DataFrame is represented as a region of the choropleth.

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Newtonsoft.Json

let geoJson = 
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json"
    |> JsonConvert.DeserializeObject 

type csvProvider = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv">

let fips_data = csvProvider.Load("https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv")

let z = fips_data.Rows |> Seq.map (fun row -> float row.Unemp)
let locations = fips_data.Rows |> Seq.map (fun row -> row.Fips)

Chart.ChoroplethMapbox(z=z,geoJson=geoJson,locations=locations,FeatureIdKey="id",Colorscale=StyleParam.Colorscale.Viridis,ZMin=0.,ZMax=12.)
|> Chart.withMapbox(
        Mapbox.init(Style=StyleParam.MapboxStyle.CartoPositron,Zoom=3.,Center=(-95.7129,37.0902)) 
    )
|> Chart.withSize(width=1100.,height=700.)
```

# Indexing by GeoJSON Properties


If the GeoJSON you are using either does not have an id field or you wish you use one of the keys in the properties field, you may use the featureidkey parameter to specify where to match the values of locations.

In the following GeoJSON object/data-file pairing, the values of properties.district match the values of the district column:

```csharp dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Deedle
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

Chart.ChoroplethMapbox(
    locations = locationsGeoJSON,
    z = zGeoJSON,    
    geoJson = geoJson,
    Colorscale= StyleParam.Colorscale.Cividis,
    FeatureIdKey="properties.district")
 
|> Chart.withMapbox(
        Mapbox.init(Style=StyleParam.MapboxStyle.CartoPositron,Zoom=9.,Center=(-73.7073,45.5517)) 
    )
|> Chart.withColorBarStyle(Title.init(Text="Bergeron Votes"))
|> Chart.withTitle(title="2013 Montreal Election")
|> Chart.withSize (800.,800.)
```

# Mapbox Light base map: free token needed

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
open Newtonsoft.Json

let token = File.ReadAllText("mapbox_token") //# you will need your own token
let geoJson = 
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json"
    |> JsonConvert.DeserializeObject 

type csvProvider = CsvProvider<"https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv">

let fips_data = csvProvider.Load("https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv")

let z = fips_data.Rows |> Seq.map (fun row -> float row.Unemp)
let locations = fips_data.Rows |> Seq.map (fun row -> row.Fips)

Chart.ChoroplethMapbox(z=z,geoJson=geoJson,locations=locations,FeatureIdKey="id",Colorscale=StyleParam.Colorscale.Viridis,ZMin=0.,ZMax=12.)
|> Chart.withMapbox(
        Mapbox.init(Style=StyleParam.MapboxStyle.MapboxLight,Zoom=3.,Center=(-95.7129,37.0902),AccessToken=token) 
    )
|> Chart.withSize(width=1100.,height=700.)
```