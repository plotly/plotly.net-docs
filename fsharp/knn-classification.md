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
    description: Visualize scikit-learn's k-Nearest Neighbors (kNN) classification
      in F# with Plotly.
    display_as: ai_ml
    language: fsharp
    layout: base
    name: kNN Classification
    order: 2
    page_type: u-guide
    permalink: fsharp/knn-classification/
    thumbnail: thumbnail/knn-classification.png
---

```fsharp dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET, *-*"
#r "nuget: Plotly.NET.Interactive, *-*"
#r "nuget: FSharp.Stats"
#r "nuget: Deedle"
#r "nuget: Microsoft.ML"
```

# Display training and test splits

```fsharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data
open FSharp.Stats
open FSharp.Stats.Fitting.LinearRegression
open Plotly.NET

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/diabetes.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let X1 = getColumnData "Glucose" |> Array.take 100
let X2 = getColumnData "BloodPressure" |> Array.take 100
let Y = getColumnData "Outcome" |> Array.take 100

let Data = Array.map3 (fun x1 x2 y -> [|x1;x2;y|]) X1 X2 Y

let splitPercetage = 0.2
let n = Data.Length
let m = float n * splitPercetage |> ceil |> int

let chunkIndices =
                [|0 .. n-1|]
                |> FSharp.Stats.Array.shuffleFisherYates
                |> Array.take m

let testData,trainData = Data |> Matrix.ofJaggedArray |> Matrix.splitRows chunkIndices

let getLabelData data label=
            data
                |> Matrix.toJaggedArray
                |> Array.filter (fun x -> x.[2] = label)
                |> Array.map (fun x -> (x.[0],x.[1]))

let trainLabel_0 = getLabelData trainData 0.
let trainLabel_1 = getLabelData trainData 1.

let testLabel_0 = getLabelData testData 0.
let testLabel_1 = getLabelData testData 1.

[
Chart.Point(trainLabel_0,Name="Train Label 0") |> Chart.withMarkerStyle(Size=12,Symbol=StyleParam.Symbol.Square)
Chart.Point(trainLabel_1,Name="Train Label 1") |> Chart.withMarkerStyle(Size=12,Symbol=StyleParam.Symbol.Circle)
Chart.Point(testLabel_0,Name="Test Label 0") |> Chart.withMarkerStyle(Size=12,Symbol=StyleParam.Symbol.SquareCross)
Chart.Point(testLabel_1,Name="Test Label 1") |> Chart.withMarkerStyle(Size=12,Symbol=StyleParam.Symbol.CircleCross)
]
|> Chart.combine
|> Chart.withSize(1100.,700.)


```

# Visualize Predictions on test split

```fsharp dotnet_interactive={"language": "fsharp"}
open Deedle
open FSharp.Data
open FSharp.Stats
open FSharp.Stats.ML
open FSharp.Stats.ML.Unsupervised
open FSharp.Stats.ML.Unsupervised.HierarchicalClustering

open Plotly.NET

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/iris.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let X1 = getColumnData "SepalWidth"
let X2 = getColumnData "SepalLength"
let Y = getColumnData "Name"

let getLabel y = if y = "Iris-setosa" then 1. else 0.

let Data = Array.map3 (fun x1 x2 y -> [|x1;x2; getLabel y|]) X1 X2 Y

let splitPercetage = 0.2
let n = Data.Length
let m = float n * splitPercetage |> ceil |> int

let chunkIndices =
                [|0 .. n-1|]
                |> FSharp.Stats.Array.shuffleFisherYates
                |> Array.take m

let testData,trainData = Data |> Matrix.ofJaggedArray |> Matrix.splitRows chunkIndices

let InputData = trainData |> Matrix.toJaggedArray |> Array.map (fun x -> x |> Array.take 2)

let rnd = new System.Random()
let randomInitFactory : IterativeClustering.CentroidsFactory<float []> =
    IterativeClustering.randomCentroids<float []> rnd

let kmeansResult = IterativeClustering.kmeans DistanceMetrics.euclidean randomInitFactory InputData 2

let centroids= Array.map (fun x ->  let z:float[] = snd x
                                    (z.[0],z.[1]) ) kmeansResult.Centroids


let results = testData
                |> Matrix.toJaggedArray
                |> Array.map  (fun row ->
                                        let input = [|row.[0];row.[1]|]
                                        fst (kmeansResult.Classifier input))

let getLabelData label=
    testData |>  Matrix.toJaggedArray
                |> Array.mapi (fun i x -> if(results.[i] = label) then Some(x)
                                          else None)
                |> Array.filter (fun x -> x.IsSome)
                |> Array.map (fun x -> (x.Value.[0],x.Value.[1]) )


let label_1 = getLabelData 1
let label_2 = getLabelData 2

[
    Chart.Point(centroids,Name="Centroid") |> Chart.withMarkerStyle(Symbol=StyleParam.Symbol.Cross,Size=12)
    Chart.Point(label_1,Name="Label 1") |> Chart.withMarkerStyle(Symbol=StyleParam.Symbol.Square,Size=12)
    Chart.Point(label_2,Name="Label 2") |> Chart.withMarkerStyle(Symbol=StyleParam.Symbol.Circle,Size=12)

]|> Chart.combine
|> Chart.withSize(1100.,700.)
|> Chart.withXAxisStyle(title="X1")
|> Chart.withYAxisStyle(title="X2")
```

