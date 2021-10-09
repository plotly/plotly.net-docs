---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: "1.3"
      jupytext_version: 1.12.0
  kernelspec:
    display_name: .NET (C#)
    language: C#
    name: .net-csharp
  language_info:
    codemirror_mode:
      name: ipython
      version: 3
    file_extension: .fs
    mimetype: text/x-csharp
    name: C#
    nbconvert_exporter: csharp
    pygments_lexer: csharp
    version: 5.0
  plotly:
    description: How to make Bar Charts in C# with Plotly.
    display_as: basic
    language: csharp
    layout: base
    name: Bar Charts
    order: 3
    page_type: example_index
    permalink: csharp/bar-charts/
    thumbnail: thumbnail/bar.jpg
---

```csharp dotnet_interactive={"language": "csharp"}
#r "nuget: Plotly.NET,  2.0.0-preview.8"
#r "nuget: Plotly.NET.Interactive,  2.0.0-preview.8"
using Plotly.NET;

```

<!-- #region dotnet_interactive={"language": "csharp"} -->

# Basic Bar Chart

you can use C# arrays to construct your bar charts

<!-- #endregion -->

```csharp dotnet_interactive={"language": "csharp"}
var animals = new  [] {"giraffes", "orangutans", "monkeys"};
var sfValues = new  [] {20, 14, 23};
Chart2D.Chart.Column<string, int, string>(animals, sfValues)

```

<!-- #region dotnet_interactive={"language": "csharp"} -->

# Grouped Bar Chart

Chart.combine for grouping the charts

<!-- #endregion -->

```csharp dotnet_interactive={"language": "csharp"}
var animals = new  [] {"giraffes", "orangutans", "monkeys"};
var sfValues = new  [] {20, 14, 23};
var laValues = new  [] {12, 18, 29};

Chart.Combine(new [] {
    Chart2D.Chart.Column<string, int, string>(animals, sfValues,"SF Zoo"),
    Chart2D.Chart.Column<string, int, string>(animals, laValues, "LA Zoo")
})

```

# Stacked Bar Chart

Chart.StackedColumn for constructing stacked bars as shown below

```csharp dotnet_interactive={"language": "csharp"}
var animals = new [] {"giraffes", "orangutans", "monkeys"};
var sfValues = new [] {20, 14, 23};
var laValues = new [] {12, 18, 29};

Chart.Combine(new []
{
    Chart2D.Chart.StackedColumn<string, int, string>(animals, sfValues, "SF Zoo"),
    Chart2D.Chart.StackedColumn<string, int, string>(animals, laValues, "LA Zoo")
})

```
