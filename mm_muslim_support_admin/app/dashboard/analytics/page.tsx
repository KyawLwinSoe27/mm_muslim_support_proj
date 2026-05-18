"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { onAuthStateChanged } from "firebase/auth";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  LineChart,
  Line,
} from "recharts";
import {
  getClient,
  getAnalyticsSummary,
} from "@/lib/firebase-client";
import { AnalyticsSummary } from "@/lib/types";
import { Activity, Smartphone, Users, BarChart3 } from "lucide-react";

const COLORS = [
  "#1b7a4a", "#22c55e", "#86efac", "#f59e0b",
  "#ef4444", "#8b5cf6", "#3b82f6", "#ec4899",
];

export default function AnalyticsPage() {
  const router = useRouter();
  const [summary, setSummary] = useState<AnalyticsSummary | null>(null);
  const [loading, setLoading] = useState(true);
  const [days, setDays] = useState(30);

  useEffect(() => {
    const { auth } = getClient();
    const unsub = onAuthStateChanged(auth, (user) => {
      if (!user) router.push("/login");
    });
    return () => unsub();
  }, [router]);

  useEffect(() => {
    setLoading(true);
    getAnalyticsSummary(days)
      .then(setSummary)
      .finally(() => setLoading(false));
  }, [days]);

  const statCards = [
    {
      label: "Total Events",
      value: summary?.totalEvents ?? 0,
      icon: Activity,
      color: "bg-blue-50 text-blue-700",
    },
    {
      label: "Unique Devices",
      value: summary?.uniqueDevices ?? 0,
      icon: Smartphone,
      color: "bg-emerald-50 text-emerald-700",
    },
    {
      label: "Unique Sessions",
      value: summary?.uniqueSessions ?? 0,
      icon: Users,
      color: "bg-amber-50 text-amber-700",
    },
    {
      label: "Event Types",
      value: summary?.topEvents.length ?? 0,
      icon: BarChart3,
      color: "bg-purple-50 text-purple-700",
    },
  ];

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-gray-800">Analytics</h1>
        <select
          value={days}
          onChange={(e) => setDays(Number(e.target.value))}
          className="border border-gray-300 rounded-lg px-3 py-2 text-sm bg-white"
        >
          <option value={7}>Last 7 days</option>
          <option value={30}>Last 30 days</option>
          <option value={90}>Last 90 days</option>
        </select>
      </div>

      {loading ? (
        <p className="text-gray-500">Loading analytics...</p>
      ) : (
        <div className="space-y-6">
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {statCards.map((card) => (
              <div
                key={card.label}
                className="bg-white border border-gray-200 rounded-xl p-5"
              >
                <div className="flex items-center justify-between mb-3">
                  <div className={`p-2 rounded-lg ${card.color}`}>
                    <card.icon size={20} />
                  </div>
                </div>
                <p className="text-2xl font-bold text-gray-900">
                  {card.value}
                </p>
                <p className="text-sm text-gray-500">{card.label}</p>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div className="bg-white border border-gray-200 rounded-xl p-5">
              <h2 className="text-lg font-semibold text-gray-800 mb-4">
                Events Over Time
              </h2>
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={summary?.eventsByDay ?? []}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                  <XAxis
                    dataKey="date"
                    tick={{ fontSize: 12 }}
                    tickFormatter={(v) => {
                      const d = new Date(v);
                      return `${d.getMonth() + 1}/${d.getDate()}`;
                    }}
                  />
                  <YAxis tick={{ fontSize: 12 }} />
                  <Tooltip />
                  <Line
                    type="monotone"
                    dataKey="count"
                    stroke="#1b7a4a"
                    strokeWidth={2}
                    dot={false}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>

            <div className="bg-white border border-gray-200 rounded-xl p-5">
              <h2 className="text-lg font-semibold text-gray-800 mb-4">
                Events by Platform
              </h2>
              <ResponsiveContainer width="100%" height={300}>
                <PieChart>
                  <Pie
                    data={summary?.eventsByPlatform ?? []}
                    dataKey="count"
                    nameKey="platform"
                    cx="50%"
                    cy="50%"
                    outerRadius={100}
                    label={({ platform, percent }) =>
                      `${platform} (${(percent * 100).toFixed(0)}%)`
                    }
                  >
                    {(summary?.eventsByPlatform ?? []).map((_, i) => (
                      <Cell
                        key={i}
                        fill={COLORS[i % COLORS.length]}
                      />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            </div>

            <div className="bg-white border border-gray-200 rounded-xl p-5">
              <h2 className="text-lg font-semibold text-gray-800 mb-4">
                Top Events
              </h2>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart
                  data={summary?.topEvents ?? []}
                  layout="vertical"
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                  <XAxis type="number" tick={{ fontSize: 12 }} />
                  <YAxis
                    type="category"
                    dataKey="name"
                    tick={{ fontSize: 12 }}
                    width={120}
                  />
                  <Tooltip />
                  <Bar dataKey="count" fill="#1b7a4a" radius={[0, 4, 4, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>

            <div className="bg-white border border-gray-200 rounded-xl p-5">
              <h2 className="text-lg font-semibold text-gray-800 mb-4">
                Events by Screen
              </h2>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart
                  data={summary?.eventsByScreen ?? []}
                  layout="vertical"
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                  <XAxis type="number" tick={{ fontSize: 12 }} />
                  <YAxis
                    type="category"
                    dataKey="screen"
                    tick={{ fontSize: 12 }}
                    width={120}
                  />
                  <Tooltip />
                  <Bar
                    dataKey="count"
                    fill="#22c55e"
                    radius={[0, 4, 4, 0]}
                  />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
