"use client";

import { useState } from "react";
import { useSession, signOut } from "next-auth/react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

// Mock data for demonstration
const mockEnergyData = [
  { id: 1, level: 8, note: "Great workout this morning!", time: "2 hours ago", mood: "energized" },
  { id: 2, level: 6, note: "Post-lunch dip but still productive", time: "5 hours ago", mood: "moderate" },
  { id: 3, level: 9, note: "Perfect start to the day", time: "8 hours ago", mood: "excellent" },
];

const weeklyStats = {
  average: 6.5,
  entries: 21,
  weeklyAverage: 6.2,
  trend: "improving"
};

// Static weekly data to avoid hydration issues
const weeklyData = [
  { day: 'Mon', value: 75 },
  { day: 'Tue', value: 82 },
  { day: 'Wed', value: 68 },
  { day: 'Thu', value: 91 },
  { day: 'Fri', value: 77 },
  { day: 'Sat', value: 85 },
  { day: 'Sun', value: 73 },
];

export default function EnergyTrackerDashboard() {
  const { data: session, status } = useSession();
  const [selectedEnergyLevel, setSelectedEnergyLevel] = useState<number | null>(null);
  const [note, setNote] = useState("");
  const [mood, setMood] = useState("");

  if (status === "loading") {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 flex items-center justify-center">
        <div className="text-white">Loading...</div>
      </div>
    );
  }

  const handleEnergySubmit = () => {
    if (selectedEnergyLevel && mood) {
      // Here you would typically send data to your backend
      console.log("Submitting:", { level: selectedEnergyLevel, note, mood });
      // Reset form
      setSelectedEnergyLevel(null);
      setNote("");
      setMood("");
    }
  };

  const getEnergyColor = (level: number) => {
    if (level >= 8) return "bg-green-500";
    if (level >= 6) return "bg-yellow-500";
    if (level >= 4) return "bg-orange-500";
    return "bg-red-500";
  };

  const getTrendBadgeVariant = (trend: string) => {
    switch (trend) {
      case "improving": return "default";
      case "declining": return "destructive";
      default: return "secondary";
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 relative">
      {/* Subtle background pattern */}
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_50%,rgba(120,119,198,0.05),transparent_50%)]"></div>

      <div className="relative z-10">
        {/* Professional Header */}
        <header className="border-b border-slate-800/50 bg-slate-900/50 backdrop-blur-sm">
          <div className="container mx-auto px-6 py-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-8 h-8 bg-gradient-to-r from-blue-600 to-indigo-600 rounded-lg flex items-center justify-center">
                  <span className="text-white font-bold text-sm">ET</span>
                </div>
                <div>
                  <h1 className="text-xl font-semibold text-white">Energy Tracker</h1>
                  <p className="text-xs text-slate-400">Professional Dashboard</p>
                </div>
              </div>
              <div className="flex items-center space-x-4">
                <div className="flex items-center space-x-2 text-sm text-slate-400">
                  <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                  <span>Live</span>
                </div>

                {/* User Info & Logout */}
                <div className="flex items-center space-x-3">
                  <div className="text-right">
                    <p className="text-sm font-medium text-white">{session?.user?.name}</p>
                    <p className="text-xs text-slate-400">{session?.user?.email}</p>
                  </div>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => signOut()}
                    className="bg-slate-700/50 border-slate-600 text-slate-300 hover:bg-slate-700 hover:text-white"
                  >
                    Sign Out
                  </Button>
                </div>
              </div>
            </div>
          </div>
        </header>

        <div className="container mx-auto p-6 space-y-8">
          {/* Page Title */}
          <div className="space-y-2">
            <h2 className="text-2xl font-semibold text-white">Dashboard Overview</h2>
            <p className="text-slate-400">Monitor your energy patterns and productivity insights</p>
          </div>

          {/* Key Metrics */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <Card className="bg-slate-800/50 border-slate-700/50 hover:bg-slate-800/70 transition-all duration-200">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-slate-300">Today's Average</CardTitle>
                <Badge variant="outline" className="bg-emerald-500/10 text-emerald-400 border-emerald-500/20">
                  {weeklyStats.trend}
                </Badge>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-semibold text-white mb-2">{weeklyStats.average}/10</div>
                <Progress value={weeklyStats.average * 10} className="h-1.5 bg-slate-700" />
                <p className="text-xs text-slate-400 mt-2">+12% from yesterday</p>
              </CardContent>
            </Card>

            <Card className="bg-slate-800/50 border-slate-700/50 hover:bg-slate-800/70 transition-all duration-200">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-slate-300">Total Entries</CardTitle>
                <div className="w-4 h-4 text-slate-400">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                    <polyline points="14,2 14,8 20,8"/>
                    <line x1="16" y1="13" x2="8" y2="13"/>
                    <line x1="16" y1="17" x2="8" y2="17"/>
                    <polyline points="10,9 9,9 8,9"/>
                  </svg>
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-semibold text-white">{weeklyStats.entries}</div>
                <p className="text-xs text-slate-400">This week</p>
              </CardContent>
            </Card>

            <Card className="bg-slate-800/50 border-slate-700/50 hover:bg-slate-800/70 transition-all duration-200">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-slate-300">Weekly Average</CardTitle>
                <div className="w-4 h-4 text-slate-400">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <polyline points="22,12 18,12 15,21 9,3 6,12 2,12"/>
                  </svg>
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-semibold text-white">{weeklyStats.weeklyAverage}/10</div>
                <p className="text-xs text-slate-400">Last 7 days</p>
              </CardContent>
            </Card>

            <Card className="bg-slate-800/50 border-slate-700/50 hover:bg-slate-800/70 transition-all duration-200">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-slate-300">Performance</CardTitle>
                <div className="w-4 h-4 text-slate-400">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <circle cx="12" cy="12" r="10"/>
                    <polyline points="12,6 12,12 16,14"/>
                  </svg>
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-semibold text-white">Good</div>
                <p className="text-xs text-slate-400">Above target</p>
              </CardContent>
            </Card>
          </div>

          {/* Main Content Grid */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* Energy Logging Card */}
            <Card className="lg:col-span-1 bg-slate-800/50 border-slate-700/50">
              <CardHeader>
                <CardTitle className="text-white text-lg font-semibold">Log Energy Level</CardTitle>
                <CardDescription className="text-slate-400">Record your current energy state</CardDescription>
              </CardHeader>
              <CardContent className="space-y-6">
                {/* Energy Level Selector */}
                <div>
                  <label className="text-sm font-medium mb-3 block text-slate-300">Energy Level (1-10)</label>
                  <div className="grid grid-cols-5 gap-2">
                    {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((level) => (
                      <Button
                        key={level}
                        variant={selectedEnergyLevel === level ? "default" : "outline"}
                        size="sm"
                        onClick={() => setSelectedEnergyLevel(level)}
                        className={`aspect-square text-sm font-medium transition-all duration-200 ${
                          selectedEnergyLevel === level
                            ? "bg-blue-600 text-white border-blue-600 hover:bg-blue-700"
                            : "bg-slate-700/50 border-slate-600 text-slate-300 hover:bg-slate-700 hover:border-slate-500"
                        }`}
                      >
                        {level}
                      </Button>
                    ))}
                  </div>
                </div>

                {/* Mood Selector */}
                <div>
                  <label className="text-sm font-medium mb-3 block text-slate-300">Mood State</label>
                  <Select value={mood} onValueChange={setMood}>
                    <SelectTrigger className="bg-slate-700/50 border-slate-600 text-white hover:bg-slate-700 transition-colors">
                      <SelectValue placeholder="Select your current mood" />
                    </SelectTrigger>
                    <SelectContent className="bg-slate-800 border-slate-700">
                      <SelectItem value="excellent" className="text-white hover:bg-slate-700">Excellent</SelectItem>
                      <SelectItem value="energized" className="text-white hover:bg-slate-700">Energized</SelectItem>
                      <SelectItem value="good" className="text-white hover:bg-slate-700">Good</SelectItem>
                      <SelectItem value="moderate" className="text-white hover:bg-slate-700">Moderate</SelectItem>
                      <SelectItem value="tired" className="text-white hover:bg-slate-700">Tired</SelectItem>
                      <SelectItem value="low" className="text-white hover:bg-slate-700">Low</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                {/* Note Input */}
                <div>
                  <label className="text-sm font-medium mb-3 block text-slate-300">Notes (optional)</label>
                  <Textarea
                    placeholder="Add context about your energy level..."
                    value={note}
                    onChange={(e) => setNote(e.target.value)}
                    rows={3}
                    className="bg-slate-700/50 border-slate-600 text-white placeholder:text-slate-400 hover:bg-slate-700 focus:bg-slate-700 transition-colors resize-none"
                  />
                </div>

                <Button
                  onClick={handleEnergySubmit}
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white transition-colors duration-200"
                  disabled={!selectedEnergyLevel || !mood}
                >
                  Submit Entry
                </Button>
              </CardContent>
            </Card>

            {/* Recent Entries */}
            <Card className="lg:col-span-2 bg-slate-800/50 border-slate-700/50">
              <CardHeader>
                <CardTitle className="text-white text-lg font-semibold">Recent Activity</CardTitle>
                <CardDescription className="text-slate-400">Latest energy level entries</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  {mockEnergyData.map((entry) => (
                    <div
                      key={entry.id}
                      className="flex items-center space-x-4 p-4 bg-slate-700/30 border border-slate-600/50 rounded-lg hover:bg-slate-700/50 transition-all duration-200"
                    >
                      <div className={`w-12 h-12 rounded-lg flex items-center justify-center text-white font-semibold ${getEnergyColor(entry.level)}`}>
                        {entry.level}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center space-x-3 mb-1">
                          <Badge variant="outline" className="bg-slate-600/50 text-slate-300 border-slate-500 text-xs">
                            {entry.mood}
                          </Badge>
                          <span className="text-xs text-slate-400">{entry.time}</span>
                        </div>
                        <p className="text-sm text-slate-300 truncate">{entry.note}</p>
                      </div>
                      <div className="w-4 h-4 text-slate-500">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <polyline points="9,18 15,12 9,6"/>
                        </svg>
                      </div>
                    </div>
                  ))}
                </div>
                <div className="mt-4 pt-4 border-t border-slate-700">
                  <Button variant="outline" className="w-full bg-slate-700/50 border-slate-600 text-slate-300 hover:bg-slate-700 hover:text-white">
                    View All Entries
                  </Button>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Analytics Section */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <Card className="bg-slate-800/50 border-slate-700/50">
              <CardHeader>
                <CardTitle className="text-white text-lg font-semibold">Insights & Analysis</CardTitle>
                <CardDescription className="text-slate-400">AI-powered energy pattern analysis</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div className="p-4 bg-emerald-500/10 border border-emerald-500/20 rounded-lg">
                    <div className="flex items-start space-x-3">
                      <div className="w-5 h-5 text-emerald-400 mt-0.5">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <polyline points="22,12 18,12 15,21 9,3 6,12 2,12"/>
                        </svg>
                      </div>
                      <div>
                        <h4 className="font-medium text-emerald-300 mb-1">Positive Trend</h4>
                        <p className="text-sm text-emerald-200/80">
                          Energy levels have improved by 15% over the past week.
                        </p>
                      </div>
                    </div>
                  </div>

                  <div className="p-4 bg-blue-500/10 border border-blue-500/20 rounded-lg">
                    <div className="flex items-start space-x-3">
                      <div className="w-5 h-5 text-blue-400 mt-0.5">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <circle cx="12" cy="12" r="10"/>
                          <polyline points="12,6 12,12 16,14"/>
                        </svg>
                      </div>
                      <div>
                        <h4 className="font-medium text-blue-300 mb-1">Peak Performance</h4>
                        <p className="text-sm text-blue-200/80">
                          Optimal energy window: 9:00 AM - 11:00 AM daily.
                        </p>
                      </div>
                    </div>
                  </div>

                  <div className="p-4 bg-amber-500/10 border border-amber-500/20 rounded-lg">
                    <div className="flex items-start space-x-3">
                      <div className="w-5 h-5 text-amber-400 mt-0.5">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M9 11H1l6-6 6 6"/>
                          <path d="M9 17l3 3 3-3"/>
                          <path d="M22 12h-8"/>
                        </svg>
                      </div>
                      <div>
                        <h4 className="font-medium text-amber-300 mb-1">Recommendation</h4>
                        <p className="text-sm text-amber-200/80">
                          Schedule important tasks during morning hours.
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="bg-slate-800/50 border-slate-700/50">
              <CardHeader>
                <CardTitle className="text-white text-lg font-semibold">Weekly Performance</CardTitle>
                <CardDescription className="text-slate-400">Energy distribution across the week</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {weeklyData.map((dayData) => (
                    <div key={dayData.day} className="flex items-center space-x-4">
                      <span className="w-12 text-sm font-medium text-slate-300">{dayData.day}</span>
                      <div className="flex-1">
                        <div className="flex items-center justify-between mb-1">
                          <Progress value={dayData.value} className="flex-1 h-2 bg-slate-700" />
                          <span className="ml-3 text-sm text-slate-400 w-8 text-right">
                            {Math.floor(dayData.value/10)}
                          </span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
                <div className="mt-6 pt-4 border-t border-slate-700">
                  <div className="flex justify-between text-sm">
                    <span className="text-slate-400">Weekly Average</span>
                    <span className="text-white font-medium">7.2/10</span>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
}