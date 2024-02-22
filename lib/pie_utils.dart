part of 'gauge_chart.dart';

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

double getAngleFromCordinates(
    double xCordinate, double yCordinate, double size) {
  return getPositiveAngle(
      atan2(yCordinate - size, xCordinate - size) * 180 / pi);
}

double getPositiveAngle(double tapAngle) {
  if (tapAngle > -180 && tapAngle < 0) {
    tapAngle = 180 + (180 + tapAngle);
  }
  return tapAngle;
}

double getAngleIn360(double startAngle) {
  if (startAngle < 0) {
    startAngle = startAngle % 360;
    startAngle = 360 + startAngle;
  }
  startAngle = startAngle % 360;
  return startAngle;
}

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