# Probability Estimates with Contour

```fsharp dotnet_interactive={"language": "fsharp"}
open Microsoft.ML
open Microsoft.ML.Data
open Microsoft.ML.Trainers

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/iris.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

type ModelInput =
    { X1: float32
      X2: float32
      Y: float32 }

[<CLIMutable>]
type ModelOutput = {
    PredictedLabel: uint32
    Score : float32[]
}

let X1 = getColumnData "SepalWidth"
let X2 = getColumnData "SepalLength"
let Y = getColumnData "Name"

let getLabel y = if y = "Iris-setosa" then 1.f else 0.f

let Input = Array.map3 (fun x1 x2 y -> {X1=x1;X2=x2;Y=getLabel y}) X1 X2 Y

let linspace (min,max,n) =
    if n <= 2 then failwithf "n needs to be larger then 2"
    let bw = float32 (max - min) / (float32 n - 1.0f)
    Array.init n (fun i -> min + (bw * float32 i))

let ctx = MLContext()

let dataView = ctx.Data.LoadFromEnumerable<ModelInput>(Input)

let pipeline =
        EstimatorChain()
            .Append(ctx.Transforms.Concatenate("Features", "X1", "X2"))
            .Append(ctx.Transforms.NormalizeMinMax(outputColumnName = "FeaturesNorm", inputColumnName = "Features"))
            .Append(ctx.Clustering.Trainers.KMeans(new KMeansTrainer.Options(FeatureColumnName="FeaturesNorm",NumberOfClusters=2)))

let trainedModel = pipeline.Fit(dataView)

let predictionEngine = ctx.Model.CreatePredictionEngine<ModelInput, ModelOutput>(trainedModel)

let xRange = linspace(Seq.min(X1),Seq.max(X1),200)
let yRange = linspace(Seq.min(X2),Seq.max(X2),200)

let z = Array.map (fun y -> Array.map (fun x -> let score = predictionEngine.Predict({X1=x;X2=y;Y=0.f}).Score
                                                score.[0]/(Array.sum score)) xRange) yRange

Chart.Contour(z,X=xRange,Y=yRange)
|> Chart.withSize(1100.,700.)
```

Now, let's try to combine our Contour plot with the first scatter plot of our data points, so that we can visually compare the confidence of our model with the true labels.

```fsharp dotnet_interactive={"language": "fsharp"}
open Microsoft.ML
open Microsoft.ML.Data
open Microsoft.ML.Trainers

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/iris.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

[<CLIMutable>]
type ModelInput =
    { X1: float32
      X2: float32
      Y: float32 }

[<CLIMutable>]
type ModelOutput = {
    PredictedLabel: uint32
    Score : float32[]
}

let X1 = getColumnData "SepalWidth"
let X2 = getColumnData "SepalLength"
let Y = getColumnData "Name"

let getLabel y = if y = "Iris-setosa" then 1.f else 0.f

let Input = Array.map3 (fun x1 x2 y -> {X1=x1;X2=x2;Y=getLabel y}) X1 X2 Y

let linspace (min,max,n) =
    if n <= 2 then failwithf "n needs to be larger then 2"
    let bw = float32 (max - min) / (float32 n - 1.0f)
    Array.init n (fun i -> min + (bw * float32 i))

let ctx = MLContext()

let dataView = ctx.Data.LoadFromEnumerable<ModelInput>(Input)

let split = ctx.Data.TrainTestSplit(dataView, testFraction= 0.2)

let pipeline =
        EstimatorChain()
            .Append(ctx.Transforms.Concatenate("Features", "X1", "X2"))
            .Append(ctx.Transforms.NormalizeMinMax(outputColumnName = "FeaturesNorm", inputColumnName = "Features"))
            .Append(ctx.Clustering.Trainers.KMeans(new KMeansTrainer.Options(FeatureColumnName="FeaturesNorm",NumberOfClusters=2)))

let trainedModel = pipeline.Fit(split.TrainSet)

let predictionEngine = ctx.Model.CreatePredictionEngine<ModelInput, ModelOutput>(trainedModel)

let xRange = linspace(Seq.min(X1),Seq.max(X1),200)
let yRange = linspace(Seq.min(X2),Seq.max(X2),200)

let z = Array.map (fun y -> Array.map (fun x -> let score = predictionEngine.Predict({X1=x;X2=y;Y=0.f}).Score
                                                score.[0]/(Array.sum score)) xRange) yRange

let testSet = ctx.Data.CreateEnumerable<ModelInput>(split.TestSet,reuseRowObject= false)

let testLabels = [|for x in testSet -> ((x.X1,x.X2),predictionEngine.Predict(x))|]
                    |> Array.groupBy (fun x -> (snd x).PredictedLabel)
                    |> Array.map (fun group -> snd group
                                                |> Array.map (fun x ->  fst x) )

let labelColors = [|"black";"deeppink"|]
let symbols = [|StyleParam.Symbol.Circle;StyleParam.Symbol.Square|]
[
testLabels |> Array.mapi (fun i test -> Chart.Point(test,Name= $"Label {i+1}",Showlegend=false)
                                        |> Chart.withMarkerStyle(Size=12,Symbol=symbols.[i],Color=labelColors.[i]))
|> Chart.combine
Chart.Contour(z,X=xRange,Y=yRange,Colorscale=StyleParam.Colorscale.RdBu)
]
|> Chart.combine
|> Chart.withSize(1100.,700.)
```

