part of 'gauge_chart.dart';

/// Takes a list of PieData objects, a gap value, and a isHalfPie flag.
/// It returns a list of doubles representing the values to be used for drawing the gauge chart.
List<double> getValues(List<PieData> pies, double gap, bool isHalfPie) {
  final List<double> pieValues = [];
  for (var i = 0; i < pies.length; i++) {
    var pie = pies.elementAt(i);
    if (gap > 0.0 && (!isHalfPie || i < pies.length - 1)) {
      pieValues.addAll([pie.value, gap]);
    } else {
      pieValues.add(pie.value);
    }
  }
  return pieValues;
}

/// Takes the x-coordinate, y-coordinate, and size of a tap on the chart and calculates the corresponding angle in degrees.
double getAngleFromCordinates(
    double xCordinate, double yCordinate, double size) {
  return getPositiveAngle(
      atan2(yCordinate - size, xCordinate - size) * 180 / pi);
}

/// Converts a negative tap angle to a positive angle between 0 and 360 degrees.
double getPositiveAngle(double tapAngle) {
  if (tapAngle > -180 && tapAngle < 0) {
    tapAngle = 180 + (180 + tapAngle);
  }
  return tapAngle;
}

/// Ensures the start angle is within the range of 0 to 360 degrees.
double getAngleIn360(double startAngle) {
  if (startAngle < 0) {
    startAngle = startAngle % 360;
    startAngle = 360 + startAngle;
  }
  startAngle = startAngle % 360;
  return startAngle;
}

/// Checks if a tap falls within the arc of a specific pie slice.
bool isCurrentPieTap(double startAngle, double sweepAngle, double tapAngle) {
  if (startAngle <= sweepAngle) {
    if (startAngle <= tapAngle && tapAngle <= sweepAngle) {
      return true;
    }
  } else {
    if (startAngle <= tapAngle || tapAngle <= sweepAngle) {
      return true;
    }
  }
  return false;
}

/// Identifies the index of the pie slice that was tapped based on the tap location.
int? getIndexOfTappedPie(
    List<double> pieValues, double total, double gap, startAngle, tapAngle) {
  for (int i = 0; i < pieValues.length; i++) {
    double pieAngle = (2 * pi * (pieValues[i] / total)) * 180 / pi;
    double j = 0;
    while (j <= (gap > 0.0 ? i % 2 : 0)) {
      double sweepAngle =
          (startAngle + (pieAngle * (gap > 0.0 && i % 2 == 1 ? 0.25 : 1))) %
              360;
      if (isCurrentPieTap(startAngle, sweepAngle, tapAngle)) {
        final int index = gap > 0.0
            ? i % 2 == 1
                ? j == 0
                    ? (i - 1) ~/ 2
                    : i + 1 < pieValues.length
                        ? (i + 1) ~/ 2
                        : 0
                : i ~/ 2
            : i;
        return index;
      }
      startAngle = (startAngle +
              (pieAngle *
                  (gap > 0.0 && i % 2 == 1
                      ? j == 0
                          ? 0.75
                          : 0.25
                      : 1))) %
          360;
      j++;
    }
  }
  return null;
}
