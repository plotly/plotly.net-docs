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
#r "nuget: Plotly.NET, 2.0.0-preview.6"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
```

# Range of axes
 3D figures have an attribute in layout called scene, which contains attributes such as xaxis, yaxis and zaxis parameters, in order to set the range, title, ticks, color etc. of the axes.

```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET 
             
let N = 70
let rnd = System.Random()
let x = Array.init N (fun _ -> rnd.Next(-70, 100))
let y = Array.init N (fun _ -> rnd.Next(-60, 100))
let z = Array.init N (fun _ -> rnd.Next(-40, 100))
let color = "rgba(244,22,100,0.6)"

let mirroredXAxis =
    Axis.LinearAxis.init(
       
        Showline = true,
        Mirror = StyleParam.Mirror.AllTicks,
        Showgrid = true,
        Backgroundcolor ="rgb(229, 236, 246)",
        Gridcolor="white",
        Showbackground=true,
        Zerolinecolor="white"
        
    )

let mirroredLogYAxis = 
    Axis.LinearAxis.init(
      
        Showline = true,
        Mirror = StyleParam.Mirror.AllTicks,
        Showgrid = true,
        Backgroundcolor ="rgb(229, 236, 246)",
        Gridcolor="white",
        Showbackground=true,
        Zerolinecolor="white"
       
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
       
        Showline = true,
        Mirror = StyleParam.Mirror.AllTicks,
        Showgrid = true,
        Backgroundcolor ="rgb(229, 236, 246)",
        Gridcolor="white",
        Showbackground=true,
        Zerolinecolor="white"
    )

let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 700.,  Margin=margin)

let mesh3d =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <- x
            mesh3d?y <-y
            mesh3d?z <- z
            mesh3d?flatshading <- true
            mesh3d?contour <- Contours.initXyz(Show=true)
            mesh3d?color <- "rgba(244,22,100,0.6)"
            mesh3d?opacity<-0.5
            mesh3d
            )         
        |> GenericChart.ofTraceObject
        |> Chart.withX_Axis  mirroredXAxis
        |> Chart.withY_Axis  mirroredLogYAxis
        |> Chart.withZ_Axis  mirroredZAxis
        |> Chart.withX_AxisStyle ("X", MinMax = (-100.,100.))
        |> Chart.withY_AxisStyle ("Y", MinMax = (-50.,100.))
        |> Chart.withZ_AxisStyle ("Z", MinMax = (-100.,100.))
        |> Chart.withLayout layout
```

```fsharp dotnet_interactive={"language": "fsharp"}
mesh3d
```

# Set Axes Title


```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET 

                   
let N = 50
let rnd = System.Random()
let x = Array.init N (fun _ -> rnd.Next(-60, 100))
let y = Array.init N (fun _ -> rnd.Next(-25, 100))
let z = Array.init N (fun _ -> rnd.Next(-40, 100))
let color = "rgba(244,22,100,0.6)"

let mirroredXAxis =
    Axis.LinearAxis.init(
       Title="X AXIS TITLE",
       Showline = true,
        Mirror = StyleParam.Mirror.AllTicks,
        Showgrid = true,
        Backgroundcolor ="rgb(200, 200, 230)",
        Gridcolor="white",
        Showbackground=true,
        Zerolinecolor="white"
        
    )

let mirroredLogYAxis = 
    Axis.LinearAxis.init(
       Title="Y AXIS TITLE",
        Showline = true,
        Mirror = StyleParam.Mirror.AllTicks,
        Showgrid = true,
        Backgroundcolor ="rgb(200, 200, 230)",
        Gridcolor="white",
        Showbackground=true,
        Zerolinecolor="white"
       
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
        Title="Z AXIS TITLE",
        Showline = true,
        Mirror = StyleParam.Mirror.AllTicks,
        Showgrid = true,
        Backgroundcolor ="rgb(200, 200, 230)",
        Gridcolor="white",
        Showbackground=true,
        Zerolinecolor="white"
       
    )

let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 700.,  Margin=margin)

let mesh3d1 =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <- Array.init N (fun _ -> rnd.Next(-60, 100))
            mesh3d?y <- Array.init N (fun _ -> rnd.Next(-25, 100))
            mesh3d?z <- Array.init N (fun _ -> rnd.Next(-40, 100))
            mesh3d?flatshading <- true
            mesh3d?contour <- Contours.initXyz(Show=true)
            mesh3d?color <- "yellow"
            mesh3d?opacity<-0.5
            mesh3d
            )
            |> GenericChart.ofTraceObject
        
