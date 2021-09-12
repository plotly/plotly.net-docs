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
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
#r "nuget: FSharp.Stats"
#r "nuget: Deedle"

```

# Basic linear regression plots

```csharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data
open FSharp.Stats
open FSharp.Stats.Fitting.LinearRegression
open Plotly.NET

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/tips.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")
    

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let y = vector <| getColumnData "tip"
let x = vector <| getColumnData "total_bill"

let coefs = OrdinaryLeastSquares.Linear.Univariable.coefficient x y
let fittinFunc x= OrdinaryLeastSquares.Linear.Univariable.fit coefs x

let xRange = [for i in Seq.min(x)..Seq.max(x) -> i]
let yPredicted = [for x in xRange -> fittinFunc x]

let xy = Seq.zip xRange yPredicted
[
    Chart.Point(x,y,Showlegend=true,Name="Tips")
    |> Chart.withXAxisStyle(title="total_bill")
    |> Chart.withYAxisStyle(title="tip");

    Chart.Line(xy,Showlegend=true,Name="Regression Fit")
]
|> Chart.combine


```

# Model generalization on unseen data

```csharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data
open FSharp.Stats
open FSharp.Stats.Fitting
open FSharp.Stats.Fitting.LinearRegression
open Plotly.NET

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/tips.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")
    

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let y = vector <| getColumnData "tip"
let x = vector <| getColumnData "total_bill"

let splitPercetage = 0.2
let n = x.NumRows
let m = float n * splitPercetage |> ceil |> int

let chunkIndices =
                [|0 .. n-1|]
                |> FSharp.Stats.Array.shuffleFisherYates
                |> Array.take m

let xTest,xTrain = x |> Vector.splitVector chunkIndices
let yTest,yTrain = y |> Vector.splitVector chunkIndices

let coefs = OrdinaryLeastSquares.Linear.Univariable.coefficient xTrain yTrain
let fittinFunc x= OrdinaryLeastSquares.Linear.Univariable.fit coefs x

let xRange = [for i in Seq.min(x)..((Seq.max(x)-Seq.min(x))/100.)..Seq.max(x) -> i]
let yPredicted = [for x in xRange -> fittinFunc x]

let xy = Seq.zip xRange yPredicted

[
    Chart.Point(xTrain,yTrain,Showlegend=true,Name="train")
    |> Chart.withXAxisStyle(title="total_bill")
    |> Chart.withYAxisStyle(title="tip");

    Chart.Point(xTest,yTest,Showlegend=true,Name="test")

    Chart.Line(xy,Showlegend=true,Name="Regression Fit")
]
|> Chart.combine
```

# Comparing different models parameters

```csharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data
open FSharp.Stats
open FSharp.Stats.Fitting.LinearRegression
open Plotly.NET

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/tips.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")
    

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let y = vector <| getColumnData "tip"
let x = vector <| getColumnData "total_bill"

let order = 5

let coefs = OrdinaryLeastSquares.Polynomial.coefficient order x y
let fittinFunc x= OrdinaryLeastSquares.Polynomial.fit order coefs x

let xRange = [for i in Seq.min(x)..((Seq.max(x)-Seq.min(x))/100.)..Seq.max(x) -> i]
let yPredicted = [for x in xRange -> fittinFunc x]

let weights = y |> Vector.map (fun y -> 1. / y)
let coefsWeighted = OrdinaryLeastSquares.Polynomial.coefficientsWithWeighting order weights x y
let fittingWeightedFunc x= OrdinaryLeastSquares.Polynomial.fit order coefsWeighted x

let yPredictedWeighted = [for x in xRange -> fittingWeightedFunc x]

let xy = Seq.zip xRange yPredicted
let xyWeighted = Seq.zip xRange yPredictedWeighted
[
    Chart.Point(x,y,Showlegend=true,Name="Tips")
    |> Chart.withXAxisStyle(title="total_bill")
    |> Chart.withYAxisStyle(title="tip");

    Chart.Line(xy,Showlegend=true,Name="Polynomial Fit");
    Chart.Line(xyWeighted,Showlegend=true,Name="Weighted Polynomial Fit")
]
|> Chart.combine

