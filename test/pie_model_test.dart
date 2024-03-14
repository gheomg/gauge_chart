import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_chart/gauge_chart.dart';

void main() {
  group('PieData', () {
    test('constructor creates instance with required parameters', () {
      final pieData = PieData(
        value: 30.0,
        color: Colors.blue,
        description: 'Test Description',
      );

      expect(pieData.value, 30.0);
      expect(pieData.color, Colors.blue);
      expect(pieData.description, 'Test Description');
    });
  });
}