mesh3d1
```

```fsharp dotnet_interactive={"language": "fsharp"}
let mesh3d2 =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <- Array.init N (fun _ -> rnd.Next(-70, 100))
            mesh3d?y <- Array.init N (fun _ -> rnd.Next(-55, 100))
            mesh3d?z <- Array.init N (fun _ -> rnd.Next(-30, 100))
            mesh3d?flatshading <- true
            mesh3d?contour <- Contours.initXyz(Show=true)
            mesh3d?color <- "pink"
            mesh3d?opacity<-0.5
            mesh3d
            )
            |> GenericChart.ofTraceObject
     
mesh3d2

```

```fsharp dotnet_interactive={"language": "fsharp"}
let mesh3d =
        [
            mesh3d1 
            mesh3d2
        ]
        |> Chart.Combine    
        |> Chart.withX_Axis  mirroredXAxis
        |> Chart.withY_Axis  mirroredLogYAxis
        |> Chart.withZ_Axis  mirroredZAxis
        |> Chart.withLayout layout 
```

```fsharp dotnet_interactive={"language": "fsharp"}
mesh3d
```

# Ticks Formatting


```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET 

     
                   
let N = 50
let rnd = System.Random()

let ticktext = seq {"TICKS";"MESH";"PLOTLY";"PYTHON"}
let tickvals= seq{0;50;75;-50}
let mirroredXAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true,
        Ticktext =ticktext,
        Tickvals=tickvals
    )
let font = Font.init( StyleParam.FontFamily.Droid_Serif, 12.0,"green" )
let mirroredLogYAxis = 
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true,
        Tickfont=font
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
        Showspikes = false,
        Backgroundcolor ="rgb(229, 236, 246)",
        Showbackground=true,
        nTicks=4,
        Ticks=StyleParam.TickOptions.Outside ,
        Tick0=0, 
        Tickwidth=4.0
    )

let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 700.,  Margin=margin)

let mesh3d =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <-Array.init N (fun _ -> rnd.Next(-60, 100))
            mesh3d?y <- Array.init N (fun _ -> rnd.Next(-50, 100))
            mesh3d?z <-  Array.init N (fun _ -> rnd.Next(-50, 100))
            mesh3d?opacity<-0.5
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

# Background and Grid Color


```fsharp dotnet_interactive={"language": "fsharp"}
open System
open Plotly.NET 

     
                   
let N = 50
let rnd = System.Random()
let x = Array.init N (fun _ -> rnd.Next(-30, 100))
let y = Array.init N (fun _ -> rnd.Next(-25, 100))
let z = Array.init N (fun _ -> rnd.Next(-30, 100))
let color = "rgba(244,22,100,0.6)"

let mirroredXAxis =
    Axis.LinearAxis.init(
        Showline = true,
        Mirror = StyleParam.Mirror.AllTicks,
        Showgrid = true,
        Backgroundcolor ="rgb(200, 200, 230)",
        Gridcolor="white",
        Showbackground=true,
        Zerolinecolor="white"
        
    )

let mirroredLogYAxis = 
    Axis.LinearAxis.init(
        Showline = true,
        Mirror = StyleParam.Mirror.AllTicks,
        Showgrid = true,
        Backgroundcolor ="rgb(230, 200,230)",
        Gridcolor="white",
        Showbackground=true,
        Zerolinecolor="white"
       
    )
let mirroredZAxis =
    Axis.LinearAxis.init(
        Showline = true,
        Mirror = StyleParam.Mirror.AllTicks,
        Showgrid = true,
        Backgroundcolor ="rgb(230, 230,200)",
        Gridcolor="white",
        Showbackground=true,
        Zerolinecolor="white"
       
    )

let margin =Margin.init(Left =10.0, Bottom=10.0,Top =10.0, Right  = 20.0 )
let layout = Layout.init(Width= 700.,  Margin=margin)

     
let mesh3d =
        Trace3d.initMesh3d (fun mesh3d ->
            mesh3d?x <- x
            mesh3d?y <-y
            mesh3d?z <- z
            mesh3d?flatshading <- true
            mesh3d?contour <- Contours.initXyz(Show=true)
            mesh3d?opacity<-0.5
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

# Disabling tooltip spikes
By default, guidelines originating from the tooltip point are drawn. It is possible to disable this behaviour with the showspikes parameter. In this example we only keep the z spikes (projection of the tooltip on the x-y plane). Hover on the data to show this behaviour.



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
            mesh3d?x <-Array.init N (fun _ -> rnd.Next(-30, 30))
            mesh3d?y <- Array.init N (fun _ -> rnd.Next(-25, 25))
            mesh3d?z <-  Array.init N (fun _ -> rnd.Next(-30, 30))
            mesh3d?opacity<-0.5
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