```

# 3D regression surface

```csharp dotnet_interactive={"language": "fsharp"}
#r "nuget:libsvm.net"
```

```csharp dotnet_interactive={"language": "fsharp"}
open libsvm
open System.Collections.Generic

open Deedle
open FSharp.Data
open FSharp.Stats
open FSharp.Stats.Fitting
open FSharp.Stats.Fitting.NonLinearRegression
open Plotly.NET

open libsvm

type DataPoint={
    SepalWidth:float
    SepalLength:float
    PetalWidth : float
}

let linspace (min,max,n) = 
    if n <= 2 then failwithf "n needs to be larger then 2"
    let bw = float (max - min) / (float n - 1.0)
    Array.init n (fun i -> min + (bw * float i))

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/iris.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let petalWidth= getColumnData "PetalWidth"
let sepalWidth = getColumnData "SepalWidth"
let sepalLength = getColumnData "SepalLength"

let xData = Array.map3 (fun x y z-> {SepalWidth=x;SepalLength=y;PetalWidth=z})  sepalWidth sepalLength petalWidth

let features = [|for x in xData -> new List<float>([|x.PetalWidth; x.SepalWidth;x.SepalLength|]) |]


let X = new List<List<float>>(features)

let xRange = linspace(Seq.min(sepalWidth),Seq.max(sepalWidth),100)
let yRange = linspace(Seq.min(sepalLength),Seq.max(sepalLength),100)

let xyz = Array.zip3 sepalWidth sepalLength petalWidth


let gamma = 1.0
let C= 1.
let epsilon = 0.1

let prob = ProblemHelper.ReadProblem(X)

let svm = new Epsilon_SVR(prob, KernelHelper.RadialBasisFunctionKernel(gamma), C, epsilon)

let z = Array.map (fun y -> Array.map (fun x -> svm.Predict([|new svm_node(index=1,value=x);new svm_node(index=2,value=y)|])) xRange) yRange 

[
Chart.Surface(X=xRange,Y=yRange, zData=z);
Chart.Point3d(xyz=xyz)
|> Chart.withXAxisStyle(title="Sepal Width",Id=StyleParam.SubPlotId.Scene 1)
|> Chart.withYAxisStyle(title="Sepal Length",Id=StyleParam.SubPlotId.Scene 1)
|> Chart.withZAxisStyle(title="Petal Width")
|> Chart.withMarkerStyle(Size=5)
|> Chart.withSize(width=1100.,height=700.)]
|> Chart.combine


```

# Simple actual vs predicted plot

```csharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data
open FSharp.Stats
open FSharp.Stats.Fitting
open FSharp.Stats.Fitting.NonLinearRegression
open Plotly.NET

let linspace (min,max,n) = 
    if n <= 2 then failwithf "n needs to be larger then 2"
    let bw = float (max - min) / (float n - 1.0)
    Array.init n (fun i -> min + (bw * float i))

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/iris.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let petalWidth= getColumnData "PetalWidth"
let sepalWidth = getColumnData "SepalWidth"
let sepalLength = getColumnData "SepalLength"

let xData = Array.map2 (fun x y -> [|x;y|]) sepalWidth sepalLength
let X =  xData |> Matrix.ofJaggedArray
let Y = vector petalWidth 
let coefs = OrdinaryLeastSquares.Linear.Multivariable.coefficients X Y
let fittinFunc x= OrdinaryLeastSquares.Linear.Multivariable.fit coefs x

let YPredicted = [|for x in xData -> fittinFunc (vector x) |]

let xy = Array.zip petalWidth YPredicted

let yMin = Array.min(petalWidth)
let yMax = Array.max(petalWidth)

let labels = xy |> Array.map (fun item -> $"Ground Truth:{fst item} </br>Prediction: {snd item}")

