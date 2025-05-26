import 'package:flutter/material.dart';
import 'dart:math' as math;

class NumberTicker extends StatefulWidget {
  final double value;
  final int decimalPlaces;
  final TextStyle? textStyle;
  final Duration animationDuration;
  final Curve animationCurve;
  final String prefix;
  final String suffix;
  final NumberTickerDirection direction;

  const NumberTicker({
    super.key,
    required this.value,
    this.decimalPlaces = 0,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeInOut,
    this.prefix = '',
    this.suffix = '',
    this.direction = NumberTickerDirection.up,
  });

  @override
  State<NumberTicker> createState() => _NumberTickerState();
}

class _NumberTickerState extends State<NumberTicker>
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
      begin: widget.direction == NumberTickerDirection.up ? 0 : widget.value,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(NumberTicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _animation.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ));
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (widget.decimalPlaces == 0) {
      return value.round().toString();
    } else {
      return value.toStringAsFixed(widget.decimalPlaces);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_formatNumber(_animation.value)}${widget.suffix}',
          style: widget.textStyle,
        );
      },
    );
  }
}

enum NumberTickerDirection { up, down }

// Specialized Energy Number Ticker
class EnergyNumberTicker extends StatelessWidget {
  final double energyValue;
  final TextStyle? textStyle;
  final bool showDecimal;

  const EnergyNumberTicker({
    super.key,
    required this.energyValue,
    this.textStyle,
    this.showDecimal = true,
  });

  @override
  Widget build(BuildContext context) {
    return NumberTicker(
      value: energyValue,
      decimalPlaces: showDecimal ? 1 : 0,
      textStyle: textStyle ??
          const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF667eea),
          ),
      animationDuration: const Duration(milliseconds: 800),
      animationCurve: Curves.easeOutBack,
    );
  }
}

// Animated Counter with custom styling
class AnimatedCounter extends StatefulWidget {
  final int value;
  final TextStyle? textStyle;
  final Duration animationDuration;
  final Widget? prefix;
  final Widget? suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 600),
    this.prefix,
    this.suffix,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = IntTween(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _animation.value;
      _animation = IntTween(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.reset();
      _controller.forward();
    }
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.prefix != null) widget.prefix!,
            Text(
              _animation.value.toString(),
              style: widget.textStyle,
            ),
            if (widget.suffix != null) widget.suffix!,
          ],
        );
      },
    );
  }
}

// Rolling Number Display
class RollingNumber extends StatefulWidget {
  final int value;
  final TextStyle? textStyle;
  final Duration animationDuration;
  final int rollCount;

  const RollingNumber({
    super.key,
    required this.value,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.rollCount = 3,
  });

  @override
  State<RollingNumber> createState() => _RollingNumberState();
}

class _RollingNumberState extends State<RollingNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(RollingNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _controller.reset();
      _controller.forward();
    }
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
        final currentValue = (_previousValue + 
            (_animation.value * (widget.value - _previousValue))).round();
        
        return Text(
          currentValue.toString(),
          style: widget.textStyle,
        );
      },
    );
  }
}

// Percentage Ticker
class PercentageTicker extends StatelessWidget {
  final double percentage;
  final TextStyle? textStyle;
  final bool showPercentSign;

  const PercentageTicker({
    super.key,
    required this.percentage,
    this.textStyle,
    this.showPercentSign = true,
  });

  @override
  Widget build(BuildContext context) {
    return NumberTicker(
      value: percentage,
      decimalPlaces: 1,
      suffix: showPercentSign ? '%' : '',
      textStyle: textStyle,
      animationDuration: const Duration(milliseconds: 800),
      animationCurve: Curves.easeOutCubic,
    );
  }
}
