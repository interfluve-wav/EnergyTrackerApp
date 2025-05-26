import 'package:flutter/material.dart';
import 'dart:math' as math;

class CultTextureButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textureColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Size? minimumSize;
  final bool enabled;

  const CultTextureButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor = const Color(0xFF667eea),
    this.textureColor = Colors.white,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.minimumSize,
    this.enabled = true,
  });

  @override
  State<CultTextureButton> createState() => _CultTextureButtonState();
}

class _CultTextureButtonState extends State<CultTextureButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textureAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _textureAnimation = Tween<double>(
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

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enabled) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enabled) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.enabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              constraints: widget.minimumSize != null
                  ? BoxConstraints(
                      minWidth: widget.minimumSize!.width,
                      minHeight: widget.minimumSize!.height,
                    )
                  : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.3),
                    blurRadius: 8 * (1 - _scaleAnimation.value),
                    offset: Offset(0, 4 * (1 - _scaleAnimation.value)),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Stack(
                  children: [
                    // Base background
                    Container(
                      padding: widget.padding,
                      decoration: BoxDecoration(
                        color: widget.enabled 
                            ? widget.backgroundColor 
                            : widget.backgroundColor.withOpacity(0.5),
                      ),
                      child: Center(child: widget.child),
                    ),
                    
                    // Texture overlay
                    Positioned.fill(
                      child: CustomPaint(
                        painter: TexturePainter(
                          textureColor: widget.textureColor,
                          opacity: _textureAnimation.value * 0.1,
                        ),
                      ),
                    ),
                    
                    // Shine effect
                    if (_isPressed)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.transparent,
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TexturePainter extends CustomPainter {
  final Color textureColor;
  final double opacity;

  TexturePainter({
    required this.textureColor,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = textureColor.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern
    
    // Create a subtle dot texture
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 0.5;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TexturePainter &&
        other.textureColor == textureColor &&
        other.opacity == opacity;
  }

  @override
  int get hashCode => textureColor.hashCode ^ opacity.hashCode;
}

// Energy-specific texture buttons
class EnergyActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  const EnergyActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CultTextureButton(
      onPressed: onPressed,
      backgroundColor: color ?? const Color(0xFF667eea),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Energy level selector with texture buttons
class EnergyLevelTextureSelector extends StatefulWidget {
  final Function(int)? onEnergySelected;
  final int? selectedLevel;

  const EnergyLevelTextureSelector({
    super.key,
    this.onEnergySelected,
    this.selectedLevel,
  });

  @override
  State<EnergyLevelTextureSelector> createState() => _EnergyLevelTextureSelectorState();
}

class _EnergyLevelTextureSelectorState extends State<EnergyLevelTextureSelector> {
  int? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.selectedLevel;
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(10, (index) {
        final level = index + 1;
        final isSelected = _selectedLevel == level;
        
        return CultTextureButton(
          onPressed: () {
            setState(() => _selectedLevel = level);
            widget.onEnergySelected?.call(level);
          },
          backgroundColor: isSelected 
              ? _getEnergyColor(level) 
              : Colors.grey.withOpacity(0.3),
          borderRadius: 8,
          padding: const EdgeInsets.all(12),
          child: Text(
            level.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}

// Quick action buttons for energy tracking
class EnergyQuickActions extends StatelessWidget {
  const EnergyQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: EnergyActionButton(
                label: 'Log Energy',
                icon: Icons.add,
                color: const Color(0xFF667eea),
                onPressed: () {
                  // Handle log energy
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: EnergyActionButton(
                label: 'View Trends',
                icon: Icons.trending_up,
                color: const Color(0xFF22C55E),
                onPressed: () {
                  // Handle view trends
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: EnergyActionButton(
                label: 'Insights',
                icon: Icons.lightbulb_outline,
                color: const Color(0xFFF59E0B),
                onPressed: () {
                  // Handle insights
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: EnergyActionButton(
                label: 'Settings',
                icon: Icons.settings,
                color: const Color(0xFF8B5CF6),
                onPressed: () {
                  // Handle settings
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
