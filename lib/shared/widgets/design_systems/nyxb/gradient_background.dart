import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double>? stops;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF667eea),
      Color(0xFF764ba2),
    ],
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
        ),
      ),
      child: child,
    );
  }
}

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<List<Color>> gradients;
  final Duration duration;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.gradients = const [
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFFf093fb), Color(0xFFf5576c)],
      [Color(0xFF4facfe), Color(0xFF00f2fe)],
    ],
    this.duration = const Duration(seconds: 4),
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentGradientIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentGradientIndex = (_currentGradientIndex + 1) % widget.gradients.length;
        });
        _controller.reset();
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentGradient = widget.gradients[_currentGradientIndex];
    final nextGradient = widget.gradients[(_currentGradientIndex + 1) % widget.gradients.length];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.begin,
              end: widget.end,
              colors: [
                Color.lerp(currentGradient[0], nextGradient[0], _animation.value)!,
                Color.lerp(currentGradient[1], nextGradient[1], _animation.value)!,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class WarpBackground extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final double intensity;

  const WarpBackground({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFF667eea),
    this.intensity = 0.3,
  });

  @override
  State<WarpBackground> createState() => _WarpBackgroundState();
}

class _WarpBackgroundState extends State<WarpBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _controller2 = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    
    _controller3 = AnimationController(
      duration: const Duration(seconds: 16),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 2.0,
              colors: [
                widget.baseColor.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: Listenable.merge([_controller1, _controller2, _controller3]),
          builder: (context, child) {
            return CustomPaint(
              painter: WarpPainter(
                animation1: _controller1.value,
                animation2: _controller2.value,
                animation3: _controller3.value,
                baseColor: widget.baseColor,
                intensity: widget.intensity,
              ),
              child: widget.child,
            );
          },
        ),
      ],
    );
  }
}

class WarpPainter extends CustomPainter {
  final double animation1;
  final double animation2;
  final double animation3;
  final Color baseColor;
  final double intensity;

  WarpPainter({
    required this.animation1,
    required this.animation2,
    required this.animation3,
    required this.baseColor,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // First warp circle
    final center1 = Offset(
      size.width * (0.3 + 0.4 * math.sin(animation1 * 2 * math.pi)),
      size.height * (0.3 + 0.4 * math.cos(animation1 * 2 * math.pi)),
    );
    
    paint.shader = RadialGradient(
      colors: [
        baseColor.withOpacity(intensity),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: center1, radius: 150));
    
    canvas.drawCircle(center1, 150, paint);

    // Second warp circle
    final center2 = Offset(
      size.width * (0.7 + 0.3 * math.sin(animation2 * 2 * math.pi + math.pi)),
      size.height * (0.7 + 0.3 * math.cos(animation2 * 2 * math.pi + math.pi)),
    );
    
    paint.shader = RadialGradient(
      colors: [
        baseColor.withOpacity(intensity * 0.7),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: center2, radius: 120));
    
    canvas.drawCircle(center2, 120, paint);

    // Third warp circle
    final center3 = Offset(
      size.width * (0.5 + 0.2 * math.sin(animation3 * 2 * math.pi + math.pi / 2)),
      size.height * (0.5 + 0.2 * math.cos(animation3 * 2 * math.pi + math.pi / 2)),
    );
    
    paint.shader = RadialGradient(
      colors: [
        baseColor.withOpacity(intensity * 0.5),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: center3, radius: 100));
    
    canvas.drawCircle(center3, 100, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DotPattern extends StatelessWidget {
  final Widget child;
  final Color dotColor;
  final double dotSize;
  final double spacing;
  final double opacity;

  const DotPattern({
    super.key,
    required this.child,
    this.dotColor = const Color(0xFF667eea),
    this.dotSize = 2.0,
    this.spacing = 20.0,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: DotPatternPainter(
              dotColor: dotColor.withOpacity(opacity),
              dotSize: dotSize,
              spacing: spacing,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class DotPatternPainter extends CustomPainter {
  final Color dotColor;
  final double dotSize;
  final double spacing;

  DotPatternPainter({
    required this.dotColor,
    required this.dotSize,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
