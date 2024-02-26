import 'package:flutter/material.dart';
import 'package:gauge_chart/gauge_chart.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GaugeChart(
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
        ),
      ),
    );
  }
}
