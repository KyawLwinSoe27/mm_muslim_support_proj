"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { onAuthStateChanged } from "firebase/auth";
import { getClient, fetchUsers } from "@/lib/firebase-client";
import { UserDoc } from "@/lib/types";
import { Smartphone, Globe, Eye, X } from "lucide-react";

export default function UsersPage() {
  const router = useRouter();
  const [users, setUsers] = useState<UserDoc[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedUser, setSelectedUser] = useState<UserDoc | null>(null);

  useEffect(() => {
    const { auth } = getClient();
    const unsub = onAuthStateChanged(auth, (user) => {
      if (!user) router.push("/login");
    });
    return () => unsub();
  }, [router]);

  useEffect(() => {
    fetchUsers()
      .then(setUsers)
      .finally(() => setLoading(false));
  }, []);

  return (
    <div>
      <div className="flex items-center gap-2 mb-6">
        <Smartphone size={24} className="text-blue-600" />
        <h1 className="text-2xl font-bold text-gray-800">Users</h1>
        <span className="text-sm text-gray-500 ml-2">({users.length} total)</span>
      </div>

      {loading ? (
        <p className="text-gray-500">Loading...</p>
      ) : users.length === 0 ? (
        <p className="text-gray-500">No users registered yet.</p>
      ) : (
        <div className="bg-white border border-gray-200 rounded-xl overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-200 bg-gray-50">
                <th className="text-left px-4 py-3 font-medium text-gray-600">Device ID</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Model</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Platform</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">App Version</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Language</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Last Seen</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Actions</th>
              </tr>
            </thead>
            <tbody>
              {users.map((u) => (
                <tr key={u.deviceId} className="border-b border-gray-100 hover:bg-gray-50">
                  <td className="px-4 py-3 font-mono text-xs text-gray-600 max-w-[120px] truncate">
                    {u.deviceId}
                  </td>
                  <td className="px-4 py-3 text-gray-700">{u.deviceModel ?? "-"}</td>
                  <td className="px-4 py-3">
                    <span className="flex items-center gap-1">
                      <Globe size={14} className="text-gray-400" />
                      {u.platform ?? "-"}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-500">{u.appVersion ?? "-"}</td>
                  <td className="px-4 py-3 text-gray-500">{u.language ?? "-"}</td>
                  <td className="px-4 py-3 text-gray-500 text-xs">
                    {u.lastSeenAt
                      ? new Date(u.lastSeenAt).toLocaleDateString()
                      : "-"}
                  </td>
                  <td className="px-4 py-3">
                    <button
                      onClick={() => setSelectedUser(u)}
                      className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                      title="View Details"
                    >
                      <Eye size={16} className="text-gray-500" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {selectedUser && (
        <UserDetailModal user={selectedUser} onClose={() => setSelectedUser(null)} />
      )}
    </div>
  );
}

function UserDetailModal({ user, onClose }: { user: UserDoc; onClose: () => void }) {
  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl w-full max-w-lg max-h-[80vh] overflow-hidden shadow-2xl">
        <div className="flex items-center justify-between p-6 border-b border-gray-200">
          <h2 className="text-xl font-bold text-gray-800">User Details</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X size={20} className="text-gray-500" />
          </button>
        </div>
        <div className="p-6 overflow-y-auto max-h-[calc(80vh-80px)]">
          <div className="space-y-4">
            <DetailRow label="Device ID" value={user.deviceId} mono />
            <DetailRow label="Device Name" value={user.deviceName ?? "-"} />
            <DetailRow label="Device Model" value={user.deviceModel ?? "-"} />
            <DetailRow label="Platform" value={user.platform ?? "-"} />
            <DetailRow label="OS Version" value={user.osVersion ?? "-"} />
            <DetailRow label="App Version" value={user.appVersion ?? "-"} />
            <DetailRow label="Language" value={user.language ?? "-"} />
            <DetailRow label="Timezone" value={user.timezone ?? "-"} />
            <DetailRow label="First Seen" value={user.firstSeenAt ? new Date(user.firstSeenAt).toLocaleString() : "-"} />
            <DetailRow label="Last Seen" value={user.lastSeenAt ? new Date(user.lastSeenAt).toLocaleString() : "-"} />
            <div>
              <p className="text-sm font-medium text-gray-500 mb-1">FCM Token</p>
              <div className="bg-gray-50 rounded-lg p-3 break-all text-xs font-mono text-gray-600 max-h-32 overflow-y-auto">
                {user.fcmToken ?? "-"}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function DetailRow({ label, value, mono }: { label: string; value: string; mono?: boolean }) {
  return (
    <div>
      <p className="text-sm font-medium text-gray-500 mb-1">{label}</p>
      <p className={`text-gray-800 ${mono ? "font-mono text-sm break-all" : ""}`}>{value}</p>
    </div>
  );
}
