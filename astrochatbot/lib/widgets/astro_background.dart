import 'dart:math';
import 'package:flutter/material.dart';

class AstroBackground extends StatelessWidget {
  final Widget child;

  const AstroBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF6A623),
                Color(0xFFFFF3D6), 
              ],
            ),
          ),
        ),
        
        Positioned.fill(
          child: CustomPaint(
            painter: _StarPainter(),
          ),
        ),
        
        SafeArea(child: child),
      ],
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);
    final random = Random(42); 

    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1; 
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}