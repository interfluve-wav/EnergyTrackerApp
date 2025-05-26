# Quick Reference - Energy Tracker

## 🚀 Quick Start Guide

### When Opening a New Chat Session
1. **Read this file first** to understand the current project state
2. **Check `FEATURE_IMPLEMENTATION_STATUS.md`** for what's completed vs pending
3. **Review `COMPONENT_ARCHITECTURE.md`** for component locations and usage
4. **Look at `DESIGN_SYSTEM_MAPPING.md`** for design system details

### Project Status at a Glance
- **Platform**: Flutter Desktop Application
- **Design Systems**: Nyxb UI + Kanpeki UI + Cult UI (all adapted to Flutter)
- **Current Version**: 1.0.0 (Core features implemented)
- **Completion**: ~60% (UI complete, some backend features pending)

## 📁 Key File Locations

### Core Application Files
```
lib/
├── main.dart                           # Desktop app entry point
├── screens/desktop_home_screen.dart    # Main desktop layout
├── providers/energy_provider.dart     # State management
└── models/energy_entry.dart           # Data models
```

### Design System Components
```
lib/widgets/
├── nyxb/                              # Magical effects & animations
│   ├── magic_card.dart                # Interactive cards with spotlight
│   ├── animated_circular_progress.dart # Circular progress indicators
│   ├── number_ticker.dart             # Animated number displays
│   ├── shimmer_button.dart            # Shimmer effect buttons
│   └── gradient_background.dart       # Animated backgrounds
├── kanpeki/                           # Professional, accessible components
│   ├── accordion.dart                 # Collapsible content sections
│   └── card.dart                      # Professional card components
├── cult/                              # Modern, dynamic interactions
│   ├── dynamic_island.dart            # Floating status indicators
│   └── texture_button.dart            # Interactive texture buttons
└── desktop/                           # Desktop-specific components
    ├── custom_title_bar.dart          # Window title bar
    └── sidebar_navigation.dart        # Desktop navigation
```

## 🎨 Design System Quick Reference

### Nyxb UI Components (Magical Effects)
```dart
// Magic Card with spotlight effect
MagicCard(
  borderColor: Color(0xFF667eea),
  spotlightColor: Color(0x33667eea),
  child: YourContent(),
)

// Animated circular progress
EnergyCircularProgress(
  energyLevel: 7,
  size: 120,
)

// Animated number ticker
EnergyNumberTicker(
  energyValue: 7.2,
  showDecimal: true,
)

// Shimmer button
ShimmerButton(
  onPressed: () {},
  backgroundColor: Color(0xFF667eea),
  child: Text('Click Me'),
)
```

### Kanpeki UI Components (Professional)
```dart
// Accordion with smooth animations
KanpekiAccordion(
  items: [
    AccordionItem(
      title: 'Energy Patterns',
      icon: Icons.trending_up,
      content: YourContent(),
    ),
  ],
)

// Professional metric card
EnergyMetricCard(
  title: 'Today\'s Average',
  value: '7.2',
  icon: Icons.trending_up,
  iconColor: Colors.green,
)

// Insight card with action
EnergyInsightCard(
  title: 'Peak Performance',
  description: 'Your energy peaks at 9-11 AM',
  icon: Icons.lightbulb,
  color: Colors.amber,
  actionText: 'View Tips',
  onAction: () {},
)
```

### Cult UI Components (Dynamic)
```dart
// Dynamic Island (floating status)
EnergyDynamicIsland(
  energyLevel: 7,
  status: 'High Energy',
  onTap: () {},
)

// Texture button with effects
EnergyActionButton(
  label: 'Log Energy',
  icon: Icons.add,
  color: Color(0xFF667eea),
  onPressed: () {},
)

// Energy level selector
EnergyLevelTextureSelector(
  onEnergySelected: (level) {},
  selectedLevel: 7,
)
```

## 🎯 Energy Level System

### Color Coding (Used Throughout App)
```dart
// Energy level colors
1-2:  Color(0xFFEF4444)  // Red - Very Low/Low
3-4:  Color(0xFFF97316)  // Orange - Below Average
5-6:  Color(0xFFEAB308)  // Yellow - Average/Moderate
7-8:  Color(0xFF84CC16)  // Light Green - High
9-10: Color(0xFF22C55E)  // Green - Very High/Excellent
```

### Theme Colors
```dart
primary:    Color(0xFF667eea)  // Blue
secondary:  Color(0xFF764ba2)  // Purple
success:    Color(0xFF22c55e)  // Green
warning:    Color(0xFFF59e0b)  // Orange
danger:     Color(0xFFef4444)  // Red
background: Color(0xFF0f0f23)  // Dark Blue
```

## 📊 State Management

