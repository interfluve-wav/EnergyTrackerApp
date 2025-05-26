# Design System Mapping - Energy Tracker

## Overview
This document maps the original design systems (Nyxb UI, Kanpeki UI, Cult UI) to their Flutter implementations in the Energy Tracker project.

## Design System Sources

### 1. Nyxb UI
- **Website**: https://nyxbui.design/docs
- **Type**: React-based component library
- **Focus**: Magical effects, animations, modern aesthetics
- **Key Features**: Spotlight effects, gradient animations, shimmer effects

### 2. Kanpeki UI  
- **Website**: https://kanpeki.vercel.app/docs/components/accordion
- **Type**: React Aria Components
- **Focus**: Accessibility-first, professional UI
- **Key Features**: WAI-ARIA compliant, TypeScript support, clean design

### 3. Cult UI
- **Website**: https://cult-ui.com & https://github.com/nolly-studio/cult-ui
- **Type**: React + Framer Motion components
- **Focus**: Modern interactions, dynamic effects
- **Key Features**: Dynamic Island, texture effects, micro-animations

## Component Mapping

### Nyxb UI → Flutter Implementation

#### Magic Card
**Original**: React component with CSS hover effects
**Flutter**: `MagicCard` widget
**Location**: `lib/widgets/nyxb/magic_card.dart`
**Features**:
- Mouse hover spotlight effect
- Gradient borders
- Smooth animations
- Customizable colors and effects

```dart
// Usage Example
MagicCard(
  borderColor: Color(0xFF667eea),
  spotlightColor: Color(0x33667eea),
  child: YourContent(),
)
```

#### Animated Circular Progress
**Original**: CSS animations with SVG
**Flutter**: `AnimatedCircularProgress` widget
**Location**: `lib/widgets/nyxb/animated_circular_progress.dart`
**Features**:
- Gradient progress rings
- Smooth value transitions
- Customizable colors and sizes
- Energy-specific variant

```dart
// Usage Example
EnergyCircularProgress(
  energyLevel: 7,
  size: 120,
  showLabel: true,
)
```

#### Number Ticker
**Original**: JavaScript count animations
**Flutter**: `NumberTicker` widget
**Location**: `lib/widgets/nyxb/number_ticker.dart`
**Features**:
- Smooth count-up animations
- Decimal place support
- Custom easing curves
- Prefix/suffix support

```dart
// Usage Example
EnergyNumberTicker(
  energyValue: 7.2,
  showDecimal: true,
)
```

#### Shimmer Button
**Original**: CSS shimmer animations
**Flutter**: `ShimmerButton` widget
**Location**: `lib/widgets/nyxb/shimmer_button.dart`
**Features**:
- Continuous shimmer effect
- Press animations
- Customizable colors
- Disabled states

```dart
// Usage Example
ShimmerButton(
  onPressed: () {},
  backgroundColor: Color(0xFF667eea),
  child: Text('Click Me'),
)
```

#### Gradient Background
**Original**: CSS gradients with animations
**Flutter**: `WarpBackground` widget
**Location**: `lib/widgets/nyxb/gradient_background.dart`
**Features**:
- Animated gradient effects
- Multiple gradient layers
- Subtle movement animations
- Performance optimized

```dart
// Usage Example
WarpBackground(
  baseColor: Color(0xFF667eea),
  intensity: 0.15,
  child: YourContent(),
)
```

### Kanpeki UI → Flutter Implementation

#### Accordion
**Original**: React Aria Accordion with TypeScript
**Flutter**: `KanpekiAccordion` widget
**Location**: `lib/widgets/kanpeki/accordion.dart`
**Features**:
- Smooth expand/collapse animations
- Multiple or single item expansion
- Icon rotation animations
- Accessibility support

```dart
// Usage Example
KanpekiAccordion(
  allowMultiple: false,
  items: [
    AccordionItem(
      title: 'Energy Patterns',
      icon: Icons.trending_up,
      content: YourContent(),
    ),
  ],
)
```

#### Card Components
**Original**: Accessible card components
**Flutter**: `KanpekiCard` family
**Location**: `lib/widgets/kanpeki/card.dart`
**Features**:
- Hover elevation effects
- Consistent spacing
- Professional styling
- Multiple variants

```dart
// Usage Examples
EnergyMetricCard(
  title: 'Today\'s Average',
  value: '7.2',
  icon: Icons.trending_up,
  iconColor: Colors.green,
)

EnergyInsightCard(
  title: 'Peak Performance',
  description: 'Your energy peaks at 9-11 AM',
  icon: Icons.lightbulb,
  color: Colors.amber,
)
```

### Cult UI → Flutter Implementation

#### Dynamic Island
**Original**: CSS transforms with JavaScript
**Flutter**: `CultDynamicIsland` widget
**Location**: `lib/widgets/cult/dynamic_island.dart`
**Features**:
- Size transition animations
- Expandable content
- Hover effects
- Energy-specific variant

