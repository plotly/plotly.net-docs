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
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
open Plotly.NET
```

# Create a Figure


```fsharp dotnet_interactive={"language": "fsharp"}
let N = 100
let rnd = System.Random()
let x = Array.init N (fun _ -> rnd.NextDouble())
let y = Array.init N (fun _ -> rnd.NextDouble())

let marker = Marker.init(Size= 30,Colorscale=StyleParam.Colorscale.Viridis);
marker?color <- x
let scatter =
  Chart.Scatter(x,y,StyleParam.Mode.Markers,Opacity=0.6)
  |> Chart.withMarker(marker)
  // |> Chart.withSize(800.,500.)

```

```fsharp dotnet_interactive={"language": "fsharp"}
scatter
```

# Write Image File


```fsharp dotnet_interactive={"language": "fsharp"}
open System.IO

let srcPath="static/images/"

if not <| Directory.Exists(srcPath) then
        Directory.CreateDirectory(srcPath) |> ignore    
```

# Raster Formats: PNG, JPEG, SVG and PDF


```fsharp dotnet_interactive={"language": "fsharp"}
let fileName = "fig1.png";
let imagePath = srcPath + fileName;
let path = Path.Combine(imagePath);
File.Create(path);
```

```fsharp dotnet_interactive={"language": "fsharp"}
let fileName = "fig1.jpeg";
let imagePath = srcPath + fileName;
let path = Path.Combine(imagePath);
File.Create(path);
```

```fsharp dotnet_interactive={"language": "fsharp"}
let fileName = "fig1.svg";
let imagePath = srcPath + fileName;
let path = Path.Combine(imagePath);
File.Create(path);
```

```fsharp dotnet_interactive={"language": "fsharp"}
let fileName = "fig1.pdf";
let imagePath = srcPath + fileName;
let path = Path.Combine(imagePath);
File.Create(path);
```

# Change Image Dimensions and Scale



In addition to the image format, we can provide arguments to specify the image width and height in logical pixels. They also provide a scale parameter that can be used to increase (scale > 1) or decrease (scale < 1) the physical resolution of the resulting image.

```fsharp dotnet_interactive={"language": "fsharp"}
let N = 100
let rnd = System.Random()
let x = Array.init N (fun _ -> rnd.NextDouble())
let y = Array.init N (fun _ -> rnd.NextDouble())

let marker = Marker.init(Size= 30,Colorscale=StyleParam.Colorscale.Viridis);
marker?color <- x
marker?scale <- 2

let scatter =
  Chart.Scatter(x,y,StyleParam.Mode.Markers)
  |>Chart.withMarker(marker)
  |> Chart.withSize(800.,500.)
  |>Chart.showAsImage(StyleParam.ImageFormat.PNG)
```

```fsharp dotnet_interactive={"language": "fsharp"}
scatter
```


