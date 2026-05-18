import { NextRequest, NextResponse } from "next/server";
import { getAdminApp } from "@/lib/firebase-admin";
import { getFirestore } from "firebase-admin/firestore";

export async function POST(req: NextRequest) {
  try {
    const { title, body, target, platform, token } = await req.json();

    if (!title || !body) {
      return NextResponse.json(
        { ok: false, message: "Title and body are required" },
        { status: 400 }
      );
    }

    const app = getAdminApp();
    const messaging = app ? (await import("firebase-admin/messaging")).getMessaging(app) : null;

    if (!messaging) {
      return NextResponse.json(
        { ok: false, message: "Firebase Admin not configured" },
        { status: 500 }
      );
    }

    let tokens: string[] = [];

    if (target === "token") {
      if (!token) {
        return NextResponse.json(
          { ok: false, message: "Token is required for token target" },
          { status: 400 }
        );
      }
      tokens = [token];
    } else if (target === "platform") {
      const db = getFirestore(app);
      const snapshot = await db
        .collection("users")
        .where("platform", "==", platform)
        .get();
      tokens = snapshot.docs
        .map((d) => d.data().fcmToken as string | undefined)
        .filter((t): t is string => !!t);
    } else {
      // all
      const db = getFirestore(app);
      const snapshot = await db.collection("users").get();
      tokens = snapshot.docs
        .map((d) => d.data().fcmToken as string | undefined)
        .filter((t): t is string => !!t);
    }

    if (tokens.length === 0) {
      return NextResponse.json(
        { ok: false, message: "No FCM tokens found for the selected target" },
        { status: 404 }
      );
    }

    const message = {
      notification: { title, body },
      tokens,
    };

    const response = await messaging.sendEachForMulticast(message);

    const success = response.successCount;
    const failure = response.failureCount;

    return NextResponse.json({
      ok: true,
      message: `Sent to ${success} device(s)${failure > 0 ? `, ${failure} failed` : ""}`,
      success,
      failure,
    });
  } catch (e) {
    console.error("Push error:", e);
    return NextResponse.json(
      { ok: false, message: "Internal server error" },
      { status: 500 }
    );
  }
}
