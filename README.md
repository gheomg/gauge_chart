## GaugeChart

This Flutter package provides a customizable circular, gauge-style pie chart that can be displayed as a full circle or half circle. It's perfect for visualizing data distribution, progress indicators, and more, offering a rich set of features for tailoring your chart to your specific needs.

## Features

- Full or half circle display option
- Adjustable gap between slices for better visual separation
- Customizable start angle to control the starting position of the chart
- Text on slices or in the middle of the chart for displaying data labels
- Customizable colors, stroke width, and text labels

## Getting started

Add the package to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  gauge_chart: ^version
```

or simply run the command in your terminal at project root directory

```
flutter pub add gauge_chart
```

Import the package in your Flutter code:

```dart
import 'package:gauge_chart/gauge_chart.dart';
```

## Use the GaugeChart widget with the desired features:

```dart
GaugeChart(
    children: [
        PieData(
        value: 10,
        color: Colors.blue.shade800,
        description: "Taken",
        ),
        PieData(
        value: 4,
        color: Colors.blue.shade300,
        description: "Planned",
        ),
        PieData(
        value: 14,
        color: Colors.grey.shade300,
        description: "To plan",
        ),
    ],
    gap: 3.5,
    animateDuration: const Duration(seconds: 1),
    start: 180,
    displayIndex: 2,
    shouldAnimate: true,
    animateFromEnd: false,
    isHalfChart: true,
    size: 200,
    showValue: false,
    borderWidth: 25,
),
```

## License

This package is available under the **BSD-3-Clause**.