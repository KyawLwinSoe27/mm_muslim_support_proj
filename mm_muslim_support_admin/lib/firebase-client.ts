import { initializeApp, getApps, FirebaseApp } from "firebase/app";
import { getAuth, Auth } from "firebase/auth";
import {
  getFirestore,
  Firestore,
  collection,
  getDocs,
  doc,
  getDoc,
  addDoc,
  updateDoc,
  deleteDoc,
  query,
  where,
  orderBy,
  Timestamp,
  DocumentData,
} from "firebase/firestore";
import { ContentDoc, UserDoc, AnalyticsEvent, AnalyticsSummary } from "./types";

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
};

let app: FirebaseApp;
let auth: Auth;
let db: Firestore;

function getClient() {
  if (!getApps().length) {
    app = initializeApp(firebaseConfig);
    auth = getAuth(app);
    db = getFirestore(app);
  }
  return { auth, db };
}

export { getClient };

const COLLECTIONS = ["quran_verses", "daily_duas", "hadiths"] as const;

export async function fetchContent(
  collectionName: (typeof COLLECTIONS)[number]
): Promise<ContentDoc[]> {
  const { db } = getClient();
  const q = query(
    collection(db, collectionName),
    orderBy("order", "asc")
  );
  const snapshot = await getDocs(q);
  return snapshot.docs.map((d) => ({ id: d.id, ...d.data() } as ContentDoc));
}

export async function addContent(
  collectionName: (typeof COLLECTIONS)[number],
  data: Omit<ContentDoc, "id">
) {
  const { db } = getClient();
  return addDoc(collection(db, collectionName), data);
}

export async function updateContent(
  collectionName: (typeof COLLECTIONS)[number],
  id: string,
  data: Partial<ContentDoc>
) {
  const { db } = getClient();
  return updateDoc(doc(db, collectionName, id), data);
}

export async function deleteContent(
  collectionName: (typeof COLLECTIONS)[number],
  id: string
) {
  const { db } = getClient();
  return deleteDoc(doc(db, collectionName, id));
}

export async function fetchUsers(): Promise<UserDoc[]> {
  const { db } = getClient();
  const snapshot = await getDocs(
    query(collection(db, "users"), orderBy("lastSeenAt", "desc"))
  );
  return snapshot.docs.map((d) => ({ deviceId: d.id, ...d.data() } as UserDoc));
}

export async function fetchAnalyticsEvents(
  days: number = 30
): Promise<AnalyticsEvent[]> {
  const { db } = getClient();
  const since = new Date();
  since.setDate(since.getDate() - days);

  const q = query(
    collection(db, "analytics_events"),
    where("timestamp", ">=", since.toISOString()),
    orderBy("timestamp", "desc")
  );
  const snapshot = await getDocs(q);
  return snapshot.docs.map(
    (d) => ({ id: d.id, ...d.data() } as AnalyticsEvent)
  );
}

export async function getAnalyticsSummary(
  days: number = 30
): Promise<AnalyticsSummary> {
  const events = await fetchAnalyticsEvents(days);

  const uniqueDevices = new Set(events.map((e) => e.deviceId).filter(Boolean));
  const uniqueSessions = new Set(events.map((e) => e.sessionId).filter(Boolean));
  const eventCounts: Record<string, number> = {};
  const dayCounts: Record<string, number> = {};
  const platformCounts: Record<string, number> = {};
  const screenCounts: Record<string, number> = {};

  for (const event of events) {
    eventCounts[event.eventName] = (eventCounts[event.eventName] || 0) + 1;
    platformCounts[event.platform || "unknown"] =
      (platformCounts[event.platform || "unknown"] || 0) + 1;
    if (event.screenName) {
      screenCounts[event.screenName] =
        (screenCounts[event.screenName] || 0) + 1;
    }
    const day = event.timestamp?.split("T")[0];
    if (day) {
      dayCounts[day] = (dayCounts[day] || 0) + 1;
    }
  }

  const topEvents = Object.entries(eventCounts)
    .map(([name, count]) => ({ name, count }))
    .sort((a, b) => b.count - a.count)
    .slice(0, 10);

  const eventsByDay = Object.entries(dayCounts)
    .map(([date, count]) => ({ date, count }))
    .sort((a, b) => a.date.localeCompare(b.date));

  const eventsByPlatform = Object.entries(platformCounts)
    .map(([platform, count]) => ({ platform, count }))
    .sort((a, b) => b.count - a.count);

  const eventsByScreen = Object.entries(screenCounts)
    .map(([screen, count]) => ({ screen, count }))
    .sort((a, b) => b.count - a.count);

  return {
    totalEvents: events.length,
    uniqueDevices: uniqueDevices.size,
    uniqueSessions: uniqueSessions.size,
    topEvents,
    eventsByDay,
    eventsByPlatform,
    eventsByScreen,
  };
}

export async function getDashboardStats() {
  const { db } = getClient();
  const [usersSnap, versesSnap, duasSnap, hadithsSnap] = await Promise.all([
    getDocs(collection(db, "users")),
    getDocs(collection(db, "quran_verses")),
    getDocs(collection(db, "daily_duas")),
    getDocs(collection(db, "hadiths")),
  ]);
  return {
    totalUsers: usersSnap.size,
    totalVerses: versesSnap.size,
    totalDuas: duasSnap.size,
    totalHadiths: hadithsSnap.size,
  };
}
