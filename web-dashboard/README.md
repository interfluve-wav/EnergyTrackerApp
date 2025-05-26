# Energy Tracker Web Dashboard

A modern web companion to the Energy Tracker Flutter desktop application, built with Next.js and shadcn/ui components.

## 🚀 Features

- **Modern UI**: Built with shadcn/ui components for a polished, accessible interface
- **Energy Logging**: Interactive 1-10 scale energy level tracking with mood selection
- **Data Visualization**: Progress bars, charts, and visual indicators for energy trends
- **Insights**: Smart analysis of energy patterns and recommendations
- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile devices
- **Real-time Updates**: Live dashboard with immediate feedback
- **Authentication**: Secure login system with Auth.js integration

## 🛠️ Tech Stack

- **Framework**: Next.js 15 with App Router
- **UI Components**: shadcn/ui (built on Radix UI)
- **Styling**: Tailwind CSS
- **Language**: TypeScript
- **Authentication**: Auth.js (NextAuth.js v5)
- **Form Validation**: React Hook Form + Zod
- **State Management**: React hooks

## 📦 Getting Started

1. Install dependencies:
```bash
npm install
```

2. Run the development server:
```bash
npm run dev
```

3. Set up environment variables:
```bash
cp .env.local.example .env.local
# Edit .env.local with your AUTH_SECRET
```

4. Open [http://localhost:3000](http://localhost:3000) in your browser

## 🔐 Authentication

The dashboard includes a secure authentication system using Auth.js:

### Demo Credentials
- **Admin User**: admin@energytracker.com / password123
- **Regular User**: user@energytracker.com / password123

### Features
- **Secure Login**: Professional login form with validation
- **Route Protection**: Automatic redirect to login for unauthenticated users
- **Session Management**: Persistent sessions with JWT tokens
- **User Information**: Display user name and email in header
- **Secure Logout**: Clean session termination

## 🎨 shadcn/ui Components Used

### Core Components
- **Card**: Main container for dashboard sections
- **Button**: Interactive elements and energy level selectors
- **Badge**: Status indicators and mood labels
- **Progress**: Visual energy level representation
- **Input/Textarea**: Form inputs for notes and data entry
- **Select**: Dropdown menus for mood selection

### Component Locations
```
src/components/ui/
├── card.tsx
├── button.tsx
├── badge.tsx
├── progress.tsx
├── input.tsx
├── textarea.tsx
└── select.tsx
```

## 📱 Dashboard Sections

### 1. Quick Stats
- Today's average energy with trend indicator
- Total entries count
- Weekly average
- Current status overview

### 2. Energy Logging
- Interactive 1-10 energy level selector
- Mood selection with emoji indicators
- Optional note input
- Form validation and submission

### 3. Recent Entries
- Timeline of recent energy logs
- Color-coded energy levels
- Mood badges and timestamps
- Entry notes display

### 4. Insights & Analytics
- Energy trend analysis
- Peak energy time identification
- Weekly overview with daily breakdowns
- Personalized recommendations

## 🎯 Key Features

### Energy Tracking
- **Scale**: 1-10 energy level rating
- **Moods**: Excellent, Energized, Good, Moderate, Tired, Low
- **Notes**: Optional context for each entry
- **Timestamps**: Automatic time tracking

### Data Visualization
- **Progress Bars**: Visual energy level representation
- **Color Coding**: Green (high), Yellow (moderate), Red (low)
- **Trend Indicators**: Improving, stable, or declining patterns
- **Weekly Charts**: Daily energy distribution

## 🔧 Development

### Adding New Components
```bash
npx shadcn@latest add [component-name]
```

### Available Scripts
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

## 📄 Documentation

- [Component Usage Guide](./COMPONENTS_USAGE.md) - Detailed component documentation
- [shadcn/ui Documentation](https://ui.shadcn.com/) - Official component library docs

## 🤝 Integration

This web dashboard complements the Flutter desktop application with:
- **Shared Data Model**: Compatible energy entry structure
- **Consistent Design**: Matching visual language and UX patterns
- **Cross-Platform**: Access energy data from any device

## 🚀 Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.
