import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // App Icon and Title
          Expanded(
            child: MoveWindow(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.energy_savings_leaf,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Energy Tracker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Window Controls
          Row(
            children: [
              WindowButton(
                colors: WindowButtonColors(
                  iconNormal: Colors.white.withOpacity(0.7),
                  iconMouseOver: Colors.white,
                  mouseOver: Colors.white.withOpacity(0.1),
                  mouseDown: Colors.white.withOpacity(0.2),
                ),
                onPressed: () => appWindow.minimize(),
                iconBuilder: (buttonContext) => MinimizeIcon(
                  color: buttonContext.iconColor,
                ),
              ),
              WindowButton(
                colors: WindowButtonColors(
                  iconNormal: Colors.white.withOpacity(0.7),
                  iconMouseOver: Colors.white,
                  mouseOver: Colors.white.withOpacity(0.1),
                  mouseDown: Colors.white.withOpacity(0.2),
                ),
                onPressed: () => appWindow.maximizeOrRestore(),
                iconBuilder: (buttonContext) => MaximizeIcon(
                  color: buttonContext.iconColor,
                ),
              ),
              WindowButton(
                colors: WindowButtonColors(
                  iconNormal: Colors.white.withOpacity(0.7),
                  iconMouseOver: Colors.white,
                  mouseOver: const Color(0xFFEF4444),
                  mouseDown: const Color(0xFFDC2626),
                ),
                onPressed: () => appWindow.close(),
                iconBuilder: (buttonContext) => CloseIcon(
                  color: buttonContext.iconColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WindowButton extends StatefulWidget {
  final WindowButtonColors colors;
  final VoidCallback? onPressed;
  final Widget Function(WindowButtonContext) iconBuilder;

  const WindowButton({
    super.key,
    required this.colors,
    this.onPressed,
    required this.iconBuilder,
  });

  @override
  State<WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<WindowButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    Color iconColor = widget.colors.iconNormal ?? Colors.white;

    if (_isPressed) {
      backgroundColor = widget.colors.mouseDown ?? Colors.transparent;
      iconColor = widget.colors.iconMouseDown ?? iconColor;
    } else if (_isHovered) {
      backgroundColor = widget.colors.mouseOver ?? Colors.transparent;
      iconColor = widget.colors.iconMouseOver ?? iconColor;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: Container(
          width: 46,
          height: 50,
          color: backgroundColor,
          child: Center(
            child: widget.iconBuilder(
              WindowButtonContext(iconColor: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}

class WindowButtonContext {
  final Color iconColor;
  
  WindowButtonContext({required this.iconColor});
}

class WindowButtonColors {
  final Color? iconNormal;
  final Color? iconMouseOver;
  final Color? iconMouseDown;
  final Color? mouseOver;
  final Color? mouseDown;

  WindowButtonColors({
    this.iconNormal,
    this.iconMouseOver,
    this.iconMouseDown,
    this.mouseOver,
    this.mouseDown,
  });
}

class MinimizeIcon extends StatelessWidget {
  final Color color;

  const MinimizeIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 1,
      color: color,
    );
  }
}

class MaximizeIcon extends StatelessWidget {
  final Color color;

  const MaximizeIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
      ),
    );
  }
}

class CloseIcon extends StatelessWidget {
  final Color color;

  const CloseIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      height: 10,
      child: CustomPaint(
        painter: CloseIconPainter(color: color),
      ),
    );
  }
}

class CloseIconPainter extends CustomPainter {
  final Color color;

  CloseIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
