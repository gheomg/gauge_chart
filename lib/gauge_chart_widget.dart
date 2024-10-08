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
  final List<String>? centerText;
  final bool showLegend;
  final double legendLeftPadding;

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
  /// * `centerText`: The text that is displayed in the center of the chart.
  /// * `showLegend`: Option to display a legend on the right side of the chart.
  /// * `legendLeftPadding`: The size of the space between the chart and legend.
  const GaugeChart({
    Key? key,
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
    this.centerText,
    this.showLegend = false,
    this.legendLeftPadding = 40.0,
  }) : super(key: key);

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
              return pieChartExtended(pieValues, total, value);
            })
        : pieChartExtended(pieValues, total, 1);
  }

  Widget pieChartExtended(List<double> pieValues, double total, double value) {
    if (!showLegend) return pieChartWidget(pieValues, total, 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        pieChartWidget(pieValues, total, 1),
        SizedBox(
          width: legendLeftPadding,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: children.map(
              (e) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: e.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        e.description,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
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
            centerText: centerText,
          ),
          child: child,
        ),
      ),
    );
  }
}
