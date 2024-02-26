part of 'gauge_chart.dart';

/// This class handles the visual rendering of the gauge chart,
/// drawing the pie slices, values, and center text based on the provided configuration.
class _GaugeChartPainter extends CustomPainter {
  final List<double> pieValues;
  final bool showValue;
  final List<PieData> pies;
  final double total;
  double startAngle;
  final StrokeCap borderEdge;
  final double gap;
  final int? displayIndex;
  final TextStyle? style;
  final TextStyle? centerTopStyle;
  final TextStyle? centerBottomStyle;
  final double borderWidth;
  final bool animateFromEnd;
  final bool? isHalfChart;

  /// Parameters:
  /// * `pieValues`: A list of values representing the size of each pie slice.
  /// * `showValue`: Whether to display the value of each pie slice on the chart.
  /// * `pies`: A list of [PieData] objects representing the slices of the chart.
  /// * `total`: The total value of all pie slices combined.
  /// * `gap`: The gap between pie slices.
  /// * `startAngle`: The starting angle for the first pie slice (in degrees).
  /// * `borderEdge`: The style of the border edge for each pie slice.
  /// * `borderWidth`: The width of the border for each pie slice.
  /// * `animateFromEnd`: Whether to animate the chart from the end to the beginning.
  /// * `displayIndex`: The index of the pie slice to highlight, if any.
  /// * `style`: The text style to use for displaying pie values.
  /// * `centerTopStyle`: The text style to use for the top text at the center of the chart.
  /// * `centerBottomStyle`: The text style to use for the bottom text at the center of the chart.
  /// * `isHalfChart`: Whether to display a half chart instead of a full circle.
  _GaugeChartPainter({
    required this.pieValues,
    required this.showValue,
    required this.pies,
    required this.total,
    required this.gap,
    required this.startAngle,
    required this.borderEdge,
    required this.borderWidth,
    required this.animateFromEnd,
    this.displayIndex,
    this.style,
    this.centerTopStyle,
    this.centerBottomStyle,
    this.isHalfChart,
  });

  late double sweepRadian;

  @override
  void paint(Canvas canvas, Size size) {
    startAngle *= pi / 180;

    for (int i = 0; i < pieValues.length; i++) {
      final int index = animateFromEnd ? pieValues.length - i - 1 : i;

      sweepRadian = (animateFromEnd && !(isHalfChart ?? false) ? -1 : 1) *
          2 *
          (pi / (isHalfChart ?? false ? 2 : 1)) *
          (pieValues[index] / total);

      drawPieArc(
          gap > 0.0 && index % 2 != 0
              ? Colors.transparent
              : pies[index ~/ (gap == 0.0 ? 1 : 2)].color,
          size,
          canvas);

      if (showValue && (gap == 0.0 || index % 2 == 0)) {
        showPieText(pies[index ~/ (gap == 0.0 ? 1 : 2)].value, size.width / 2,
            size, canvas);
      }

      updateStartAngle();
    }
    if (displayIndex != null && displayIndex! < pies.length) {
      drawCenterText(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// This method draws a pie arc with the specified color and size on the given canvas.

  /// Parameters:
  /// * `pieColor`: The color of the pie arc.
  /// * `size`: The size of the pie arc.
  /// * `canvas`: The canvas on which to draw the arc.
  void drawPieArc(Color pieColor, Size size, Canvas canvas) {
    final radius = size.width / 2;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );
    final borderPaint = Paint()
      ..color = pieColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      startAngle,
      sweepRadian,
      false,
      borderPaint,
    );
  }

  /// This method draws the given pie value as text at a position aligned with the corresponding pie slice.

  /// Parameters:
  /// * `pieValue`: The value of the pie slice to be displayed as text.
  /// * `radius`: The radius of the pie chart.
  /// * `size`: The size of the canvas on which to draw the text.
  /// * `canvas`: The canvas on which to draw the text.
  void showPieText(double pieValue, double radius, Size size, Canvas canvas) {
    final textAngle = startAngle + (sweepRadian) / 2;

    final textRadius = radius - borderWidth / 50;
    final textX = size.width / 2 + cos(textAngle) * textRadius;
    final textY = size.height / 2 + sin(textAngle) * textRadius;

    final textSpan = TextSpan(
      text: pieValue.toStringAsFixed(1),
      style: style ??
          const TextStyle(
            color: Colors.black,
            fontSize: 8.0,
          ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas,
        Offset(textX - textPainter.width / 2, textY - textPainter.height / 2));
  }

  /// This method increments the `startAngle` property by the current `sweepRadian`, preparing for drawing the next pie slice.
  updateStartAngle() {
    startAngle += sweepRadian;
  }

  /// This method draws the value and description of the currently displayed pie slice at the center of the chart.

  /// Parameters:
  /// * `canvas`: The canvas on which to draw the text.
  /// * `size`: The size of the canvas.
  drawCenterText(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      children: [
        TextSpan(
          text: '${pies.elementAt(displayIndex!).value}\n',
          style: centerTopStyle ??
              const TextStyle(
                color: Colors.black,
                fontSize: 30.0,
              ),
        ),
        TextSpan(
          text: pies.elementAt(displayIndex!).description,
          style: centerBottomStyle ??
              const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
        )
      ],
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    double dx = (size.width / 2) - (textPainter.width / 2);
    double dy =
        isHalfChart ?? false ? 0 : (size.height / 2) - (textPainter.height / 2);

    textPainter.paint(canvas, Offset(dx, dy));
  }
}