Chart.Point(xy,Labels=labels,Color="orange")
|> Chart.withSize(width=1100.,height=700.)
|> Chart.withShape(Shape.init(ShapeType=StyleParam.ShapeType.Line,X0=yMin,Y0=yMin,X1=yMax,Y1=yMax,Line=Line.init(Dash=StyleParam.DrawingStyle.Dash)))
```

# Enhanced prediction error analysis (Not finished)

```csharp dotnet_interactive={"language": "fsharp"}
open Plotly.NET
let values = [1; 2; 3;]
let keys   = ["Product A"; "Product B"; "Product C";]

let x = [for i in 0..10 -> i]
let y = [for i in x -> 2*i*i+3*i+5]

Chart.Histogram(x,Orientation=StyleParam.Orientation.Horizontal)

// [

// Chart.Point(x,y)
// ]
// |> Chart.SingleStack(Pattern= StyleParam.LayoutGridPattern.Coupled)
// |> Chart.withLayoutGridStyle(YGap= 0.1)
// |> Chart.withTitle("Hi i am the new SingleStackChart")
// |> Chart.withXAxisStyle("im the shared xAxis")
```

# Residual Plots

```csharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data
open FSharp.Stats
open FSharp.Stats.Fitting
open FSharp.Stats.Fitting.NonLinearRegression
open Plotly.NET


let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/iris.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let petalWidth= getColumnData "PetalWidth"
let sepalWidth = getColumnData "SepalWidth"
let sepalLength = getColumnData "SepalLength"

let splitPercetage = 0.2
let n = sepalWidth.Length
let m = float n * splitPercetage |> ceil |> int

let chunkIndices =
                [|0 .. n-1|]
                |> FSharp.Stats.Array.shuffleFisherYates
                |> Array.take m

let xData = Array.map2 (fun x y -> [|x;y|]) sepalWidth sepalLength
let Y = vector petalWidth 

let X =  xData |> Matrix.ofJaggedArray

let xTest,xTrain = Matrix.splitRows chunkIndices X
let yTest,yTrain = (vector Y) |> Vector.splitVector chunkIndices

let fittinFunc X Y x= 
    let coefs = OrdinaryLeastSquares.Linear.Multivariable.coefficients X Y
    OrdinaryLeastSquares.Linear.Multivariable.fit coefs x

let fittingLinearFunc X Y x=
    let coef = OrdinaryLeastSquares.Linear.Univariable.coefficient X Y
    OrdinaryLeastSquares.Linear.Univariable.fit coef x

let fittingFuncTrain = fittinFunc xTrain yTrain
let fittingFuncTest = fittinFunc xTest yTest

let yTrainPredicted = [|for x in Matrix.toJaggedArray xTrain -> fittingFuncTrain (vector <| x) |]
let residualTrain = yTrainPredicted |> Array.mapi (fun i x -> x - yTrain.[i])

let yTestPredicted = [|for x in (Matrix.toJaggedArray xTest) -> fittingFuncTest (vector <| x) |]
let residualTest = yTestPredicted |> Array.mapi (fun i x -> x - yTest.[i])


let xTrend = Array.concat [yTrainPredicted;yTestPredicted]
let fittingTrend = fittingLinearFunc (vector xTrend) (vector (Array.concat [residualTrain;residualTest]))
let yTrend = xTrend |> Array.map (fun x -> fittingTrend x)

let violinChart =   [
                        Chart.Violin(y=residualTrain,Name="Train",Showlegend=false);
                        Chart.Violin(y=residualTest,Name="Test",Showlegend=false);
                    ]
                    |>Chart.combine

let scatterPlot =   [
                        Chart.Point(yTrainPredicted,residualTrain,Name="Train");
                        Chart.Point(yTestPredicted,residualTest,Name="Test");
                        Chart.Line(xTrend,yTrend,Showlegend=false);
                    ]
                    |>Chart.combine
                    |>Chart.withXAxisStyle(title="Prediction")
                    |>Chart.withYAxisStyle(title="Residual");

[
scatterPlot;
violinChart
]
|>
Chart.Grid(1,2)
|> Chart.withSize(1100.,700.)

```
