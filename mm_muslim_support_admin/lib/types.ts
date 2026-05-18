import { Timestamp } from "firebase/firestore";

export interface ContentDoc {
  id: string;
  arabic: string;
  translation: string;
  mmTranslation?: string;
  reference: string;
  active: boolean;
  order: number;
}

export interface UserDoc {
  deviceId: string;
  deviceModel?: string;
  deviceName?: string;
  platform?: string;
  osVersion?: string;
  appVersion?: string;
  fcmToken?: string;
  language?: string;
  timezone?: string;
  firstSeenAt?: string;
  lastSeenAt?: string;
}

export interface PushPayload {
  title: string;
  body: string;
  target: "all" | "platform" | "token";
  platform?: "android" | "ios";
  token?: string;
}

export interface AnalyticsEvent {
  id: string;
  eventName: string;
  screenName?: string;
  parameters?: Record<string, unknown>;
  timestamp: string;
  deviceId?: string;
  platform?: string;
  appVersion?: string;
  sessionId?: string;
  serverTimestamp?: Timestamp;
}

export interface AnalyticsSummary {
  totalEvents: number;
  uniqueDevices: number;
  uniqueSessions: number;
  topEvents: { name: string; count: number }[];
  eventsByDay: { date: string; count: number }[];
  eventsByPlatform: { platform: string; count: number }[];
  eventsByScreen: { screen: string; count: number }[];
}
