import 'package:flutter/material.dart';

class KanpekiAccordion extends StatefulWidget {
  final List<AccordionItem> items;
  final List<int>? defaultExpandedKeys;
  final bool allowMultiple;
  final EdgeInsetsGeometry? padding;

  const KanpekiAccordion({
    super.key,
    required this.items,
    this.defaultExpandedKeys,
    this.allowMultiple = false,
    this.padding,
  });

  @override
  State<KanpekiAccordion> createState() => _KanpekiAccordionState();
}

class _KanpekiAccordionState extends State<KanpekiAccordion> {
  late Set<int> _expandedKeys;

  @override
  void initState() {
    super.initState();
    _expandedKeys = Set<int>.from(widget.defaultExpandedKeys ?? []);
  }

  void _toggleItem(int index) {
    setState(() {
      if (_expandedKeys.contains(index)) {
        _expandedKeys.remove(index);
      } else {
        if (!widget.allowMultiple) {
          _expandedKeys.clear();
        }
        _expandedKeys.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        children: widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isExpanded = _expandedKeys.contains(index);

          return KanpekiAccordionItemWidget(
            item: item,
            isExpanded: isExpanded,
            onToggle: () => _toggleItem(index),
            isLast: index == widget.items.length - 1,
          );
        }).toList(),
      ),
    );
  }
}

class AccordionItem {
  final String title;
  final Widget content;
  final IconData? icon;
  final Color? iconColor;

  AccordionItem({
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
  });
}

class KanpekiAccordionItemWidget extends StatefulWidget {
  final AccordionItem item;
  final bool isExpanded;
  final VoidCallback onToggle;
  final bool isLast;

  const KanpekiAccordionItemWidget({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onToggle,
    required this.isLast,
  });

  @override
  State<KanpekiAccordionItemWidget> createState() => _KanpekiAccordionItemWidgetState();
}

class _KanpekiAccordionItemWidgetState extends State<KanpekiAccordionItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(KanpekiAccordionItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: widget.isLast 
              ? BorderSide.none 
              : BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
        ),
      ),
      child: Column(
        children: [
          // Trigger Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onToggle,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    if (widget.item.icon != null) ...[
                      Icon(
                        widget.item.icon,
                        color: widget.item.iconColor ?? theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        widget.item.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _iconRotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _iconRotationAnimation.value * 3.14159,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 16),
              child: widget.item.content,
            ),
          ),
        ],
      ),
    );
  }
}

// Energy-specific Accordion for insights
class EnergyInsightsAccordion extends StatelessWidget {
  const EnergyInsightsAccordion({super.key});

  @override
  Widget build(BuildContext context) {
    return KanpekiAccordion(
      defaultExpandedKeys: const [0],
      items: [
        AccordionItem(
          title: 'Energy Patterns',
          icon: Icons.trending_up,
          iconColor: const Color(0xFF22C55E),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your energy levels are highest in the morning (9-11 AM) and tend to dip after lunch. Consider scheduling important tasks during your peak hours.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    'Peak hours: 9-11 AM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AccordionItem(
          title: 'Sleep Impact',
          icon: Icons.bedtime,
          iconColor: const Color(0xFF667eea),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your energy levels correlate strongly with sleep quality. Days following 7+ hours of sleep show 23% higher average energy.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF22C55E)),
                  SizedBox(width: 8),
                  Text(
                    'Optimal sleep: 7-8 hours',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF22C55E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AccordionItem(
          title: 'Activity Recommendations',
          icon: Icons.fitness_center,
          iconColor: const Color(0xFFF59E0B),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Based on your patterns, here are personalized recommendations:',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 12),
              _buildRecommendationItem('Morning workout', 'Boost energy for the day', Icons.fitness_center),
              _buildRecommendationItem('Afternoon walk', 'Combat post-lunch dip', Icons.directions_walk),
              _buildRecommendationItem('Evening meditation', 'Prepare for quality sleep', Icons.self_improvement),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationItem(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFF59E0B).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFF59E0B)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
