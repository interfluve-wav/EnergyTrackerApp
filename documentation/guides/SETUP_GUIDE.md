# Energy Tracker - Complete Setup Guide

## 🚀 Quick Setup (5 Minutes)

### 1. Prerequisites Check
```bash
# Check Flutter
flutter --version
# Should show Flutter 3.10.0 or higher

# Check Node.js
node --version
# Should show v18.0.0 or higher

# Check npm
npm --version
```

### 2. Clone/Navigate to Project
```bash
cd "Documents/Developer/Cursor Projects/EnergyTracker"
```

### 3. Flutter Desktop App Setup
```bash
# Install Flutter dependencies
flutter pub get

# Run desktop app
flutter run -d windows  # or -d macos, -d linux
```

### 4. Web Dashboard Setup
```bash
# Navigate to web dashboard
cd web-dashboard

# Install dependencies
npm install

# Start development server
npm run dev

# Open browser to http://localhost:3000
```

### 5. Login to Web Dashboard
- **URL**: http://localhost:3000
- **Admin**: admin@energytracker.com / password123
- **User**: user@energytracker.com / password123

## 📁 Project Structure Overview

```
EnergyTracker/
├── 📱 Flutter Desktop App
│   ├── lib/main.dart                    # Entry point
│   ├── lib/screens/                     # App screens
│   ├── lib/widgets/                     # UI components
│   └── pubspec.yaml                     # Dependencies
│
├── 🌐 Web Dashboard
│   ├── src/app/page.tsx                 # Main dashboard
│   ├── src/app/login/page.tsx           # Login page
│   ├── src/components/ui/               # shadcn/ui components
│   ├── auth.ts                          # Authentication config
│   ├── package.json                     # Dependencies
│   └── .env.local                       # Environment variables
│
└── 📚 Documentation
    ├── PROJECT_SUMMARY.md               # Complete overview
    ├── SETUP_GUIDE.md                   # This file
    ├── README.md                        # Main docs
    └── web-dashboard/COMPONENTS_USAGE.md # Component docs
```

## 🔧 Detailed Setup Instructions

### Flutter Desktop App

#### Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  # Add other dependencies as needed
```

#### Key Files
- **`lib/main.dart`** - Application entry point
- **`lib/screens/desktop_home_screen.dart`** - Main desktop interface
- **`lib/providers/energy_provider.dart`** - State management
- **`lib/models/energy_entry.dart`** - Data models

#### Running
```bash
# Development
flutter run -d windows

# Build for production
flutter build windows
```

### Web Dashboard

#### Dependencies (package.json)
```json
{
  "dependencies": {
    "next": "15.3.2",
    "react": "19.0.0",
    "next-auth": "5.0.0-beta.25",
    "zod": "^3.23.8",
    "react-hook-form": "^7.53.2",
    "@hookform/resolvers": "^3.9.1"
  }
}
```

#### Environment Setup (.env.local)
```bash
# Copy example file
cp .env.local.example .env.local

# Edit with your values
AUTH_SECRET=your-random-secret-key-here
NEXTAUTH_URL=http://localhost:3000
```

#### Key Files
- **`src/app/page.tsx`** - Main dashboard with authentication
- **`src/app/login/page.tsx`** - Professional login page
- **`auth.ts`** - Auth.js configuration
- **`src/middleware.ts`** - Route protection

#### Running
```bash
# Development
npm run dev

# Build for production
npm run build
npm start
```

## 🎨 UI Components Reference

### Flutter Desktop (Custom Components)
```dart
// Nyxb UI Components
NyxbGradientCard()
NyxbAnimatedNumber()

// Kanpeki UI Components
KanpekiSidebar()
KanpekiNavigationItem()

// Cult UI Components
CultDynamicIsland()
CultTextureButton()
```

### Web Dashboard (shadcn/ui)
```tsx
// Core Components
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"
import { Form, FormField, FormItem, FormLabel } from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { Select, SelectContent, SelectItem } from "@/components/ui/select"
```

## 🔐 Authentication System

### Auth.js Configuration (auth.ts)
```typescript
import NextAuth from "next-auth"
import Credentials from "next-auth/providers/credentials"

export const { handlers, signIn, signOut, auth } = NextAuth({
  providers: [
    Credentials({
      // Demo credentials configuration
    }),
  ],
  pages: {
    signIn: "/login",
  },
})
```

### Demo Users
```typescript
// Admin User
{
  email: "admin@energytracker.com",
  password: "password123",
  role: "admin"
}

// Regular User
{
  email: "user@energytracker.com", 
  password: "password123",
  role: "user"
}
```

## 🎯 Features Overview

### Flutter Desktop App Features
- ✅ Professional sidebar navigation
- ✅ Energy logging with 1-10 scale
- ✅ Visual progress indicators
- ✅ Pattern analysis and insights
- ✅ Floating status indicators
- ✅ Smooth animations and transitions

### Web Dashboard Features
- ✅ Secure authentication system
- ✅ Professional dark theme
- ✅ Executive dashboard with metrics
- ✅ Interactive energy logging
- ✅ Real-time data visualization
- ✅ Business intelligence insights
- ✅ Responsive design
- ✅ User session management

## 🚀 Development Commands

### Flutter Commands
```bash
# Run app
flutter run -d windows

# Hot reload (r in terminal)
# Hot restart (R in terminal)

# Build for production
flutter build windows
flutter build macos
flutter build linux

# Clean build
flutter clean
flutter pub get
```

### Web Dashboard Commands
```bash
# Development
npm run dev

# Build
npm run build

# Start production
npm start

# Lint
npm run lint

# Add shadcn/ui component
npx shadcn@latest add [component-name]
```

## 🔍 Troubleshooting

### Common Issues

#### Flutter Issues
```bash
# If dependencies fail
flutter clean
flutter pub get

# If build fails
flutter doctor
```

#### Web Dashboard Issues
```bash
# If npm install fails
rm -rf node_modules package-lock.json
npm install

# If auth doesn't work
# Check .env.local file exists and has AUTH_SECRET
```

#### Port Conflicts
```bash
# If port 3000 is busy
npm run dev -- -p 3001
```

## 📚 Documentation Links

- **Main README**: `README.md`
- **Web Dashboard Docs**: `web-dashboard/README.md`
- **Component Usage**: `web-dashboard/COMPONENTS_USAGE.md`
- **Architecture**: `docs/COMPONENT_ARCHITECTURE.md`
- **Project Summary**: `PROJECT_SUMMARY.md`

## ✅ Verification Checklist

### Flutter Desktop App
- [ ] `flutter run -d windows` works
- [ ] App opens with professional interface
- [ ] Energy logging functions work
- [ ] Sidebar navigation works

### Web Dashboard
- [ ] `npm run dev` starts without errors
- [ ] http://localhost:3000 redirects to login
- [ ] Login with demo credentials works
- [ ] Dashboard loads with user info
- [ ] Logout button works

### Both Platforms
- [ ] Professional dark theme
- [ ] Responsive design
- [ ] Smooth animations
- [ ] No console errors

## 🎉 Success!

If all items in the verification checklist pass, your Energy Tracker project is fully set up and ready for development or demonstration!
