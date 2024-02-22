part of 'gauge_chart.dart';

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

  _GaugeChartPainter({
    required this.pieValues,
    required this.pies,
    required this.showValue,
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

  updateStartAngle() {
    startAngle += sweepRadian;
  }

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
