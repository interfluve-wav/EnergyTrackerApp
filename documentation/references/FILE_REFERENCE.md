# Energy Tracker - Complete File Reference

## 📁 Critical Files Overview

This document lists all the important files in the Energy Tracker project with their purposes and key content.

## 🌐 Web Dashboard Files

### Core Application Files

#### `web-dashboard/src/app/page.tsx` - Main Dashboard
- **Purpose**: Professional energy tracking dashboard with authentication
- **Features**: Key metrics, energy logging, recent activity, analytics
- **Components**: Uses shadcn/ui Card, Button, Badge, Progress, Select, Textarea
- **Authentication**: Integrated with useSession hook

#### `web-dashboard/src/app/login/page.tsx` - Login Page
- **Purpose**: Professional login form with validation
- **Features**: Form validation, error handling, demo credentials display
- **Components**: Uses shadcn/ui Card, Form, Input, Button, Label
- **Validation**: React Hook Form + Zod schema validation

#### `web-dashboard/src/app/layout.tsx` - Root Layout
- **Purpose**: Application wrapper with session provider
- **Features**: Global styles, font configuration, session management
- **Providers**: SessionProvider wrapper for authentication

#### `web-dashboard/src/app/globals.css` - Global Styles
- **Purpose**: Professional dark theme and animations
- **Features**: Custom CSS variables, animations, scrollbar styling
- **Theme**: Dark slate color scheme with professional styling

### Authentication Files

#### `web-dashboard/auth.ts` - Auth.js Configuration
- **Purpose**: NextAuth.js configuration with credentials provider
- **Features**: Demo user authentication, JWT sessions, callbacks
- **Security**: Password validation, user role management

#### `web-dashboard/src/middleware.ts` - Route Protection
- **Purpose**: Protect routes and redirect unauthenticated users
- **Features**: Automatic login redirect, API route exclusion
- **Security**: Session validation for all protected routes

#### `web-dashboard/src/app/api/auth/[...nextauth]/route.ts` - Auth API
- **Purpose**: Authentication API endpoints
- **Features**: Handles login, logout, session management
- **Integration**: Exports Auth.js handlers

#### `web-dashboard/src/components/providers/session-provider.tsx` - Session Provider
- **Purpose**: Client-side session management wrapper
- **Features**: SessionProvider component for React context
- **Usage**: Wraps entire application for session access

### Configuration Files

#### `web-dashboard/.env.local` - Environment Variables
```bash
AUTH_SECRET=your-auth-secret-key-here-replace-with-random-string
NEXTAUTH_URL=http://localhost:3000
```

#### `web-dashboard/package.json` - Dependencies
- **Next.js 15** with App Router
- **Auth.js** (NextAuth.js v5) for authentication
- **shadcn/ui** components
- **React Hook Form** + **Zod** for validation
- **TypeScript** for type safety

#### `web-dashboard/components.json` - shadcn/ui Configuration
- **Purpose**: shadcn/ui component configuration
- **Features**: Component paths, styling configuration
- **Usage**: Used by shadcn CLI for component installation

### UI Components (shadcn/ui)

#### `web-dashboard/src/components/ui/` Directory
- **card.tsx** - Card components for containers
- **button.tsx** - Button components with variants
- **badge.tsx** - Badge components for status indicators
- **progress.tsx** - Progress bar components
- **form.tsx** - Form components with validation
- **input.tsx** - Input field components
- **textarea.tsx** - Textarea components
- **select.tsx** - Select dropdown components
- **label.tsx** - Label components for accessibility

## 📱 Flutter Desktop App Files

### Core Application Files

#### `lib/main.dart` - Application Entry Point
- **Purpose**: Flutter app initialization and configuration
- **Features**: Desktop window configuration, theme setup
- **Platform**: Windows, macOS, Linux support

#### `lib/screens/desktop_home_screen.dart` - Main Desktop Interface
- **Purpose**: Primary desktop application interface
- **Features**: Professional sidebar, energy logging, data visualization
- **Components**: Custom desktop widgets, responsive layout

#### `lib/providers/energy_provider.dart` - State Management
- **Purpose**: Application state management using Provider pattern
- **Features**: Energy data management, state updates
- **Pattern**: Provider pattern for reactive state management

