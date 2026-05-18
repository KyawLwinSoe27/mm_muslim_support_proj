"use client";

import ContentManager from "@/components/ContentManager";
import { Quote } from "lucide-react";

export default function HadithsPage() {
  return (
    <ContentManager
      collection="hadiths"
      title="Hadiths"
      icon={<Quote size={24} className="text-amber-600" />}
    />
  );
}
