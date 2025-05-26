import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedCircularProgress extends StatefulWidget {
  final double value;
  final double max;
  final double min;
  final double size;
  final double strokeWidth;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Widget? child;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showPercentage;
  final TextStyle? textStyle;

  const AnimatedCircularProgress({
    super.key,
    required this.value,
    this.max = 100,
    this.min = 0,
    this.size = 120,
    this.strokeWidth = 8,
    this.primaryColor = const Color(0xFF667eea),
    this.secondaryColor = const Color(0xFF764ba2),
    this.backgroundColor = const Color(0xFFE5E7EB),
    this.child,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeInOut,
    this.showPercentage = true,
    this.textStyle,
  });

  @override
  State<AnimatedCircularProgress> createState() => _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: _normalizedValue,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.max != widget.max ||
        oldWidget.min != widget.min) {
      _previousValue = _animation.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: _normalizedValue,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ));
      _animationController.reset();
      _animationController.forward();
    }
  }

  double get _normalizedValue {
    return ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: CircularProgressPainter(
              progress: _animation.value,
              strokeWidth: widget.strokeWidth,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
              backgroundColor: widget.backgroundColor,
            ),
            child: Center(
              child: widget.child ??
                  (widget.showPercentage
                      ? Text(
                          '${(_animation.value * (widget.max - widget.min) + widget.min).round()}',
                          style: widget.textStyle ??
                              TextStyle(
                                fontSize: widget.size * 0.15,
                                fontWeight: FontWeight.bold,
                                color: widget.primaryColor,
                              ),
                        )
                      : null),
            ),
          );
        },
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Start from top
        sweepAngle,
        false,
        progressPaint,
      );

      // Glow effect
      final glowPaint = Paint()
        ..color = primaryColor.withOpacity(0.3)
        ..strokeWidth = strokeWidth + 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CircularProgressPainter &&
        other.progress == progress &&
        other.strokeWidth == strokeWidth &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return progress.hashCode ^
        strokeWidth.hashCode ^
        primaryColor.hashCode ^
        secondaryColor.hashCode ^
        backgroundColor.hashCode;
  }
}

// Energy Level Circular Progress variant
class EnergyCircularProgress extends StatelessWidget {
  final int energyLevel;
  final double size;
  final bool showLabel;

  const EnergyCircularProgress({
    super.key,
    required this.energyLevel,
    this.size = 120,
    this.showLabel = true,
  });

  Color get _energyColor {
    if (energyLevel <= 2) return const Color(0xFFEF4444); // Red
    if (energyLevel <= 4) return const Color(0xFFF97316); // Orange
    if (energyLevel <= 6) return const Color(0xFFEAB308); // Yellow
    if (energyLevel <= 8) return const Color(0xFF84CC16); // Light Green
    return const Color(0xFF22C55E); // Green
  }

  Color get _secondaryColor {
    if (energyLevel <= 2) return const Color(0xFFFCA5A5);
    if (energyLevel <= 4) return const Color(0xFFFED7AA);
    if (energyLevel <= 6) return const Color(0xFFFEF08A);
    if (energyLevel <= 8) return const Color(0xFFBEF264);
    return const Color(0xFF86EFAC);
  }

  String get _energyLabel {
    if (energyLevel <= 2) return 'Low';
    if (energyLevel <= 4) return 'Below Average';
    if (energyLevel <= 6) return 'Average';
    if (energyLevel <= 8) return 'High';
    return 'Excellent';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedCircularProgress(
          value: energyLevel.toDouble(),
          max: 10,
          min: 0,
          size: size,
          primaryColor: _energyColor,
          secondaryColor: _secondaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                energyLevel.toString(),
                style: TextStyle(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.bold,
                  color: _energyColor,
                ),
              ),
              Text(
                '/10',
                style: TextStyle(
                  fontSize: size * 0.08,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 8),
          Text(
            _energyLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _energyColor,
            ),
          ),
        ],
      ],
    );
  }
}
