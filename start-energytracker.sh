#!/bin/bash

# EnergyTracker Easy Startup Script
# Just double-click this file or run: ./start-energytracker.sh

echo "🔋 Starting EnergyTracker..."
echo ""

# Navigate to the web dashboard directory
cd "$(dirname "$0")/web-dashboard"

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies (first time only)..."
    npm install
    echo ""
fi

echo "🚀 Starting EnergyTracker Web Dashboard..."
echo "📱 Opening browser to http://localhost:3000"
echo ""
echo "💡 To stop: Press Ctrl+C in this terminal"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Open browser automatically
sleep 3 && open http://localhost:3000 &

# Start the development server
npm run dev
