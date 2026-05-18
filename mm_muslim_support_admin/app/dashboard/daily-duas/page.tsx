"use client";

import ContentManager from "@/components/ContentManager";
import { Heart } from "lucide-react";

export default function DailyDuasPage() {
  return (
    <ContentManager
      collection="daily_duas"
      title="Daily Duas"
      icon={<Heart size={24} className="text-rose-600" />}
    />
  );
}