#### `lib/models/energy_entry.dart` - Data Models
- **Purpose**: Data structure definitions for energy entries
- **Features**: Energy level, mood, timestamp, notes
- **Usage**: Used throughout app for data consistency

### UI Component Libraries

#### `lib/widgets/nyxb/` - Nyxb UI Components
- **Purpose**: Modern gradient cards and animated components
- **Features**: Gradient effects, smooth animations
- **Style**: Modern, colorful design elements

#### `lib/widgets/kanpeki/` - Kanpeki UI Components
- **Purpose**: Professional sidebar navigation and layouts
- **Features**: Clean navigation, professional styling
- **Style**: Minimalist, professional design

#### `lib/widgets/cult/` - Cult UI Components
- **Purpose**: Dynamic island and interactive elements
- **Features**: Floating elements, texture effects
- **Style**: Unique, interactive design elements

#### `lib/widgets/desktop/` - Desktop-Specific Components
- **Purpose**: Desktop-optimized UI components
- **Features**: Desktop interaction patterns, window management
- **Platform**: Optimized for desktop environments

### Configuration Files

#### `pubspec.yaml` - Flutter Dependencies
- **Flutter SDK** configuration
- **Provider** for state management
- **Desktop platform** support
- **Custom fonts** and assets

## 📚 Documentation Files

### Main Documentation

#### `README.md` - Main Project Documentation
- **Purpose**: Complete project overview and setup instructions
- **Features**: Architecture overview, installation guide
- **Audience**: Developers and project stakeholders

#### `PROJECT_SUMMARY.md` - Complete Project Summary
- **Purpose**: Comprehensive project overview with all features
- **Features**: Technology stack, file structure, quick start
- **Audience**: New developers joining the project

#### `SETUP_GUIDE.md` - Detailed Setup Instructions
- **Purpose**: Step-by-step setup guide for both platforms
- **Features**: Prerequisites, troubleshooting, verification
- **Audience**: Developers setting up the project

#### `FILE_REFERENCE.md` - This File
- **Purpose**: Complete file listing and reference
- **Features**: File purposes, key content, usage notes
- **Audience**: Developers navigating the codebase

### Web Dashboard Documentation

#### `web-dashboard/README.md` - Web Dashboard Docs
- **Purpose**: Web dashboard specific documentation
- **Features**: Component usage, authentication guide
- **Audience**: Web developers working on dashboard

#### `web-dashboard/COMPONENTS_USAGE.md` - Component Documentation
- **Purpose**: Detailed shadcn/ui component usage guide
- **Features**: Component locations, usage examples, design system
- **Audience**: UI developers and designers

### Architecture Documentation

#### `docs/COMPONENT_ARCHITECTURE.md` - Architecture Documentation
- **Purpose**: System architecture and component relationships
- **Features**: Component maps, integration points
- **Audience**: Senior developers and architects

## 🔧 Development Files

### Build and Configuration

#### `web-dashboard/next.config.js` - Next.js Configuration
- **Purpose**: Next.js build and runtime configuration
- **Features**: Build optimization, environment setup

#### `web-dashboard/tailwind.config.js` - Tailwind Configuration
- **Purpose**: Tailwind CSS configuration for styling
- **Features**: Custom colors, component styling

#### `web-dashboard/tsconfig.json` - TypeScript Configuration
- **Purpose**: TypeScript compiler configuration
- **Features**: Type checking, path mapping

## 🎯 Key Integration Points

### Authentication Flow
1. **Middleware** (`src/middleware.ts`) checks authentication
2. **Login page** (`src/app/login/page.tsx`) handles user input
3. **Auth config** (`auth.ts`) validates credentials
4. **Dashboard** (`src/app/page.tsx`) displays user info

### Component Integration
1. **shadcn/ui components** in `src/components/ui/`
2. **Page components** import and use UI components
3. **Global styles** in `src/app/globals.css`
4. **Theme configuration** in Tailwind config

### State Management
1. **Flutter**: Provider pattern in `lib/providers/`
2. **Web**: React hooks and Auth.js sessions
3. **Data models**: Consistent across platforms

## ✅ File Status

All files are **complete and production-ready** with:
- ✅ Professional styling and theming
- ✅ Complete authentication system
- ✅ Comprehensive documentation
- ✅ Cross-platform compatibility
- ✅ Modern development practices

This file reference provides a complete map of the Energy Tracker project for easy navigation and understanding.
