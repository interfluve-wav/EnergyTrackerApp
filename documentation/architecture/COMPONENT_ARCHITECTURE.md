# Energy Tracker - Component Architecture Documentation

## Overview
This document outlines the complete component architecture of the Energy Tracker desktop application, including all UI libraries, custom components, and their usage throughout the project.

## Design Systems Used

### 1. Nyxb UI (Custom Flutter Implementation)
**Source**: https://nyxbui.design/docs
**Purpose**: Base UI components with magical effects and animations
**Location**: `lib/widgets/nyxb/`

### 2. Kanpeki UI (Flutter Adaptation)
**Source**: https://kanpeki.vercel.app/docs/components/accordion
**Purpose**: Accessible, professional UI components
**Location**: `lib/widgets/kanpeki/`

### 3. Cult UI (Flutter Adaptation)
**Source**: https://github.com/nolly-studio/cult-ui
**Purpose**: Modern, interactive components with dynamic effects
**Location**: `lib/widgets/cult/`

## Component Hierarchy

### Core Application Structure
```
EnergyTracker/
├── lib/                                # Flutter Desktop App
│   ├── main.dart                       # App entry point with desktop configuration
│   ├── screens/
│   │   ├── desktop_home_screen.dart    # Main desktop layout
│   │   └── home_screen.dart            # Original mobile layout (legacy)
│   ├── providers/
│   │   └── energy_provider.dart        # State management
│   ├── models/
│   │   └── energy_entry.dart           # Data models
│   └── widgets/
│       ├── nyxb/                       # Nyxb UI components
│       ├── kanpeki/                    # Kanpeki UI components
│       ├── cult/                       # Cult UI components
│       └── desktop/                    # Desktop-specific components
└── web-dashboard/                      # Next.js Web Dashboard
    ├── src/
    │   ├── app/
    │   │   ├── page.tsx                # Main dashboard page
    │   │   ├── layout.tsx              # Root layout
    │   │   └── globals.css             # Global styles
    │   ├── components/
    │   │   └── ui/                     # shadcn/ui components
    │   └── lib/
    │       └── utils.ts                # Utility functions
    ├── COMPONENTS_USAGE.md             # Component documentation
    └── README.md                       # Web dashboard documentation
```

## Component Usage Map

### Web Dashboard (`web-dashboard/src/app/page.tsx`)

**Purpose**: Modern web interface companion to the Flutter desktop app
**Technology**: Next.js 15 + shadcn/ui + TypeScript

**shadcn/ui Components Used**:
- `Card` - Main container for dashboard sections (stats, logging, entries, insights)
- `Button` - Energy level selectors (1-10 grid) and form submission
- `Badge` - Trend indicators and mood labels
- `Progress` - Visual energy level representation and weekly overview
- `Input/Textarea` - Note input for energy entries
- `Select` - Mood selection dropdown with emoji indicators

**Key Features**:
- Interactive energy logging with 1-10 scale
- Real-time dashboard with stats and trends
- Responsive design for all devices
- Color-coded energy visualization
- Weekly overview and insights

**Integration Points**:
- Compatible data model with Flutter app
- Shared design language and UX patterns
- Ready for data synchronization

### Desktop Home Screen (`desktop_home_screen.dart`)
- **Layout**: Custom desktop layout with sidebar
- **Background**: `WarpBackground` (Nyxb UI)
- **Navigation**: `SidebarNavigation` (Custom desktop)
- **Title Bar**: `CustomTitleBar` (Custom desktop)
- **Floating Status**: `FloatingEnergyStatus` (Cult UI - Dynamic Island)

### Dashboard View
- **Main Energy Card**: `MagicCard` (Nyxb UI) + `EnergyCircularProgress` (Nyxb UI)
- **Stats Cards**: `EnergyMetricCard` (Kanpeki UI)
- **Recent Entries**: `KanpekiCard` (Kanpeki UI)
- **Quick Actions**: `EnergyQuickActions` (Cult UI - Texture Buttons)

### Insights View
- **Insight Cards**: `EnergyInsightCard` (Kanpeki UI)
- **Detailed Analysis**: `EnergyInsightsAccordion` (Kanpeki UI)
- **Action Buttons**: `CultTextureButton` (Cult UI)

### Energy Logging
- **Level Selector**: `EnergyLevelTextureSelector` (Cult UI)
- **Save Button**: `CultTextureButton` (Cult UI)
- **Modal**: `QuickEnergyLogDialog` (Custom desktop)

## Component Dependencies

### Nyxb UI Components
```dart
// Core magical components
MagicCard                    # Interactive cards with spotlight effects
AnimatedCircularProgress     # Circular progress with gradients
NumberTicker                 # Animated number counters
ShimmerButton               # Buttons with shimmer animations
GradientBackground          # Animated gradient backgrounds
WarpBackground              # Dynamic warp effects
```

### Kanpeki UI Components
```dart
// Professional, accessible components
KanpekiAccordion            # Collapsible content sections
KanpekiCard                 # Base card component with hover effects
EnergyMetricCard            # Data display cards
EnergyInsightCard           # Actionable insight cards
EnergyTrendCard             # Trend visualization cards
EnergyInsightsAccordion     # Energy-specific accordion
```

