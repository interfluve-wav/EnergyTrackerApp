import 'package:flutter/material.dart';
import 'dart:math' as math;

class MagicCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final Color spotlightColor;
  final double maskSize;
  final bool enableSpotlight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const MagicCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.borderColor = const Color(0xFF7877C6),
    this.borderWidth = 1.0,
    this.spotlightColor = const Color(0x147877C6),
    this.maskSize = 200.0,
    this.enableSpotlight = true,
    this.padding,
    this.margin,
  });

  @override
  State<MagicCard> createState() => _MagicCardState();
}

class _MagicCardState extends State<MagicCard>
    with SingleTickerProviderStateMixin {
  Offset? _mousePosition;
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
          _animationController.forward();
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
            _mousePosition = null;
          });
          _animationController.reverse();
        },
        onHover: (event) {
          setState(() {
            _mousePosition = event.localPosition;
          });
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: widget.borderColor.withOpacity(
                    0.3 + (_animation.value * 0.7),
                  ),
                  width: widget.borderWidth,
                ),
                boxShadow: [
                  if (_isHovered && widget.enableSpotlight)
                    BoxShadow(
                      color: widget.borderColor.withOpacity(0.3 * _animation.value),
                      blurRadius: 20 * _animation.value,
                      spreadRadius: 2 * _animation.value,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Stack(
                  children: [
                    // Background with spotlight effect
                    if (_isHovered && widget.enableSpotlight && _mousePosition != null)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: SpotlightPainter(
                            mousePosition: _mousePosition!,
                            spotlightColor: widget.spotlightColor,
                            maskSize: widget.maskSize,
                            opacity: _animation.value,
                          ),
                        ),
                      ),
                    // Content
                    Container(
                      padding: widget.padding,
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SpotlightPainter extends CustomPainter {
  final Offset mousePosition;
  final Color spotlightColor;
  final double maskSize;
  final double opacity;

  SpotlightPainter({
    required this.mousePosition,
    required this.spotlightColor,
    required this.maskSize,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topLeft,
        radius: 1.0,
        colors: [
          spotlightColor.withOpacity(opacity),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: mousePosition,
          radius: maskSize,
        ),
      );

    canvas.drawCircle(mousePosition, maskSize, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpotlightPainter &&
        other.mousePosition == mousePosition &&
        other.spotlightColor == spotlightColor &&
        other.maskSize == maskSize &&
        other.opacity == opacity;
  }

  @override
  int get hashCode {
    return mousePosition.hashCode ^
        spotlightColor.hashCode ^
        maskSize.hashCode ^
        opacity.hashCode;
  }
}

// Gradient Magic Card variant
class GradientMagicCard extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GradientMagicCard({
    super.key,
    required this.child,
    this.gradientColors = const [
      Color(0xFF667eea),
      Color(0xFF764ba2),
    ],
    this.borderRadius = 16.0,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }
}

// Neon Gradient Card variant
class NeonGradientCard extends StatefulWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double glowIntensity;

  const NeonGradientCard({
    super.key,
    required this.child,
    this.gradientColors = const [
      Color(0xFF00D4FF),
      Color(0xFF5200FF),
    ],
    this.borderRadius = 16.0,
    this.padding,
    this.margin,
    this.glowIntensity = 0.6,
  });

  @override
  State<NeonGradientCard> createState() => _NeonGradientCardState();
}

class _NeonGradientCardState extends State<NeonGradientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.first.withOpacity(
                  widget.glowIntensity * _animation.value,
                ),
                blurRadius: 30 * _animation.value,
                spreadRadius: 2 * _animation.value,
              ),
              BoxShadow(
                color: widget.gradientColors.last.withOpacity(
                  widget.glowIntensity * _animation.value * 0.7,
                ),
                blurRadius: 20 * _animation.value,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            padding: widget.padding,
            child: widget.child,
          ),
        );
      },
    );
  }
}
