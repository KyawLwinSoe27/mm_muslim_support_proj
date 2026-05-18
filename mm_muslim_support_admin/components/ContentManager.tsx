"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { onAuthStateChanged } from "firebase/auth";
import {
  getClient,
  fetchContent,
  addContent,
  updateContent,
  deleteContent,
} from "@/lib/firebase-client";
import { ContentDoc } from "@/lib/types";
import { Plus, Pencil, Trash2, X, Check } from "lucide-react";

type CollectionName = "quran_verses" | "daily_duas" | "hadiths";

interface Props {
  collection: CollectionName;
  title: string;
  icon: React.ReactNode;
}

export default function ContentManager({ collection, title, icon }: Props) {
  const router = useRouter();
  const [items, setItems] = useState<ContentDoc[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState({
    arabic: "",
    translation: "",
    mmTranslation: "",
    reference: "",
    active: true,
    order: 1,
  });

  useEffect(() => {
    const { auth } = getClient();
    const unsub = onAuthStateChanged(auth, (user) => {
      if (!user) router.push("/login");
    });
    return () => unsub();
  }, [router]);

  const load = async () => {
    setLoading(true);
    const data = await fetchContent(collection);
    setItems(data);
    setLoading(false);
  };

  useEffect(() => {
    load();
  }, [collection]);

  const resetForm = () => {
    setForm({ arabic: "", translation: "", mmTranslation: "", reference: "", active: true, order: 1 });
    setEditingId(null);
    setShowForm(false);
  };

  const openEdit = (item: ContentDoc) => {
    setForm({
      arabic: item.arabic,
      translation: item.translation,
      mmTranslation: item.mmTranslation || "",
      reference: item.reference,
      active: item.active,
      order: item.order,
    });
    setEditingId(item.id);
    setShowForm(true);
  };

  const handleSave = async () => {
    if (!form.arabic.trim() || !form.translation.trim()) return;
    if (editingId) {
      await updateContent(collection, editingId, form);
    } else {
      await addContent(collection, form);
    }
    resetForm();
    await load();
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Delete this item?")) return;
    await deleteContent(collection, id);
    await load();
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-2">
          {icon}
          <h1 className="text-2xl font-bold text-gray-800">{title}</h1>
        </div>
        <button
          onClick={() => setShowForm(true)}
          className="flex items-center gap-1.5 px-4 py-2 bg-[#1b7a4a] text-white text-sm font-medium rounded-lg hover:bg-[#155f3a] transition-colors"
        >
          <Plus size={16} />
          Add New
        </button>
      </div>

      {showForm && (
        <div className="bg-white border border-gray-200 rounded-xl p-5 mb-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-1">Arabic</label>
              <textarea
                value={form.arabic}
                onChange={(e) => setForm({ ...form, arabic: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1b7a4a]"
                rows={2}
                dir="rtl"
              />
            </div>
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-1">Translation (English)</label>
              <textarea
                value={form.translation}
                onChange={(e) => setForm({ ...form, translation: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1b7a4a]"
                rows={2}
              />
            </div>
            <div className="md:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-1">Translation (Burmese)</label>
              <textarea
                value={form.mmTranslation}
                onChange={(e) => setForm({ ...form, mmTranslation: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1b7a4a]"
                rows={2}
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Reference</label>
              <input
                type="text"
                value={form.reference}
                onChange={(e) => setForm({ ...form, reference: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1b7a4a]"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Order</label>
              <input
                type="number"
                value={form.order}
                onChange={(e) => setForm({ ...form, order: parseInt(e.target.value) || 0 })}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#1b7a4a]"
              />
            </div>
            <div className="flex items-center gap-2">
              <input
                type="checkbox"
                id="active"
                checked={form.active}
                onChange={(e) => setForm({ ...form, active: e.target.checked })}
                className="rounded border-gray-300"
              />
              <label htmlFor="active" className="text-sm text-gray-700">Active</label>
            </div>
          </div>

          <div className="flex gap-2">
            <button
              onClick={handleSave}
              className="flex items-center gap-1.5 px-4 py-2 bg-[#1b7a4a] text-white text-sm font-medium rounded-lg hover:bg-[#155f3a] transition-colors"
            >
              <Check size={16} />
              {editingId ? "Update" : "Save"}
            </button>
            <button
              onClick={resetForm}
              className="flex items-center gap-1.5 px-4 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-200 transition-colors"
            >
              <X size={16} />
              Cancel
            </button>
          </div>
        </div>
      )}

      {loading ? (
        <p className="text-gray-500">Loading...</p>
      ) : items.length === 0 ? (
        <p className="text-gray-500">No items yet. Add one above.</p>
      ) : (
        <div className="bg-white border border-gray-200 rounded-xl overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-200 bg-gray-50">
                <th className="text-left px-4 py-3 font-medium text-gray-600">Order</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Arabic</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Translation (EN)</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Translation (MM)</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Reference</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Active</th>
                <th className="text-right px-4 py-3 font-medium text-gray-600">Actions</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id} className="border-b border-gray-100 hover:bg-gray-50">
                  <td className="px-4 py-3 text-gray-600">{item.order}</td>
                  <td className="px-4 py-3 text-gray-800 font-arabic max-w-xs truncate" dir="rtl">
                    {item.arabic}
                  </td>
                  <td className="px-4 py-3 text-gray-600 max-w-xs truncate">{item.translation}</td>
                  <td className="px-4 py-3 text-gray-600 max-w-xs truncate">{item.mmTranslation || "-"}</td>
                  <td className="px-4 py-3 text-gray-500">{item.reference}</td>
                  <td className="px-4 py-3">
                    <span
                      className={`inline-block w-2 h-2 rounded-full ${
                        item.active ? "bg-green-500" : "bg-gray-300"
                      }`}
                    />
                  </td>
                  <td className="px-4 py-3 text-right">
                    <button
                      onClick={() => openEdit(item)}
                      className="p-1.5 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                    >
                      <Pencil size={16} />
                    </button>
                    <button
                      onClick={() => handleDelete(item.id)}
                      className="p-1.5 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors ml-1"
                    >
                      <Trash2 size={16} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
