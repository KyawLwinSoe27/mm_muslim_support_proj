import "server-only";

import admin from "firebase-admin";
import { readFileSync } from "fs";

function getAdminApp() {
  if (admin.apps.length) return admin.apps[0]!;

  const keyPath = process.env.FIREBASE_SERVICE_ACCOUNT_KEY_PATH;
  if (!keyPath) throw new Error("FIREBASE_SERVICE_ACCOUNT_KEY_PATH not set");

  const serviceAccount = JSON.parse(readFileSync(keyPath, "utf8"));
  return admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
}

export { getAdminApp };
