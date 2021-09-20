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
    description: Interpret the results of your classification using Receiver Operating
      Characteristics (ROC) and Precision-Recall (PR) Curves in F# with Plotly.
    display_as: ai_ml
    language: fsharp
    layout: base
    name: ROC and PR Curves
    order: 3
    page_type: u-guide
    permalink: fsharp/roc-and-pr-curves/
    thumbnail: thumbnail/ml-roc-pr.png
---

```fsharp  dotnet_interactive={"language": "fsharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
#r "nuget: FSharp.Stats"
#r "nuget: Deedle"
#r "nuget: Accord.MachineLearning"
```

# ROC and PR Curves


Interpret the results of your classification using Receiver Operating Characteristics (ROC) and Precision-Recall (PR) Curves with Plotly.


# Preliminary plots


Before diving into the receiver operating characteristic (ROC) curve, we will look at two plots that will give some context to the thresholds mechanism behind the ROC and PR curves.

In the histogram, we observe that the score spread such that most of the positive labels are binned near 1, and a lot of the negative labels are close to 0. When we set a threshold on the score, all of the bins to its left will be classified as 0's, and everything to the right will be 1's. There are obviously a few outliers, such as negative samples that our model gave a high score, and positive samples with a low score. If we set a threshold right in the middle, those outliers will respectively become false positives and false negatives.

As we adjust thresholds, the number of false positives will increase or decrease, and at the same time the number of true positives will also change; this is shown in the second plot. As you can see, the model seems to perform fairly well, because the true positive rate and the false positive rate decreases sharply as we increase the threshold. Those two lines each represent a dimension of the ROC curve.

```fsharp  dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Deedle
open Plotly.NET
open Accord.MachineLearning.VectorMachines
open Accord.MachineLearning.VectorMachines.Learning
open Accord.Statistics.Analysis
open FSharp.Stats.Distributions
open FSharp.Stats

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/diabetes.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let X1 = getColumnData "Glucose" 
let X2 = getColumnData "BloodPressure" 
let Y:float[] = getColumnData "Outcome" 

let linspace (min,max,n) = 
    if n <= 2 then failwithf "n needs to be larger then 2"
    let bw = float32 (max - min) / (float32 n - 1.0f)
    Array.init n (fun i -> min + (bw * float32 i))

let X = Array.map2 (fun x1 x2 -> [|float x1;float x2|]) X1 X2

let lra = LogisticRegressionAnalysis()
let model = lra.Learn(X,Y)
let yScores = model.Probabilities(X)
let label_0 = yScores |> Array.map (fun x -> x.[0])
let label_1 = yScores |> Array.map (fun x -> x.[1])

[
    Chart.Histogram(label_0,nBinsx=50,Name="Label 0")
    Chart.Histogram(label_1,nBinsx=50,Name="Label 1")
]
|> Chart.combine
|> Chart.withSize(1100.,700.)

```

```fsharp  dotnet_interactive={"language": "fsharp"}
open FSharp.Data
open Deedle
open Plotly.NET
open Accord.MachineLearning.VectorMachines
open Accord.MachineLearning.VectorMachines.Learning
open Accord.Statistics.Analysis
open FSharp.Stats.Distributions
open FSharp.Stats

let data=
    Http.RequestString "https://raw.githubusercontent.com/plotly/datasets/master/diabetes.csv"
    |> fun csv -> Frame.ReadCsvString(csv,true,separators=",")

let getColumnData column=
        data
        |> Frame.getCol column
        |> Series.values
        |> Array.ofSeq

let X1 = getColumnData "Glucose" 
let X2 = getColumnData "BloodPressure" 
let Y:float[] = getColumnData "Outcome" 

let linspace (min,max,n) = 
    if n <= 2 then failwithf "n needs to be larger then 2"
    let bw = float32 (max - min) / (float32 n - 1.0f)
    Array.init n (fun i -> min + (bw * float32 i))

let X = Array.map2 (fun x1 x2 -> [|float x1;float x2|]) X1 X2

let lra = LogisticRegressionAnalysis()
let model = lra.Learn(X,Y)
let predicted = [|for x in X -> model.Probability(x) |]


let roc = new ReceiverOperatingCharacteristic(Y, predicted)
roc.Compute(100)

let tpr = roc.Points.GetSensitivity()
let fpr = roc.Points.GetOneMinusSpecificity()

let cutoff = [|for point in roc.Points ->  point.Cutoff |]

[
Chart.Line(cutoff,tpr,Name="True Positive Rate");
Chart.Line(cutoff,fpr,Name="False Positive Rate");
] 
|> Chart.combine
|> Chart.withXAxisStyle(title="Thresholds")
|> Chart.withYAxisStyle(title="value")
|> Chart.withSize(1100.,700.)
|> Chart.withTitle("TPR and FPR at every threshold")





```
