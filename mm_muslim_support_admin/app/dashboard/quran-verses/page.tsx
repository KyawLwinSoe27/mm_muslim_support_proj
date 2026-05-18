"use client";

import ContentManager from "@/components/ContentManager";
import { BookOpen } from "lucide-react";

export default function QuranVersesPage() {
  return (
    <ContentManager
      collection="quran_verses"
      title="Quran Verses"
      icon={<BookOpen size={24} className="text-emerald-600" />}
    />
  );
}
