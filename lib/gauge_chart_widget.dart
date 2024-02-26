part of 'gauge_chart.dart';

/// This class represents a gauge chart widget that can be customized
/// with various styling options, animation settings, and interactive behavior.

/// It accepts a list of [PieData] objects representing the slices of the chart,
/// and provides options to control the appearance, animation, and interactivity.
class GaugeChart extends StatelessWidget {
  final List<PieData> children;
  final TextStyle? style;
  final bool showValue;
  final double start;
  final int? displayIndex;
  final TextStyle? centerTopStyle;
  final TextStyle? centerBottomStyle;
  final Widget? child;
  final double size;
  final double gap;
  final double borderWidth;
  final StrokeCap borderEdge;
  final bool shouldAnimate;
  final Duration? animateDuration;
  final bool animateFromEnd;
  final bool? isHalfChart;

  final void Function(int index)? onTap;

  /// Creates a gauge chart widget.
  ///
  /// * `children`: A list of [PieData] objects representing the slices of the chart.
  /// * `showValue`: Whether to display the value of each slice on the chart.
  /// * `start`: The starting angle for the first pie slice.
  /// * `gap`: The gap between pie slices.
  /// * `borderWidth`: The width of the border for each pie slice.
  /// * `borderEdge`: The style of the border edge for each pie slice.
  /// * `shouldAnimate`: Whether to animate the chart drawing.
  /// * `animateDuration`: The duration of the animation, if enabled.
  /// * `displayIndex`: The index of the pie slice to highlight, if any.
  /// * `child`: An optional child widget to place at the center of the chart.
  /// * `style`: The text style to use for displaying pie values.
  /// * `centerTopStyle`: The text style to use for the top text at the center of the chart.
  /// * `centerBottomStyle`: The text style to use for the bottom text at the center of the chart.
  /// * `animateFromEnd`: Whether to animate the chart from the end to the beginning.
  /// * `onTap`: A callback function triggered when a pie slice is tapped.
  /// * `size`: The size of the chart.
  /// * `isHalfChart`: Whether to display a half chart instead of a full circle.
  const GaugeChart({
    super.key,
    required this.children,
    this.showValue = true,
    this.start = -90,
    this.gap = 0.0,
    this.borderWidth = 20.0,
    this.borderEdge = StrokeCap.round,
    this.shouldAnimate = true,
    this.animateDuration,
    this.displayIndex,
    this.child,
    this.style,
    this.centerTopStyle,
    this.centerBottomStyle,
    this.animateFromEnd = false,
    this.onTap,
    this.size = 200,
    this.isHalfChart,
  });

  @override
  Widget build(BuildContext context) {
    final List<double> pieValues =
        getValues(children, gap, isHalfChart ?? false);
    final double total =
        pieValues.reduce(((value, element) => value + element));

    return shouldAnimate
        ? TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.00000000001, end: 1.0),
            duration: animateDuration ?? const Duration(milliseconds: 1500),
            builder: (context, value, _) {
              return pieChartWidget(pieValues, total, value);
            })
        : pieChartWidget(pieValues, total, 1);
  }

  Widget pieChartWidget(List<double> pieValues, double total, double value) {
    return GestureDetector(
      onTapUp: onTap == null
          ? null
          : (details) {
              final int? index = getIndexOfTappedPie(
                  pieValues,
                  total,
                  gap,
                  getAngleIn360(start),
                  getAngleFromCordinates(details.localPosition.dx,
                      details.localPosition.dy, size / 2));
              if (index == null) return;
              onTap!(index);
            },
      child: SizedBox(
        height: size / (isHalfChart ?? false ? 2 : 1),
        width: size,
        child: CustomPaint(
          painter: _GaugeChartPainter(
            pies: children,
            pieValues: pieValues.map((pieValue) => pieValue * value).toList(),
            total: total,
            showValue: showValue,
            startAngle: start,
            animateFromEnd: animateFromEnd,
            displayIndex: displayIndex,
            style: style,
            centerTopStyle: centerTopStyle,
            centerBottomStyle: centerBottomStyle,
            gap: gap,
            borderEdge: borderEdge,
            borderWidth: borderWidth,
            isHalfChart: isHalfChart,
          ),
          child: child,
        ),
      ),
    );
  }
}