```dart
// Usage Example
EnergyDynamicIsland(
  energyLevel: 7,
  status: 'High Energy',
  onTap: () {},
)
```

#### Texture Button
**Original**: CSS textures with Framer Motion
**Flutter**: `CultTextureButton` widget
**Location**: `lib/widgets/cult/texture_button.dart`
**Features**:
- Subtle texture overlays
- Press animations
- Scale effects
- Custom textures

```dart
// Usage Example
EnergyActionButton(
  label: 'Log Energy',
  icon: Icons.add,
  color: Color(0xFF667eea),
  onPressed: () {},
)
```

## Screen-Level Integration

### Desktop Home Screen
**File**: `lib/screens/desktop_home_screen.dart`
**Design Systems Used**: All three
**Layout Structure**:
```
WarpBackground (Nyxb)
├── CustomTitleBar (Custom)
├── SidebarNavigation (Custom)
├── Content Area
│   ├── Dashboard Tab
│   │   ├── MagicCard (Nyxb) + EnergyCircularProgress (Nyxb)
│   │   ├── EnergyMetricCard (Kanpeki)
│   │   └── EnergyQuickActions (Cult)
│   ├── Insights Tab
│   │   ├── EnergyInsightCard (Kanpeki)
│   │   └── EnergyInsightsAccordion (Kanpeki)
│   └── Other Tabs (Placeholders)
└── FloatingEnergyStatus (Cult)
```

### Component Interaction Flow
1. **User opens app** → `WarpBackground` starts subtle animations
2. **User views dashboard** → `MagicCard` + `EnergyCircularProgress` show current energy
3. **User hovers cards** → `KanpekiCard` hover effects activate
4. **User clicks actions** → `CultTextureButton` press animations
5. **User views insights** → `KanpekiAccordion` expands with smooth animations
6. **Energy updates** → `EnergyDynamicIsland` shows floating status

## Animation Coordination

### Animation Timing
- **Fast interactions**: 150-200ms (button presses, hovers)
- **Content transitions**: 200-300ms (accordion, card states)
- **Background effects**: 8-20s (warp background, shimmer)

### Easing Curves
- **Nyxb UI**: `Curves.easeInOut` for magical effects
- **Kanpeki UI**: `Curves.easeInOut` for professional feel
- **Cult UI**: `Curves.easeOutBack` for dynamic interactions

## Color Coordination

### Primary Palette
```dart
// Shared across all design systems
primary: Color(0xFF667eea)      // Blue
secondary: Color(0xFF764ba2)    // Purple
success: Color(0xFF22c55e)      // Green
warning: Color(0xFFF59e0b)      // Orange
danger: Color(0xFFef4444)       // Red
```

### Energy Level Colors
```dart
// Used consistently across all components
1-2: Color(0xFFEF4444)  // Red
3-4: Color(0xFFF97316)  // Orange  
5-6: Color(0xFFEAB308)  // Yellow
7-8: Color(0xFF84CC16)  // Light Green
9-10: Color(0xFF22C55E) // Green
```

## Performance Considerations

### Nyxb UI Components
- **Magic Card**: Uses `CustomPainter` for spotlight effect
- **Circular Progress**: Optimized with `shouldRepaint` checks
- **Warp Background**: Limited animation complexity

### Kanpeki UI Components
- **Accordion**: Uses `SizeTransition` for smooth animations
- **Cards**: Minimal hover state changes

### Cult UI Components
- **Dynamic Island**: Efficient size transitions
- **Texture Buttons**: Lightweight texture overlays

## Development Guidelines

### Adding New Components
1. **Choose appropriate design system** based on component purpose
2. **Follow existing patterns** for consistency
3. **Implement accessibility** features (especially for Kanpeki-style components)
4. **Add energy-specific variants** when relevant
5. **Update documentation** in this file

### Component Naming Convention
- **Nyxb UI**: Descriptive names (e.g., `MagicCard`, `ShimmerButton`)
- **Kanpeki UI**: Prefixed with `Kanpeki` (e.g., `KanpekiCard`, `KanpekiAccordion`)
- **Cult UI**: Prefixed with `Cult` (e.g., `CultDynamicIsland`, `CultTextureButton`)
- **Energy-specific**: Prefixed with `Energy` (e.g., `EnergyMetricCard`, `EnergyActionButton`)

### Testing Strategy
- **Visual testing**: HTML previews for each design system
- **Animation testing**: Verify smooth 60fps animations
- **Accessibility testing**: Especially for Kanpeki components
- **Integration testing**: Cross-component interactions

---

**Last Updated**: December 2024
**Version**: 1.0.0
**Design Systems**: Nyxb UI + Kanpeki UI + Cult UI
