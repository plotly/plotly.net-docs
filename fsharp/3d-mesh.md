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
    description: How to format axes of 3D Mesh plots in F# with Plotly.
    display_as: 3d_charts
    language: fsharp
    layout: base
    name: 3D Mesh Plots
    order: 9
    page_type: u-guide
    permalink: fsharp/3d-mesh/
    thumbnail: thumbnail/3d-mesh.jpg
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open System
open Plotly.NET
```

# Simple 3D Mesh example


```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET


let N = 50
let rnd = System.Random()

let mirroredXAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let mirroredLogYAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 700.,  Margin=margin)


let mesh3d =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <- Array.init 100 (fun _ -> rnd.NextDouble())
            mesh3d?y <-Array.init 100 (fun _ -> rnd.NextDouble())
            mesh3d?z <-Array.init 100 (fun _ -> rnd.NextDouble())
            mesh3d?opacity<-0.5
            mesh3d?color <- "lightpink"
            mesh3d
            )
        |> GenericChart.ofTraceObject
        |> Chart.withX_Axis  mirroredXAxis
        |> Chart.withY_Axis  mirroredLogYAxis
        |> Chart.withZ_Axis  mirroredZAxis
        |> Chart.withLayout layout
```

```fsharp dotnet_interactive={"language": "fsharp"}
mesh3d
```

# 3D Mesh example with Alphahull

```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET


let N = 50
let rnd = System.Random()

let mirroredXAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let mirroredLogYAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 700.,  Margin=margin)


let mesh3d =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <- Array.init 100 (fun _ -> rnd.NextDouble())
            mesh3d?y <-Array.init 100 (fun _ -> rnd.NextDouble())
            mesh3d?z <-Array.init 100 (fun _ -> rnd.NextDouble())
            mesh3d?opacity<-0.5
            mesh3d?alphahull <- 5
            mesh3d?color <- "cyan"
            mesh3d
            )
        |> GenericChart.ofTraceObject
        |> Chart.withX_Axis  mirroredXAxis
        |> Chart.withY_Axis  mirroredLogYAxis
        |> Chart.withZ_Axis  mirroredZAxis
        |> Chart.withLayout layout
```

```fsharp dotnet_interactive={"language": "fsharp"}
mesh3d
```

# 3D Mesh Tetrahedron

*Summary:* In this example we use the i, j and k parameters to specify manually the geometry of the triangles of the mesh.

```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET


let N = 50
let rnd = System.Random()

let mirroredXAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let mirroredLogYAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 700.,  Margin=margin)
let customColorscale = StyleParam.Colorscale.Custom [(0.0,"gold");(0.5,"mediumturquoise");(1.0,"magenta")]
let marker = Marker.init(Colorscale=StyleParam.Colorscale.Viridis, Showscale=true);
marker?color <-customColorscale;


let mesh3d =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <-seq{0; 1; 2; 0}
            mesh3d?y <-seq{0; 0; 1; 2}
            mesh3d?z <-seq{0; 2; 0; 1}
            mesh3d?i<- seq{0; 0; 0; 1}
            mesh3d?j<-seq{1; 2; 3; 2}
            mesh3d?k<-seq{2; 3; 1; 3}
            mesh3d?opacity<-0.5
            //mesh3d?colors <-customColorscale
            mesh3d?colorscale <- StyleParam.Colorscale.Custom (seq<float*string> {(1.0,"gold");(0.5,"mediumturquoise");(1.0,"magenta")})
            mesh3d?intensity<-seq{0.; 0.33; 0.66; 1.}
            mesh3d?showscale  <- true
            mesh3d
            )
        |> GenericChart.ofTraceObject
        |> Chart.withX_Axis  mirroredXAxis
        |> Chart.withY_Axis  mirroredLogYAxis
        |> Chart.withZ_Axis  mirroredZAxis
        |> Chart.withLayout layout
        |> Chart.withMarker marker

```

```fsharp dotnet_interactive={"language": "fsharp"}
mesh3d

```

#  Mesh Cube


```fsharp dotnet_interactive={"language": "fsharp"}
let size = 100
let rnd = System.Random()

let linspace (min,max,n) =
    if n <= 2 then failwithf "n needs to be larger then 2"
    let bw = float (max - min) / (float n - 1.)
    Array.init n (fun i -> min + (bw * float i))

