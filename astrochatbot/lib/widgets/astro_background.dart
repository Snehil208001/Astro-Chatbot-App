import 'dart:math';
import 'package:flutter/material.dart';

class AstroBackground extends StatelessWidget {
  final Widget child;

  const AstroBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. The Gradient Background
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF6A623), // Amber/Orange Top
                Color(0xFFFFF3D6), // Pastel Cream Bottom
              ],
            ),
          ),
        ),
        
        // 2. The Star Particles
        Positioned.fill(
          child: CustomPaint(
            painter: _StarPainter(),
          ),
        ),
        
        // 3. The Content (Your buttons, text, etc.)
        SafeArea(child: child),
      ],
    );
  }
}

// Helper class to draw random stars
class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);
    final random = Random(42); // Fixed seed so stars stay in same place

    // Draw 60 random small stars
    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1; // Size between 1 and 3
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}