### Cult UI Components
```dart
// Modern, interactive components
CultDynamicIsland           # Floating status indicator
CultTextureButton           # Interactive buttons with textures
EnergyDynamicIsland         # Energy-specific dynamic island
EnergyActionButton          # Energy action buttons
EnergyLevelTextureSelector  # Energy level selection
EnergyQuickActions          # Grid of quick action buttons
FloatingEnergyStatus        # Floating energy status widget
```

### Desktop-Specific Components
```dart
// Desktop window management
CustomTitleBar              # Custom window title bar
SidebarNavigation           # Desktop sidebar navigation
QuickEnergyLogDialog        # Desktop energy logging modal
DesktopEnergyDashboard      # Desktop dashboard layout (placeholder)
DesktopEnergyChart          # Desktop chart view (placeholder)
DesktopEnergyHistory        # Desktop history view (placeholder)
```

## State Management

### Energy Provider (`energy_provider.dart`)
- **Purpose**: Manages all energy-related state
- **Used by**: All energy display components
- **Key methods**:
  - `addEnergyEntry()` - Add new energy entry
  - `loadEntries()` - Load sample/saved entries
  - `todayAverageEnergy` - Calculate today's average
  - `weeklyAverageEnergy` - Calculate weekly average
  - `energyTrend` - Determine energy trend

## Animation System

### Nyxb UI Animations
- **Magic Cards**: Spotlight following mouse cursor
- **Circular Progress**: Smooth progress animations
- **Number Ticker**: Count-up animations
- **Shimmer Buttons**: Continuous shimmer effect
- **Warp Background**: Subtle background movement

### Kanpeki UI Animations
- **Accordion**: Smooth expand/collapse with rotation
- **Cards**: Hover lift and scale effects
- **Transitions**: 200-300ms easing curves

### Cult UI Animations
- **Dynamic Island**: Size transitions and hover effects
- **Texture Buttons**: Press animations with scale
- **Interactive States**: Hover and focus animations

## Color System

### Energy Level Colors
```dart
Level 1-2:  #EF4444 (Red)     - Very Low/Low
Level 3-4:  #F97316 (Orange)  - Below Average
Level 5-6:  #EAB308 (Yellow)  - Average/Moderate
Level 7-8:  #84CC16 (Light Green) - High
Level 9-10: #22C55E (Green)   - Very High/Excellent
```

### Theme Colors
```dart
Primary:    #667eea (Blue)
Secondary:  #764ba2 (Purple)
Success:    #22c55e (Green)
Warning:    #f59e0b (Orange)
Danger:     #ef4444 (Red)
Background: #0f0f23 (Dark Blue)
Surface:    rgba(255, 255, 255, 0.05) (Translucent)
```

## File Structure Details

### Widget Organization
```
widgets/
├── nyxb/
│   ├── magic_card.dart              # Interactive cards with spotlight
│   ├── animated_circular_progress.dart # Circular progress indicators
│   ├── number_ticker.dart           # Animated number displays
│   ├── shimmer_button.dart          # Shimmer effect buttons
│   └── gradient_background.dart     # Animated backgrounds
├── kanpeki/
│   ├── accordion.dart               # Collapsible content
│   └── card.dart                    # Professional card components
├── cult/
│   ├── dynamic_island.dart          # Floating status indicators
│   └── texture_button.dart          # Interactive texture buttons
└── desktop/
    ├── custom_title_bar.dart        # Window title bar
    ├── sidebar_navigation.dart      # Desktop navigation
    ├── desktop_energy_dashboard.dart # Dashboard placeholder
    ├── desktop_energy_chart.dart    # Chart placeholder
    └── desktop_energy_history.dart  # History placeholder
```

## Integration Points

### Where Components Are Used

#### Main Desktop Layout
- **File**: `desktop_home_screen.dart`
- **Components**: All major components integrated here
- **Layout**: Sidebar + Content area with floating elements

#### Dashboard Tab (Index 0)
- **Energy Display**: Nyxb UI (MagicCard + CircularProgress)
- **Stats**: Kanpeki UI (Metric Cards)
- **Actions**: Cult UI (Texture Buttons)

#### Insights Tab (Index 3)
- **Cards**: Kanpeki UI (Insight Cards)
- **Accordion**: Kanpeki UI (Expandable sections)
- **Actions**: Cult UI (Quick Actions)

#### Floating Elements
- **Dynamic Island**: Cult UI (Energy status)
- **Background**: Nyxb UI (Warp effects)

## Future Expansion Areas

### Planned Components
- Advanced charts (fl_chart integration)
- Settings panels
- Data export functionality
- Notification system
- Mobile sync components

### Component Extension Points
- Additional Nyxb UI effects
- More Kanpeki UI form components
- Extended Cult UI interactions
- Desktop-specific optimizations

## Development Notes

### Component Creation Pattern
1. **Base Implementation**: Create Flutter widget
2. **Design Adaptation**: Adapt from React/CSS to Flutter
3. **Energy Integration**: Add energy-specific variants
4. **Animation Integration**: Add smooth transitions
5. **Documentation**: Update this file

### Testing Strategy
- **Visual Testing**: HTML previews for design validation
- **Component Testing**: Individual widget testing
- **Integration Testing**: Full app flow testing
- **Performance Testing**: Animation performance validation

---

**Last Updated**: December 2024
**Version**: 1.0.0
**Maintainer**: Energy Tracker Development Team
