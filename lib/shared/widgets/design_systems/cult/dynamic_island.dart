import 'package:flutter/material.dart';

enum DynamicIslandSize {
  compact,
  expanded,
  large,
  minimal,
}

class CultDynamicIsland extends StatefulWidget {
  final DynamicIslandSize size;
  final Widget child;
  final Duration animationDuration;
  final Color backgroundColor;
  final double? width;
  final double? height;

  const CultDynamicIsland({
    super.key,
    required this.size,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300),
    this.backgroundColor = Colors.black,
    this.width,
    this.height,
  });

  @override
  State<CultDynamicIsland> createState() => _CultDynamicIslandState();
}

class _CultDynamicIslandState extends State<CultDynamicIsland>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _borderRadiusAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _borderRadiusAnimation = Tween<double>(
      begin: 22.0,
      end: _getBorderRadius(widget.size),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(CultDynamicIsland oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size) {
      _borderRadiusAnimation = Tween<double>(
        begin: _borderRadiusAnimation.value,
        end: _getBorderRadius(widget.size),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _getBorderRadius(DynamicIslandSize size) {
    switch (size) {
      case DynamicIslandSize.minimal:
        return 22.0;
      case DynamicIslandSize.compact:
        return 25.0;
      case DynamicIslandSize.expanded:
        return 20.0;
      case DynamicIslandSize.large:
        return 16.0;
    }
  }

  Size _getSize(DynamicIslandSize size) {
    switch (size) {
      case DynamicIslandSize.minimal:
        return const Size(44, 44);
      case DynamicIslandSize.compact:
        return const Size(200, 44);
      case DynamicIslandSize.expanded:
        return const Size(300, 80);
      case DynamicIslandSize.large:
        return const Size(350, 120);
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetSize = _getSize(widget.size);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return AnimatedContainer(
          duration: widget.animationDuration,
          width: widget.width ?? targetSize.width,
          height: widget.height ?? targetSize.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}

// Energy-specific Dynamic Island
class EnergyDynamicIsland extends StatefulWidget {
  final int energyLevel;
  final String? status;
  final VoidCallback? onTap;

  const EnergyDynamicIsland({
    super.key,
    required this.energyLevel,
    this.status,
    this.onTap,
  });

  @override
  State<EnergyDynamicIsland> createState() => _EnergyDynamicIslandState();
}

class _EnergyDynamicIslandState extends State<EnergyDynamicIsland> {
  DynamicIslandSize _currentSize = DynamicIslandSize.compact;
  bool _isExpanded = false;

  void _toggleSize() {
    setState(() {
      _isExpanded = !_isExpanded;
      _currentSize = _isExpanded 
          ? DynamicIslandSize.expanded 
          : DynamicIslandSize.compact;
    });
  }

  Color _getEnergyColor(int level) {
    if (level <= 2) return const Color(0xFFEF4444);
    if (level <= 4) return const Color(0xFFF97316);
    if (level <= 6) return const Color(0xFFEAB308);
    if (level <= 8) return const Color(0xFF84CC16);
    return const Color(0xFF22C55E);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleSize();
        widget.onTap?.call();
      },
      child: CultDynamicIsland(
        size: _currentSize,
        backgroundColor: Colors.black.withOpacity(0.9),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isExpanded ? _buildExpandedContent() : _buildCompactContent(),
        ),
      ),
    );
  }

  Widget _buildCompactContent() {
    return Container(
      key: const ValueKey('compact'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getEnergyColor(widget.energyLevel),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Energy',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            '${widget.energyLevel}/10',
            style: TextStyle(
              color: _getEnergyColor(widget.energyLevel),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      key: const ValueKey('expanded'),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getEnergyColor(widget.energyLevel),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.energyLevel.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Energy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.status ?? _getEnergyStatus(widget.energyLevel),
                      style: TextStyle(
                        color: _getEnergyColor(widget.energyLevel),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                _getEnergyIcon(widget.energyLevel),
                color: _getEnergyColor(widget.energyLevel),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getEnergyStatus(int level) {
    if (level <= 2) return 'Very Low';
    if (level <= 4) return 'Low';
    if (level <= 6) return 'Moderate';
    if (level <= 8) return 'High';
    return 'Excellent';
  }

  IconData _getEnergyIcon(int level) {
    if (level <= 2) return Icons.battery_0_bar;
    if (level <= 4) return Icons.battery_2_bar;
    if (level <= 6) return Icons.battery_4_bar;
    if (level <= 8) return Icons.battery_6_bar;
    return Icons.battery_full;
  }
}

// Floating Energy Status Widget
class FloatingEnergyStatus extends StatelessWidget {
  final int energyLevel;
  final String? customMessage;

  const FloatingEnergyStatus({
    super.key,
    required this.energyLevel,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Center(
        child: EnergyDynamicIsland(
          energyLevel: energyLevel,
          status: customMessage,
          onTap: () {
            // Handle tap - could show detailed energy info
          },
        ),
      ),
    );
  }
}
