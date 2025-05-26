# Energy Tracker - Desktop Application

A beautiful, professional desktop application for tracking daily energy levels with advanced pattern analysis and insights. Built with Flutter Desktop and inspired by modern design systems.

## 🎯 Project Overview

Energy Tracker helps users monitor their daily energy patterns, identify trends, and receive personalized recommendations for optimizing their energy levels throughout the day.

### Key Features
- ⚡ **Daily Energy Logging** - Quick 1-10 scale energy level tracking
- 📊 **Pattern Analysis** - Identify energy trends and patterns
- 💡 **Smart Insights** - Personalized recommendations based on your data
- 🖥️ **Desktop Optimized** - Professional desktop interface with custom window controls
- 🎨 **Beautiful UI** - Modern design inspired by Nyxb UI, Kanpeki UI, and Cult UI
- 📈 **Visual Analytics** - Circular progress indicators and animated charts

## 🎨 Design Systems

This project integrates three modern design systems:

### Nyxb UI
- **Source**: [nyxbui.design](https://nyxbui.design/docs)
- **Features**: Magical effects, spotlight animations, gradient backgrounds
- **Components**: Magic Cards, Animated Progress, Number Tickers, Shimmer Buttons

### Kanpeki UI
- **Source**: [kanpeki.vercel.app](https://kanpeki.vercel.app/docs/components/accordion)
- **Features**: Accessible, professional components
- **Components**: Accordions, Cards, Metric displays

### Cult UI
- **Source**: [cult-ui.com](https://cult-ui.com) | [GitHub](https://github.com/nolly-studio/cult-ui)
- **Features**: Dynamic interactions, modern aesthetics
- **Components**: Dynamic Island, Texture Buttons, Interactive elements

## 🏗️ Architecture

EnergyTracker is built as a **cross-platform energy tracking solution** with two main components:

1. **Flutter Desktop App**: Professional desktop application with advanced UI components
2. **Web Dashboard**: Modern web interface built with Next.js and shadcn/ui

### Project Structure
```
EnergyTracker/
├── lib/                         # Flutter Desktop App
│   ├── main.dart                # Desktop app entry point
│   ├── screens/
│   │   └── desktop_home_screen.dart # Main desktop layout
│   ├── providers/
│   │   └── energy_provider.dart # State management
│   ├── models/
│   │   └── energy_entry.dart    # Data models
│   └── widgets/
│       ├── nyxb/                # Nyxb UI components
│       ├── kanpeki/             # Kanpeki UI components
│       ├── cult/                # Cult UI components
│       └── desktop/             # Desktop-specific components
├── web-dashboard/               # Next.js Web Dashboard
│   ├── src/
│   │   ├── app/page.tsx         # Main dashboard
│   │   └── components/ui/       # shadcn/ui components
│   └── README.md                # Web dashboard docs
└── docs/                        # Documentation
```

### Key Components

#### Nyxb UI Components
- `MagicCard` - Interactive cards with spotlight effects
- `AnimatedCircularProgress` - Smooth progress animations
- `NumberTicker` - Animated number displays
- `WarpBackground` - Dynamic gradient backgrounds

#### Kanpeki UI Components
- `KanpekiAccordion` - Collapsible content sections
- `EnergyMetricCard` - Professional data display cards
- `EnergyInsightCard` - Actionable insight cards

#### Cult UI Components
- `EnergyDynamicIsland` - Floating energy status indicator
- `CultTextureButton` - Interactive buttons with textures
- `EnergyQuickActions` - Grid of action buttons

#### shadcn/ui Components (Web Dashboard)
- `Card` - Main container for dashboard sections
- `Button` - Interactive elements and energy level selectors
- `Badge` - Status indicators and mood labels
- `Progress` - Visual energy level representation
- `Input/Textarea` - Form inputs for notes and data entry
- `Select` - Dropdown menus for mood selection

## 🚀 Getting Started

### Prerequisites

#### For Flutter Desktop App
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Desktop development setup for your platform

#### For Web Dashboard
- Node.js (>=18.0.0)
- npm or yarn package manager

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  intl: ^0.18.1
  window_manager: ^0.3.7
  bitsdojo_window: ^0.1.6
  fl_chart: ^0.64.0
  sqflite: ^2.3.0
  sqflite_common_ffi: ^2.3.0
```

### Installation

#### Flutter Desktop App
1. Clone the repository
```bash
git clone <repository-url>
cd EnergyTracker
```

2. Install Flutter dependencies
```bash
flutter pub get
```

3. Run the desktop application
```bash
flutter run -d windows  # or -d macos, -d linux
```

#### Web Dashboard
1. Navigate to the web dashboard directory
```bash
cd web-dashboard
```

2. Install Node.js dependencies
```bash
npm install
```

3. Run the development server
```bash
npm run dev
```

4. Open [http://localhost:3000](http://localhost:3000) in your browser

## 📱 Features

### Current Features (v1.0)

#### Flutter Desktop App
- ✅ **Energy Logging** - Quick 1-10 scale logging with notes
- ✅ **Desktop Interface** - Professional sidebar navigation
- ✅ **Visual Indicators** - Circular progress and animated numbers
- ✅ **Pattern Insights** - Basic trend analysis and recommendations
- ✅ **Floating Status** - Dynamic Island showing current energy
- ✅ **Interactive UI** - Hover effects, animations, and smooth transitions

#### Web Dashboard
- ✅ **Modern Web Interface** - Built with Next.js and shadcn/ui
- ✅ **Responsive Design** - Works on desktop, tablet, and mobile
- ✅ **Interactive Energy Logging** - 1-10 scale with mood selection
- ✅ **Real-time Dashboard** - Live stats and trend visualization
- ✅ **Data Visualization** - Progress bars and color-coded indicators
- ✅ **Insights & Analytics** - Pattern analysis and recommendations

### Planned Features (v2.0)
- 📊 **Advanced Charts** - Detailed energy trend visualizations
- 🌙 **Sleep Correlation** - Track sleep impact on energy levels
- 🎯 **Mood Tracking** - Correlate mood with energy patterns
- 🔔 **Smart Notifications** - Reminders and insights
- 📈 **Export Data** - CSV/PDF reports
- ⚙️ **Settings Panel** - Customization and preferences

## 🎨 UI Showcase

### Desktop Layout
- **Sidebar Navigation** - Clean, professional navigation
- **Custom Title Bar** - Native window controls
- **Floating Elements** - Dynamic Island for status
- **Animated Background** - Subtle warp effects

### Energy Visualization
- **Circular Progress** - Smooth animated energy indicators
- **Color Coding** - Intuitive red→yellow→green energy scale
- **Number Tickers** - Animated value displays
- **Magic Cards** - Interactive cards with spotlight effects

### Insights & Analytics
- **Expandable Sections** - Accordion-style detailed insights
- **Recommendation Cards** - Actionable energy optimization tips
- **Pattern Analysis** - Visual trend identification

## 🔧 Development

### Component Development
Each design system has its own directory with Flutter adaptations:

```dart
// Nyxb UI Example
MagicCard(
  borderColor: Color(0xFF667eea),
  spotlightColor: Color(0x33667eea),
  child: YourContent(),
)

// Kanpeki UI Example
KanpekiAccordion(
  items: [
    AccordionItem(
      title: 'Energy Patterns',
      content: InsightContent(),
    ),
  ],
)

// Cult UI Example
EnergyDynamicIsland(
  energyLevel: 7,
  onTap: () => showDetails(),
)
```

### State Management
Uses Provider pattern for state management:

```dart
// Access energy data
Consumer<EnergyProvider>(
  builder: (context, energyProvider, child) {
    return Text('Energy: ${energyProvider.todayAverageEnergy}');
  },
)
```

## 📚 Complete Documentation

### Quick Start & Setup
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - 5-minute setup guide for both platforms
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete project overview and features

### Development Documentation
- **[FILE_REFERENCE.md](FILE_REFERENCE.md)** - Complete file listing and reference
- **[Component Architecture](docs/COMPONENT_ARCHITECTURE.md)** - Detailed component structure
- **[Web Dashboard Docs](web-dashboard/README.md)** - Web interface documentation
- **[Component Usage Guide](web-dashboard/COMPONENTS_USAGE.md)** - shadcn/ui components

### Production & Deployment
- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Production deployment and next steps

## 🎯 Energy Level System

### Color Coding
- **1-2**: 🔴 Red (Very Low/Low)
- **3-4**: 🟠 Orange (Below Average)
- **5-6**: 🟡 Yellow (Average/Moderate)
- **7-8**: 🟢 Light Green (High)
- **9-10**: 🟢 Green (Very High/Excellent)

### Insights Generated
- **Peak Hours** - Identify when energy is highest
- **Sleep Impact** - Correlation with sleep quality
- **Pattern Recognition** - Weekly and monthly trends
- **Recommendations** - Personalized optimization tips

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow the existing component patterns
- Update documentation for new features
- Maintain design system consistency
- Add tests for new functionality

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Nyxb UI** - For magical component inspiration
- **Kanpeki UI** - For accessible, professional design patterns
- **Cult UI** - For modern, dynamic interaction concepts
- **Flutter Team** - For the amazing desktop framework

## 📞 Support

For questions, issues, or feature requests:
- Open an issue on GitHub
- Check the documentation in `docs/`
- Review the component examples in `lib/widgets/`

---

**Built with ❤️ using Flutter Desktop and modern design systems**
