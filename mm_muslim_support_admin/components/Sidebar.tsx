"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  LayoutDashboard,
  BookOpen,
  Heart,
  Quote,
  Users,
  Bell,
  BarChart3,
  LogOut,
} from "lucide-react";
import { getAuth, signOut } from "firebase/auth";
import { useRouter } from "next/navigation";

const navItems = [
  { href: "/dashboard", label: "Dashboard", icon: LayoutDashboard },
  { href: "/dashboard/quran-verses", label: "Quran Verses", icon: BookOpen },
  { href: "/dashboard/daily-duas", label: "Daily Duas", icon: Heart },
  { href: "/dashboard/hadiths", label: "Hadiths", icon: Quote },
  { href: "/dashboard/users", label: "Users", icon: Users },
  { href: "/dashboard/push", label: "Push Notifications", icon: Bell },
  { href: "/dashboard/analytics", label: "Analytics", icon: BarChart3 },
];

export default function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();

  const handleLogout = async () => {
    await signOut(getAuth());
    router.push("/login");
  };

  return (
    <aside className="w-64 bg-white border-r border-gray-200 h-screen flex flex-col">
      <div className="p-5 border-b border-gray-200">
        <h1 className="text-lg font-bold text-[#1b7a4a]">Minara Admin</h1>
        <p className="text-xs text-gray-500 mt-1">Content Management</p>
      </div>

      <nav className="flex-1 p-3 space-y-1">
        {navItems.map((item) => {
          const active = pathname === item.href;
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                active
                  ? "bg-[#b3f1be] text-[#00210c]"
                  : "text-gray-600 hover:bg-gray-100"
              }`}
            >
              <item.icon size={18} />
              {item.label}
            </Link>
          );
        })}
      </nav>

      <div className="p-3 border-t border-gray-200">
        <button
          onClick={handleLogout}
          className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium text-gray-600 hover:bg-gray-100 w-full transition-colors"
        >
          <LogOut size={18} />
          Sign Out
        </button>
      </div>
    </aside>
  );
}
