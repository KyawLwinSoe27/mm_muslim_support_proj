"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { onAuthStateChanged } from "firebase/auth";
import { getClient } from "@/lib/firebase-client";
import { Bell, Send, Users, Smartphone, Fingerprint } from "lucide-react";

export default function PushPage() {
  const router = useRouter();
  const [title, setTitle] = useState("");
  const [body, setBody] = useState("");
  const [target, setTarget] = useState<"all" | "platform" | "token">("all");
  const [platform, setPlatform] = useState<"android" | "ios">("android");
  const [token, setToken] = useState("");
  const [sending, setSending] = useState(false);
  const [result, setResult] = useState<{ ok: boolean; message: string } | null>(null);

  useEffect(() => {
    const { auth } = getClient();
    const unsub = onAuthStateChanged(auth, (user) => {
      if (!user) router.push("/login");
    });
    return () => unsub();
  }, [router]);

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim() || !body.trim()) return;

    setSending(true);
    setResult(null);

    try {
      const res = await fetch("/api/send-push", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          title,
          body,
          target,
          ...(target === "platform" && { platform }),
          ...(target === "token" && { token }),
        }),
      });
      const data = await res.json();
      setResult(data);
    } catch {
      setResult({ ok: false, message: "Network error" });
    } finally {
      setSending(false);
    }
  };

  return (
    <div>
      <div className="flex items-center gap-2 mb-6">
        <Bell size={24} className="text-purple-600" />
        <h1 className="text-2xl font-bold text-gray-800">Push Notifications</h1>
      </div>

      <div className="max-w-xl bg-white border border-gray-200 rounded-xl p-6">
        <form onSubmit={handleSend} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Title</label>
            <input
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1b7a4a]"
              placeholder="Notification title"
              required
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Body</label>
            <textarea
              value={body}
              onChange={(e) => setBody(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1b7a4a]"
              rows={3}
              placeholder="Notification message"
              required
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Send to</label>
            <div className="flex flex-wrap gap-2">
              <button
                type="button"
                onClick={() => setTarget("all")}
                className={`flex items-center gap-1.5 px-3 py-2 rounded-lg text-sm font-medium border transition-colors ${
                  target === "all"
                    ? "bg-[#1b7a4a] text-white border-[#1b7a4a]"
                    : "bg-white text-gray-600 border-gray-300 hover:bg-gray-50"
                }`}
              >
                <Users size={16} /> All Users
              </button>
              <button
                type="button"
                onClick={() => setTarget("platform")}
                className={`flex items-center gap-1.5 px-3 py-2 rounded-lg text-sm font-medium border transition-colors ${
                  target === "platform"
                    ? "bg-[#1b7a4a] text-white border-[#1b7a4a]"
                    : "bg-white text-gray-600 border-gray-300 hover:bg-gray-50"
                }`}
              >
                <Smartphone size={16} /> By Platform
              </button>
              <button
                type="button"
                onClick={() => setTarget("token")}
                className={`flex items-center gap-1.5 px-3 py-2 rounded-lg text-sm font-medium border transition-colors ${
                  target === "token"
                    ? "bg-[#1b7a4a] text-white border-[#1b7a4a]"
                    : "bg-white text-gray-600 border-gray-300 hover:bg-gray-50"
                }`}
              >
                <Fingerprint size={16} /> Specific Token
              </button>
            </div>
          </div>

          {target === "platform" && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Platform</label>
              <select
                value={platform}
                onChange={(e) => setPlatform(e.target.value as "android" | "ios")}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1b7a4a]"
              >
                <option value="android">Android</option>
                <option value="ios">iOS</option>
              </select>
            </div>
          )}

          {target === "token" && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">FCM Token</label>
              <input
                type="text"
                value={token}
                onChange={(e) => setToken(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm font-mono focus:outline-none focus:ring-2 focus:ring-[#1b7a4a]"
                placeholder="Paste FCM token"
                required
              />
            </div>
          )}

          {result && (
            <div
              className={`p-3 rounded-lg text-sm ${
                result.ok
                  ? "bg-green-50 text-green-700 border border-green-200"
                  : "bg-red-50 text-red-700 border border-red-200"
              }`}
            >
              {result.message}
            </div>
          )}

          <button
            type="submit"
            disabled={sending}
            className="flex items-center gap-1.5 px-4 py-2.5 bg-[#1b7a4a] text-white text-sm font-medium rounded-lg hover:bg-[#155f3a] disabled:opacity-50 transition-colors"
          >
            <Send size={16} />
            {sending ? "Sending..." : "Send Notification"}
          </button>
        </form>
      </div>
    </div>
  );
}
