"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { onAuthStateChanged } from "firebase/auth";
import { getClient, getDashboardStats } from "@/lib/firebase-client";
import { BookOpen, Heart, Quote, Users } from "lucide-react";

export default function DashboardPage() {
  const router = useRouter();
  const [stats, setStats] = useState({
    totalUsers: 0,
    totalVerses: 0,
    totalDuas: 0,
    totalHadiths: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const { auth } = getClient();
    const unsub = onAuthStateChanged(auth, (user) => {
      if (!user) router.push("/login");
    });
    return () => unsub();
  }, [router]);

  useEffect(() => {
    getDashboardStats()
      .then(setStats)
      .finally(() => setLoading(false));
  }, []);

  const cards = [
    { label: "Total Users", value: stats.totalUsers, icon: Users, color: "bg-blue-50 text-blue-700" },
    { label: "Quran Verses", value: stats.totalVerses, icon: BookOpen, color: "bg-emerald-50 text-emerald-700" },
    { label: "Daily Duas", value: stats.totalDuas, icon: Heart, color: "bg-rose-50 text-rose-700" },
    { label: "Hadiths", value: stats.totalHadiths, icon: Quote, color: "bg-amber-50 text-amber-700" },
  ];

  return (
    <div>
      <h1 className="text-2xl font-bold text-gray-800 mb-6">Dashboard</h1>

      {loading ? (
        <p className="text-gray-500">Loading stats...</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {cards.map((card) => (
            <div
              key={card.label}
              className="bg-white border border-gray-200 rounded-xl p-5"
            >
              <div className="flex items-center justify-between mb-3">
                <div className={`p-2 rounded-lg ${card.color}`}>
                  <card.icon size={20} />
                </div>
              </div>
              <p className="text-2xl font-bold text-gray-900">{card.value}</p>
              <p className="text-sm text-gray-500">{card.label}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
