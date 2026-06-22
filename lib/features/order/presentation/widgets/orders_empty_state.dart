import 'dart:math' as math;

import 'package:afterhours/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You have no orders yet',
            style: AppTextStyles.bodyMono.copyWith(
              color: AppColors.red,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),
          const SizedBox(
            width: 92,
            height: 92,
            child: CustomPaint(painter: EmptyOrderBagPainter()),
          ),
        ],
      ),
    );
  }
}

class EmptyOrderBagPainter extends CustomPainter {
  const EmptyOrderBagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(3, 8, size.width - 6, size.height - 12),
      const Radius.circular(18),
    );

    _drawDashedPath(canvas, Path()..addRRect(rect), paint);

    final handleRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.39),
      width: size.width * 0.46,
      height: size.height * 0.38,
    );
    _drawDashedPath(
      canvas,
      Path()..addArc(handleRect, math.pi, math.pi),
      paint,
      dashLength: 3,
      gapLength: 7,
    );

    final productArc = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.68),
      width: size.width * 0.48,
      height: size.height * 0.32,
    );
    canvas.drawArc(productArc, math.pi, math.pi, false, paint);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    double dashLength = 2,
    double gapLength = 9,
  }) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant EmptyOrderBagPainter oldDelegate) => false;
}
