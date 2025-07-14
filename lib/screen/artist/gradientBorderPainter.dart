import 'package:flutter/material.dart';

class GradientBorderAnimation extends StatefulWidget {
  @override
  _GradientBorderAnimationState createState() =>
      _GradientBorderAnimationState();
}

class _GradientBorderAnimationState extends State<GradientBorderAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: GradientBorderPainter(animationValue: _controller.value,borderRadius: 5),
              child: Container(
                width:100,
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  'Gradient Border',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final double animationValue;
 final double borderRadius;
  GradientBorderPainter({ required this.animationValue, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Define gradient
    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 6.28, // Full circle (2 * pi radians)
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
        Colors.red,
      ],
      stops: [
        animationValue,
        animationValue + 0.1,
        animationValue + 0.2,
        animationValue + 0.3,
        animationValue + 0.4,
        animationValue + 0.5,
        animationValue + 0.6,
      ],
      transform: GradientRotation(animationValue * 6.28), // Rotate gradient
    );
final rrect = RRect.fromRectAndRadius(
      rect.deflate(5.0), // Adjust for stroke width
      Radius.circular(borderRadius),
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