# Multi-class prediction confidence with Heatmap

```fsharp dotnet_interactive={"language": "fsharp"}
open Microsoft.ML
open Microsoft.ML.Data
open Microsoft.ML.Trainers

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/iris.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

[<CLIMutable>]
type ModelInput =
    { X1: float32
      X2: float32
      Y: float32 }

[<CLIMutable>]
type ModelOutput = {
    PredictedLabel: uint32
    Score : float32[]
    Probability:float32[]
}

let X1 = getColumnData "SepalWidth"
let X2 = getColumnData "SepalLength"
let Y = getColumnData "Name"

let getLabel y = if y = "Iris-setosa" then 1f elif y = "Iris-versicolor" then 2f else 3f

let Input = Array.map3 (fun x1 x2 y -> {X1=x1;X2=x2;Y=getLabel y}) X1 X2 Y

let linspace (min,max,n) =
    if n <= 2 then failwithf "n needs to be larger then 2"
    let bw = float32 (max - min) / (float32 n - 1.0f)
    Array.init n (fun i -> min + (bw * float32 i))

let ctx = MLContext()

let dataView = ctx.Data.LoadFromEnumerable<ModelInput>(Input)

let split = ctx.Data.TrainTestSplit(dataView, testFraction= 0.2)

let pipeline =
        EstimatorChain()
            .Append(ctx.Transforms.Conversion.MapValueToKey("LabelKey","Y"))
            .Append(ctx.Transforms.Concatenate("Features", "X1", "X2"))
            .Append(ctx.Transforms.NormalizeMinMax(outputColumnName = "FeaturesNorm", inputColumnName = "Features"))
            .Append(ctx.MulticlassClassification.Trainers.SdcaMaximumEntropy(featureColumnName="FeaturesNorm",labelColumnName="LabelKey"))

let trainedModel = pipeline.Fit(split.TrainSet)

let predictionEngine = ctx.Model.CreatePredictionEngine<ModelInput, ModelOutput>(trainedModel)


let xRange = linspace(Seq.min(X1),Seq.max(X1),200)
let yRange = linspace(Seq.min(X2),Seq.max(X2),200)

let z = Array.map (fun y -> Array.map (fun x -> let score = predictionEngine.Predict({X1=x;X2=y;Y=0f}).Score

                                                Array.max(score) - (Array.sum score - Array.max(score))) xRange) yRange

let testSet = ctx.Data.CreateEnumerable<ModelInput>(split.TestSet,reuseRowObject= false)

let testLabels = [|for x in testSet -> ((x.X1,x.X2),predictionEngine.Predict(x))|]
                    |> Array.groupBy (fun x -> (snd x).PredictedLabel)
                    |> Array.map (fun group -> snd group
                                                |> Array.map (fun x ->  fst x) )

let labelColors = [|"black";"deeppink";"green"|]
let symbols = [|StyleParam.Symbol.Circle;StyleParam.Symbol.Square;StyleParam.Symbol.Diamond|]
[
testLabels |> Array.mapi (fun i test -> Chart.Point(test,Name= $"Label {i+1}",Showlegend=false)
                                        |> Chart.withMarkerStyle(Size=12,Symbol=symbols.[i],Color=labelColors.[i]))
|> Chart.combine
Chart.Heatmap(z,ColNames=xRange,RowNames=yRange,Colorscale=StyleParam.Colorscale.RdBu)
]
|> Chart.combine
|> Chart.withSize(1100.,700.)




```
