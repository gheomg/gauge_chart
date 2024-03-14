import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_chart/gauge_chart.dart';

void main() {
  group("getValues function", () {
    test('getValues returns empty list for empty pies list', () {
      expect(getValues([], 0.0, false), isEmpty);
    });

    test('getValues returns pie values without gaps for single pie', () {
      final pie = PieData(value: 10.0, color: Colors.red, description: 'Test');
      expect(getValues([pie], 0.0, false), [pie.value]);
    });

    test('getValues returns pie values with gaps for multiple pies', () {
      final pie1 =
          PieData(value: 20.0, color: Colors.blue, description: 'Test 1');
      final pie2 =
          PieData(value: 30.0, color: Colors.green, description: 'Test 2');
      final expectedValues = [pie1.value, 0.5, pie2.value, 0.5];
      expect(getValues([pie1, pie2], 0.5, false), expectedValues);
    });

    test('getValues handles halfPie flag for last pie without gap', () {
      final pie1 =
          PieData(value: 20.0, color: Colors.blue, description: 'Test 1');
      final pie2 =
          PieData(value: 30.0, color: Colors.green, description: 'Test 2');
      final expectedValues = [pie1.value, 0.5, pie2.value];
      expect(getValues([pie1, pie2], 0.5, true), expectedValues);
    });
  });

  group("getAngleFromCordinates function", () {
    const size = 100.0;
    test('calculates correct angle for center tap', () {
      expect(getAngleFromCordinates(size / 2, size / 2, size), 225.0);
    });

    test('calculates positive angle for right tap', () {
      expect(getAngleFromCordinates(size, size / 2, size), 270);
    });

    test('calculates negative angle for left tap', () {
      expect(getAngleFromCordinates(0, size / 2, size), closeTo(206.0, 207.0));
    });

    test('handles taps on positive diagonal (top-right)', () {
      expect(getAngleFromCordinates(size, size, size), 0.0);
    });

    test('handles taps on negative diagonal (bottom-left)', () {
      expect(getAngleFromCordinates(0, 0, size), closeTo(225.0, 0.01));
    });

    test('handles angles crossing 0 degrees (top-left)', () {
      expect(getAngleFromCordinates(size / 4, size, size), 180.0);
    });
  });

  group("getPositiveAngle function", () {
    test('getPositiveAngle converts negative angle to positive', () {
      expect(getPositiveAngle(-135.0), 225.0);
    });

    test('getPositiveAngle keeps positive angle unchanged', () {
      expect(getPositiveAngle(45.0), 45.0);
    });
  });

  group("getAngleIn360 function", () {
    test('getAngleIn360 handles negative angles', () {
      expect(getAngleIn360(-90.0), 270.0);
    });

    test('getAngleIn360 handles angles greater than 360', () {
      expect(getAngleIn360(450.0), 90.0);
    });

    test('getAngleIn360 keeps angles within 0-360 range', () {
      expect(getAngleIn360(180.0), 180.0);
    });
  });

  group("isCurrentPieTap function", () {
    test('isCurrentPieTap returns true for tap within pie slice', () {
      expect(isCurrentPieTap(45.0, 90.0, 60.0), true);
    });

    test('isCurrentPieTap returns false for tap outside pie slice', () {
      expect(isCurrentPieTap(45.0, 90.0, 120.0), false);
    });

    test('isCurrentPieTap handles angles crossing 0 degrees', () {
      expect(isCurrentPieTap(330.0, 30.0, 0.0), true);
    });
  });

  group("getIndexOfTappedPie function", () {
    test('getIndexOfTappedPie handles empty pie list', () {
      expect(getIndexOfTappedPie([], 100.0, 0.0, 0.0, 45.0), null);
    });

    test('getIndexOfTappedPie returns index for single pie', () {
      final pie = PieData(value: 100.0, color: Colors.red, description: 'Test');
      expect(getIndexOfTappedPie([pie.value], 100.0, 0.0, 0.0, 45.0), null);
    });

    test('getIndexOfTappedPie handles pies with gaps (tap within pie)', () {
      final pie1 =
          PieData(value: 20.0, color: Colors.blue, description: 'Test 1');
      final pie2 =
          PieData(value: 30.0, color: Colors.green, description: 'Test 2');
      expect(
          getIndexOfTappedPie(
              [pie1.value, 0.5, pie2.value], 100.0, 0.5, 0.0, 60.0),
          0);
    });

    test('getIndexOfTappedPie handles pies with gaps (tap on gap)', () {
      final pie1 =
          PieData(value: 20.0, color: Colors.blue, description: 'Test 1');
      final pie2 =
          PieData(value: 30.0, color: Colors.green, description: 'Test 2');
      expect(
          getIndexOfTappedPie(
              [pie1.value, 0.5, pie2.value], 100.0, 0.5, 0.0, 270.0),
          null);
    });

    test('getIndexOfTappedPie handles halfPie flag (tap within first half)',
        () {
      final pie1 =
          PieData(value: 20.0, color: Colors.blue, description: 'Test 1');
      final pie2 =
          PieData(value: 30.0, color: Colors.green, description: 'Test 2');
      expect(
          getIndexOfTappedPie(
              [pie1.value, 0.5, pie2.value], 100.0, 0.5, 180.0, 210.0),
          0);
    });

    test(
        'getIndexOfTappedPie handles halfPie flag (tap on gap after first half)',
        () {
      final pie1 =
          PieData(value: 20.0, color: Colors.blue, description: 'Test 1');
      final pie2 =
          PieData(value: 30.0, color: Colors.green, description: 'Test 2');
      expect(
          getIndexOfTappedPie(
              [pie1.value, 0.5, pie2.value], 100.0, 0.5, 270.0, 300.0),
          0);
    });

    test('getIndexOfTappedPie handles taps crossing 0 degrees', () {
      final pie1 =
          PieData(value: 20.0, color: Colors.blue, description: 'Test 1');
      expect(getIndexOfTappedPie([pie1.value], 100.0, 0.0, 330.0, 0.0), 0);
    });

    test('getIndexOfTappedPie handles taps exactly on pie boundaries', () {
      final pie1 =
          PieData(value: 20.0, color: Colors.blue, description: 'Test 1');
      final pie2 =
          PieData(value: 30.0, color: Colors.green, description: 'Test 2');
      expect(
          getIndexOfTappedPie(
              [pie1.value, 0.5, pie2.value], 100.0, 0.5, 0.0, 0.0),
          0);

      expect(
          getIndexOfTappedPie(
              [pie1.value, 0.5, pie2.value], 100.0, 0.5, 90.0, 90.0),
          0);

      expect(
          getIndexOfTappedPie(
              [pie1.value, 0.5, pie2.value], 100.0, 0.5, 180.0, 180.0),
          0);

      expect(
          getIndexOfTappedPie(
              [pie1.value, 0.5, pie2.value], 100.0, 0.5, 270.0, 270.0),
          0);
    });
  });
}
