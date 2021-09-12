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
#r "nuget: newtonsoft.json"
#r "nuget: Plotly.NET.Interactive, 2.0.0-preview.6"
open Plotly.NET
```

# Text on scatter plots with Graph Objects


```fsharp dotnet_interactive={"language": "fsharp"}
let x=[|0; 1; 2;|]
[
Chart.Scatter(x,[|1; 1; 1|], StyleParam.Mode.Lines, Name="Lines, Markers and Text")
// |> GenericChart.mapTrace(fun x -> 
//         x.SetValue("text",[
//              "Text A";
//              "Text B";
//              "Text C";
//              ])   
//         x)
Chart.Scatter(x,[|2; 2; 2; 1|], StyleParam.Mode.Lines,Name="Markers and Text")
 ]
|> Chart.Combine
```

# Text Annotations


```fsharp dotnet_interactive={"language": "fsharp"}
let x=[|0;1; 2; 3; 4; 5;6;7;8;|]
let layout =
    let temp = Layout()
    temp?annotations <- [{|text = "Text annotation with arrow"; x = 2; y = 5;showarrow = true; arrowhead = 1|};
                          {|text = "Text annotation without arrow"; x = 4; y = 4; showarrow = false ; arrowhead = 1|}]
    temp
[
Chart.Scatter(x,[|0; 1; 3; 2; 4; 3; 4; 6; 5|], StyleParam.Mode.Lines, Showlegend=false)

Chart.Scatter(x,[|0; 4; 5; 1; 2; 2; 3; 4; 2|], StyleParam.Mode.Lines, Showlegend=false)
]
|> Chart.Combine
|> Chart.withLayout(layout)


```

# 3D Annotations


```fsharp dotnet_interactive={"language": "fsharp"}
let x=["2017-01-01"; "2017-02-10"; "2017-03-20"]
let y=["A"; "B"; "C"]
let z=[1; 1000; 100000]

let layout =
    let temp = Layout()
    temp?annotations <- [{|text = "Point 1";
                         x = "2017-01-01";
                         y = "A";
                         z = 0; 
                        showarrow = false;
                        arrowcolor="";
                        arrowsize=0;
                        arrowwidth=0;
                        arrowhead=0;
                        xanchor="left";
                        yanchor="";
                        xshift=10;
                        opacity=0.7|};

                        {|text = "Point 2"; 
                        x = "2017-02-10"; 
                        y = "B";
                        z = 4; 
                        showarrow = true;
                        arrowcolor="black";
                        arrowsize=3;
                        arrowwidth=1;
                        arrowhead=1;
                        xanchor="";
                        yanchor=""; 
                        xshift=0;
                        opacity=0.7 |};
                        
                        {|text = "Point 3";
                        x = "2017-03-20";
                        y = "C";
                        z = 5;  
                        showarrow = true;
                        arrowcolor="black";
                        arrowsize=3;
                        arrowwidth=1;
                        arrowhead=1;
                        xanchor="left";
                        yanchor="bottom";
                        xshift=0;
                        opacity=0.7|};
                        ]
    temp                    // Issue to set arrow position on plots

Chart.Scatter3d(x,y,z,StyleParam.Mode.Lines,Name="z")

|> Chart.withLayout(layout)
```

# Customize Displayed Text with a Text Template


```fsharp dotnet_interactive={"language": "fsharp"}
let labels = ["Wages"; "Operating expenses"; "Cost of sales"; "Insurance"]
let values = [40000000; 20000000; 30000000; 10000000]

let layout = 
    let temp = Layout()
    temp?hoverinfo <- "label+percent"
    temp?textinfo <- "value"
    temp?textfont_size <- 20
    temp

Chart.Pie(values=values,Labels=labels)  // Issue with values + percent displaying
|> Chart.withLayout(layout)
```

# Text Font as an Array - Styling Each Text Element


```fsharp dotnet_interactive={"language": "fsharp"}
let lat=[45.5; 43.4; 49.13; 51.1; 53.34; 45.24; 44.64; 48.25; 49.89; 50.45]
let lon=[-73.57; -79.24; -123.06; -114.1; -113.28; -75.43; -63.57; -123.21; -97.13;104.6]
let states=["Montreal"; "Toronto"; "Vancouver"; "Calgary"; "Edmonton"; "Ottawa"; "Halifax";
          "Victoria"; "Winnepeg"; "Regina"]

let colors=["MidnightBlue"; "IndianRed"; "MediumPurple"; "Orange"; "Crimson";
            "LightSeaGreen"; "RoyalBlue"; "LightSalmon"; "DarkOrange"; "MediumSlateBlue"]

let textposition=["top center"; "middle left"; "top center"; "bottom center";
                  "top right";
                  "middle left"; "bottom right"; "bottom left"; "top right";
                  "top right"]
let N = 30
let rnd = System.Random()
let lataxis = Array.init N (fun _ -> rnd.Next(40, 70))
let lonaxis = Array.init N (fun _ -> rnd.Next(-130, -55))


let marker = Marker.init();
marker?color <- colors
marker?size <- 20

let layout =  
    let temp = Layout()   // Some circumvent
    temp?textposition <- textposition   //  Issue with lataxis and lonaxis
    temp?lataxis <- lataxis 
    temp?lonaxis <- lonaxis 
    temp?textposition <- textposition 
    temp

Chart.ScatterGeo(lat,lon,StyleParam.Mode.Markers_Text,Labels=states)
|> Chart.withTitle(title="Canadian cities")
|> Chart.withMarker(marker)
|> Chart.withLayout(layout)

```

# Set Date in Text Template


```fsharp dotnet_interactive={"language": "fsharp"}

```

```fsharp dotnet_interactive={"language": "fsharp"}
let x0 = [100; 60; 40; 20]
let x1 =[90; 70; 50; 10]
let y = ["2018-01-01"; "2018-07-01"; "2019-01-01"; "2020-01-01"]

[   
Chart.Funnel(x0,y,Name="Montreal",Orientation=StyleParam.Orientation.Horizontal,Color="rgba(103, 102, 255,1)" )
Chart.Funnel(x1,y,Name="Vancouver",Orientation=StyleParam.Orientation.Horizontal,Color="rgba(255, 70, 51, 1)" )
]
|> Chart.Combine
//|> Chart.withLayout(layout)
```
