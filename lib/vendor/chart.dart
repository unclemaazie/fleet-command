library vendor_chart;

import 'package:flutter/material.dart';

/// Simple Bar Chart implementation - replaces fl_chart BarChart
class SimpleBarChart extends StatelessWidget {
  final List<BarData> data;
  final double maxY;
  final Color barColor;
  final Color? backgroundColor;

  const SimpleSimpleBarChart({
    super.key,
    required this.data,
    required this.maxY,
    this.barColor = const Color(0xFF00D4AA),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _BarChartPainter(
        data: data,
        maxY: maxY,
        barColor: barColor,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class BarData {
  final String label;
  final double value;
  final Color? color;

  BarData({
    required this.label,
    required this.value,
    this.color,
  });
}

class _BarChartPainter extends CustomPainter {
  final List<BarData> data;
  final double maxY;
  final Color barColor;
  final Color? backgroundColor;

  _BarChartPainter({
    required this.data,
    required this.maxY,
    required this.barColor,
    this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final barWidth = (size.width / data.length) * 0.6;
    final spacing = (size.width / data.length) * 0.4;
    final chartHeight = size.height - 40;

    // Draw background grid
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      final y = (chartHeight / 5) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final barHeight = (data[i].value / maxY) * chartHeight;
      final x = (i * (barWidth + spacing)) + (spacing / 2);
      final y = chartHeight - barHeight;

      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            data[i].color ?? barColor,
            const Color(0xFF7B61FF),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight))
        ..style = PaintingStyle.fill;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(6),
      );

      canvas.drawRRect(rect, paint);

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, chartHeight + 8),
      );

      // Draw value
      if (data[i].value > 0) {
        final valuePainter = TextPainter(
          text: TextSpan(
            text: data[i].value.toStringAsFixed(0),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        valuePainter.layout();
        valuePainter.paint(
          canvas,
          Offset(x + (barWidth - valuePainter.width) / 2, y - 16),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Simple Line Chart implementation
class SimpleLineChart extends StatelessWidget {
  final List<LineData> data;
  final double maxY;
  final List<Color> gradientColors;

  const SimpleSimpleLineChart({
    super.key,
    required this.data,
    required this.maxY,
    this.gradientColors = const [Color(0xFF00D4AA), Color(0xFF7B61FF)],
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _LineChartPainter(
        data: data,
        maxY: maxY,
        gradientColors: gradientColors,
      ),
    );
  }
}

class LineData {
  final double x;
  final double y;

  LineData({required this.x, required this.y});
}

class _LineChartPainter extends CustomPainter {
  final List<LineData> data;
  final double maxY;
  final List<Color> gradientColors;

  _LineChartPainter({
    required this.data,
    required this.maxY,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final chartHeight = size.height - 40;
    final chartWidth = size.width;

    // Draw grid
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      final y = (chartHeight / 5) * i;
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    // Create path
    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (data[i].x / (data.length - 1)) * chartWidth;
      final y = chartHeight - ((data[i].y / maxY) * chartHeight);
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw area under line
    final areaPath = Path.from(path);
    areaPath.lineTo(points.last.dx, chartHeight);
    areaPath.lineTo(points.first.dx, chartHeight);
    areaPath.close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          gradientColors[0].withOpacity(0.3),
          gradientColors[1].withOpacity(0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, chartWidth, chartHeight))
      ..style = PaintingStyle.fill;

    canvas.drawPath(areaPath, areaPaint);

    // Draw line
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, chartWidth, chartHeight))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Draw dots
    for (final point in points) {
      canvas.drawCircle(
        point,
        4,
        Paint()..color = gradientColors[0],
      );
      canvas.drawCircle(
        point,
        4,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter) => true;
}

/// Simple Pie Chart implementation
class SimplePieChart extends StatelessWidget {
  final List<PieData> data;

  const SimpleSimplePieChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: _PieChartPainter(data: data),
    );
  }
}

class PieData {
  final String label;
  final double value;
  final Color color;

  PieData({
    required this.label,
    required this.value,
    required this.color,
  });
}

class _PieChartPainter extends CustomPainter {
  final List<PieData> data;

  _PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<double>(0, (sum, d) => sum + d.value);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    var startAngle = -90.0 * (3.14159 / 180);

    for (final item in data) {
      final sweepAngle = (item.value / total) * 2 * 3.14159;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center hole for donut effect
    final holePaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.5, holePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter) => true;
}
