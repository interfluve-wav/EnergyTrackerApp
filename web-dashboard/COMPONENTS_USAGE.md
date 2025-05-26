# Energy Tracker Web Dashboard - Component Usage

This document tracks the shadcn/ui components used in the Energy Tracker web dashboard and their locations.

## Project Overview

The Energy Tracker Web Dashboard is a Next.js application that complements the Flutter desktop app. It provides a modern web interface for tracking energy levels using shadcn/ui components.

## shadcn/ui Components Used

### Core UI Components

#### Card Component
- **Location**: `src/components/ui/card.tsx`
- **Used in**: Main dashboard (`src/app/page.tsx`)
- **Purpose**:
  - Quick stats display (4 stat cards)
  - Energy logging form container
  - Recent entries display
  - Insights and weekly overview sections

#### Button Component
- **Location**: `src/components/ui/button.tsx`
- **Used in**: Energy logging section
- **Purpose**:
  - Energy level selector (1-10 grid)
  - Submit button for energy logging

#### Badge Component
- **Location**: `src/components/ui/badge.tsx`
- **Used in**:
  - Quick stats (trend indicator)
  - Recent entries (mood display)
- **Purpose**: Status indicators and mood labels

#### Progress Component
- **Location**: `src/components/ui/progress.tsx`
- **Used in**:
  - Quick stats (energy level visualization)
  - Weekly overview (daily energy bars)
- **Purpose**: Visual representation of energy levels

#### Input Component
- **Location**: `src/components/ui/input.tsx`
- **Status**: Available but not currently used
- **Potential use**: Future form inputs

#### Textarea Component
- **Location**: `src/components/ui/textarea.tsx`
- **Used in**: Energy logging form
- **Purpose**: Note input for energy entries

#### Select Component
- **Location**: `src/components/ui/select.tsx`
- **Used in**: Energy logging form
- **Purpose**: Mood selection dropdown

#### Form Component
- **Location**: `src/components/ui/form.tsx`
- **Used in**: Login page (`src/app/login/page.tsx`)
- **Purpose**: Form validation and structure with react-hook-form integration

#### Label Component
- **Location**: `src/components/ui/label.tsx`
- **Used in**: Login form
- **Purpose**: Accessible form labels

## Authentication System

### Auth.js Integration
- **Configuration**: `auth.ts` - NextAuth configuration with credentials provider
- **API Route**: `src/app/api/auth/[...nextauth]/route.ts` - Authentication API endpoints
- **Middleware**: `src/middleware.ts` - Route protection and authentication checks
- **Session Provider**: `src/components/providers/session-provider.tsx` - Client-side session management

### Login Page (`src/app/login/page.tsx`)
- **Professional login form** with shadcn/ui components
- **Form validation** using react-hook-form and zod
- **Demo credentials** for testing
- **Error handling** and loading states
- **Responsive design** matching the dashboard theme

### Demo Credentials
- **Admin**: admin@energytracker.com / password123
- **User**: user@energytracker.com / password123

## Page Structure

### Main Dashboard (`src/app/page.tsx`)

1. **Header Section**
   - Title and description
   - Gradient background

2. **Quick Stats Grid** (4 cards)
   - Today's Average (with trend badge and progress)
   - Total Entries (with emoji icon)
   - Weekly Average
   - Current Status

3. **Main Content Grid**
   - **Energy Logging Card** (1/3 width)
     - Energy level selector (1-10 buttons)
     - Mood selector (dropdown)
     - Note textarea
     - Submit button
   - **Recent Entries Card** (2/3 width)
     - List of recent energy logs
     - Each entry shows level, mood badge, time, and note

4. **Insights Section** (2 cards)
   - **Energy Insights Card**
     - Trend analysis
     - Peak energy time recommendations
   - **Weekly Overview Card**
     - Daily energy distribution with progress bars

## Design System

### Color Scheme (Professional Dark Theme)
- Primary: Blue (#3B82F6) for actions and highlights
- Background: Dark slate gradients (#0F172A, #1E293B)
- Success: Emerald (#10B981) for positive trends
- Warning: Amber (#F59E0B) for recommendations
- Info: Blue (#3B82F6) for insights
- Text: White with opacity variations for hierarchy
- Borders: Slate with transparency for subtle separation

### Typography
- Headers: Semibold, professional sizing (text-lg, text-xl)
- Body: Regular weight with proper line height
- Captions: Smaller text with muted colors (text-xs, text-sm)
- Consistent font hierarchy throughout

### Layout
- Professional header with logo and status indicator
- Clean card-based layout with subtle shadows
- Responsive grid system with proper spacing
- Consistent 8px spacing units
- Mobile-first responsive design

## Features Implemented

✅ **Professional Energy Logging**
- Clean 1-10 scale selector with hover states
- Professional mood selection dropdown
- Optional notes with proper validation
- Subtle form feedback and validation

✅ **Executive Dashboard**
- Key metrics overview with trend indicators
- Professional data visualization
- Clean progress bars and charts
- Performance analytics

✅ **Business Intelligence**
- AI-powered insights with professional icons
- Trend analysis with actionable recommendations
- Weekly performance tracking
- Data-driven decision support

✅ **Enterprise Design**
- Professional dark theme
- Corporate-friendly interface
- Consistent branding and typography
- Accessibility-compliant design

✅ **Authentication & Security**
- Auth.js integration with credentials provider
- Professional login page with form validation
- Route protection middleware
- Session management with JWT tokens
- Secure logout functionality

## Future Enhancements

### Additional shadcn/ui Components to Consider
- **Chart Components**: For more advanced data visualization
- **Calendar Component**: For date-based energy tracking
- **Dialog/Modal**: For detailed entry editing
- **Tabs**: For different dashboard views
- **Toast**: For user feedback notifications
- **Tooltip**: For additional information display

### Potential Features
- Data export functionality
- Advanced filtering and search
- Goal setting and tracking
- Social sharing capabilities
- Integration with the Flutter desktop app

## Development Notes

- Uses React 19 with Next.js App Router
- All components are client-side rendered ("use client")
- Mock data is used for demonstration
- Ready for backend integration
- Follows shadcn/ui design patterns and conventions
