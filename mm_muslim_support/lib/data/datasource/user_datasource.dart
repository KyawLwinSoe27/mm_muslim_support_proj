import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mm_muslim_support/model/device_info.dart';

class UserDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'users';

  Future<DeviceInfo?> getByDeviceId(String deviceId) async {
    final doc = await _firestore.collection(_collection).doc(deviceId).get();
    if (!doc.exists || doc.data() == null) return null;
    return DeviceInfo.fromJson(doc.data()!);
  }

  Future<void> create(DeviceInfo info) async {
    await _firestore.collection(_collection).doc(info.deviceId).set({
      ...info.toJson(),
      'firstSeenAt': FieldValue.serverTimestamp(),
      'lastSeenAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> update(DeviceInfo info) async {
    await _firestore.collection(_collection).doc(info.deviceId).update({
      ...info.toJson(),
      'lastSeenAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateFcmToken(String deviceId, String? token) async {
    await _firestore.collection(_collection).doc(deviceId).set({
      'fcmToken': token,
      'lastSeenAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