let x = linspace(-2. * Math.PI, 2. * Math.PI, size)
let y = linspace(-2. * Math.PI, 2. * Math.PI, size)

let f x y = - (5. * x / (x**2. + y**2. + 1.) )

let z =
    Array.init size (fun i ->
        Array.init size (fun j ->
            f x.[j] y.[i]
        )
    )

let mirroredXAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let mirroredLogYAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 700.,  Margin=margin)

let meshcube3d =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <-seq{0; 0; 1; 1; 0; 0; 1; 1}
            mesh3d?y <-seq{0; 1; 1; 0; 0; 1; 1; 0}
            mesh3d?z <-seq{0; 0; 0; 1; 1; 1; 1; 1}
            mesh3d?i<- seq{7; 0; 0; 0; 4; 4; 6; 6; 4; 0; 3; 2}
            mesh3d?j<-seq{3; 4; 1; 2; 5; 6; 5; 2; 0; 1; 6; 3}
            mesh3d?k<-seq{0; 7; 2; 3; 6; 7; 1; 1; 5; 5; 7; 6}
            mesh3d?opacity<-0.5
            mesh3d?colorscale <- StyleParam.Colorscale.Custom (seq<float*string> {(1.0,"gold");(0.5,"mediumturquoise");(1.0,"magenta")})
            mesh3d?intensity<- seq{ 0.1 ;  0.1;  0.2;  0.3;  0.4;  0.5;  0.6;  0.8 }
            mesh3d?showscale  <- true
            //mesh3d?Intensityscr <-"cell"
            mesh3d
            )
        |> GenericChart.ofTraceObject
        |> Chart.withX_Axis  mirroredXAxis
        |> Chart.withY_Axis  mirroredLogYAxis
        |> Chart.withZ_Axis  mirroredZAxis
        |> Chart.withLayout layout
```

```fsharp dotnet_interactive={"language": "fsharp"}
meshcube3d
```

# Intensity values defined on vertices or cells


```fsharp dotnet_interactive={"language": "fsharp"}
let size = 100
let rnd = System.Random()

let linspace (min,max,n) =
    if n <= 2 then failwithf "n needs to be larger then 2"
    let bw = float (max - min) / (float n - 1.)
    Array.init n (fun i -> min + (bw * float i))

let x = linspace(-2. * Math.PI, 2. * Math.PI, size)
let y = linspace(-2. * Math.PI, 2. * Math.PI, size)

let f x y = - (5. * x / (x**2. + y**2. + 1.) )

let z =
    Array.init size (fun i ->
        Array.init size (fun j ->
            f x.[j] y.[i]
        )
    )

let mirroredXAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let mirroredLogYAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true
    )

let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 700.,  Margin=margin)

let meshcube3d =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <-seq{0; 0; 1; 1; 0; 0; 1; 1}
            mesh3d?y <-seq{0; 1; 1; 0; 0; 1; 1; 0}
            mesh3d?z <-seq{0; 0; 0; 1; 1; 1; 1; 1}
            mesh3d?i<- seq{7; 0; 0; 0; 4; 4; 6; 6; 4; 0; 3; 2}
            mesh3d?j<-seq{3; 4; 1; 2; 5; 6; 5; 2; 0; 1; 6; 3}
            mesh3d?k<-seq{0; 7; 2; 3; 6; 7; 1; 1; 5; 5; 7; 6}
            mesh3d?opacity<-0.5
            mesh3d?colorscale <- StyleParam.Colorscale.Custom (seq<float*string> {(1.0,"gold");(0.5,"mediumturquoise");(1.0,"magenta")})
            mesh3d?intensity<- seq{ 0.1 ;  0.1;  0.2;  0.3;  0.4;  0.5;  0.6;  0.8 }
            mesh3d?showscale  <- true
           // mesh3d?Intensityscr <-"cell"
            mesh3d?intensitymode <-"cell"
            mesh3d
            )
        |> GenericChart.ofTraceObject
        |> Chart.withX_Axis  mirroredXAxis
        |> Chart.withY_Axis  mirroredLogYAxis
        |> Chart.withZ_Axis  mirroredZAxis
        |> Chart.withLayout layout
```

```fsharp dotnet_interactive={"language": "fsharp"}
meshcube3d
```