### Energy Provider Usage
```dart
// Access energy data
Consumer<EnergyProvider>(
  builder: (context, energyProvider, child) {
    return Column(
      children: [
        Text('Today: ${energyProvider.todayAverageEnergy}'),
        Text('Weekly: ${energyProvider.weeklyAverageEnergy}'),
        Text('Entries: ${energyProvider.todayEntries.length}'),
        Text('Trend: ${energyProvider.energyTrend}'),
      ],
    );
  },
)

// Add new energy entry
final provider = Provider.of<EnergyProvider>(context, listen: false);
provider.addEnergyEntry(EnergyEntry(
  timestamp: DateTime.now(),
  energyLevel: 7,
  notes: 'Feeling great after workout',
));
```

## 🖥️ Desktop Layout Structure

### Main Layout Hierarchy
```
WarpBackground (Nyxb - animated background)
├── CustomTitleBar (Desktop - window controls)
├── Row
│   ├── SidebarNavigation (Desktop - navigation)
│   └── Content Area (varies by selected tab)
└── FloatingEnergyStatus (Cult - Dynamic Island)
```

### Navigation Tabs
- **Index 0**: Dashboard (main energy display)
- **Index 1**: History (placeholder)
- **Index 2**: Analytics (placeholder)
- **Index 3**: Insights (accordion with recommendations)
- **Index 4**: Settings (placeholder)

## ✅ What's Working

### Fully Implemented
- ✅ Desktop window management
- ✅ Energy logging with 1-10 scale
- ✅ Visual energy indicators (circular progress, numbers)
- ✅ Floating Dynamic Island status
- ✅ Professional sidebar navigation
- ✅ Insights with expandable accordion
- ✅ Hover effects and animations
- ✅ State management with Provider
- ✅ Sample data generation

### UI Components (All Working)
- ✅ All Nyxb UI components (20+ widgets)
- ✅ All Kanpeki UI components (accordion, cards)
- ✅ All Cult UI components (dynamic island, texture buttons)
- ✅ Desktop-specific components (title bar, sidebar)

## 🚧 What Needs Work

### High Priority
- 🚧 **Database Integration** - Currently using sample data
- 🚧 **Chart Implementation** - fl_chart integration needed
- 🚧 **Settings Screen** - User preferences

### Medium Priority
- 📝 **Enhanced History** - Full history view with filtering
- 📝 **Mood Correlation** - Add mood tracking
- 📝 **Advanced Analytics** - Pattern recognition

### Low Priority
- ❌ **Notifications** - Desktop reminders
- ❌ **Social Features** - Sharing, gamification
- ❌ **Lifestyle Integration** - Meals, exercise, weather

## 🔧 Development Commands

### Running the App
```bash
# Desktop (Windows/macOS/Linux)
flutter run -d windows
flutter run -d macos
flutter run -d linux

# Debug mode with hot reload
flutter run --debug

# Release mode
flutter run --release
```

### Dependencies
```bash
# Install dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Add new dependency
flutter pub add package_name
```

## 📝 Common Tasks

### Adding a New Component
1. Choose appropriate design system (nyxb/kanpeki/cult)
2. Create widget file in correct directory
3. Follow existing naming conventions
4. Add energy-specific variant if needed
5. Update documentation

### Modifying Energy Display
- **Main display**: `desktop_home_screen.dart` → Dashboard tab
- **Circular progress**: `animated_circular_progress.dart`
- **Number ticker**: `number_ticker.dart`
- **Dynamic Island**: `dynamic_island.dart`

### Adding New Insights
- **Accordion content**: `accordion.dart` → `EnergyInsightsAccordion`
- **Insight cards**: `card.dart` → `EnergyInsightCard`
- **Data logic**: `energy_provider.dart`

## 🎨 Animation Timing Reference

### Standard Durations
- **Fast interactions**: 150-200ms (button presses, hovers)
- **Content transitions**: 200-300ms (accordion, card states)
- **Background effects**: 8-20s (warp background, shimmer)

### Easing Curves
- **Nyxb UI**: `Curves.easeInOut` (magical effects)
- **Kanpeki UI**: `Curves.easeInOut` (professional feel)
- **Cult UI**: `Curves.easeOutBack` (dynamic interactions)

## 🐛 Common Issues & Solutions

### Desktop Window Issues
- **Problem**: Window not showing
- **Solution**: Check `window_manager` and `bitsdojo_window` setup in `main.dart`

### Animation Performance
- **Problem**: Laggy animations
- **Solution**: Check `shouldRepaint` in CustomPainter widgets

### State Not Updating
- **Problem**: UI not reflecting data changes
- **Solution**: Ensure `Consumer<EnergyProvider>` wraps widgets that need updates

---

**💡 Pro Tip**: Always check the documentation files in `docs/` for detailed information about any component or feature!

**Last Updated**: December 2024
