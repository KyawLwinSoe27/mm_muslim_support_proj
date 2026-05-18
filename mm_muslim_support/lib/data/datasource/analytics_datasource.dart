import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'analytics_events';

  Future<void> recordEvent(Map<String, dynamic> event) async {
    await _firestore.collection(_collection).add({
      ...event,
      'serverTimestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> recordEventBatch(List<Map<String, dynamic>> events) async {
    final batch = _firestore.batch();
    for (final event in events) {
      final ref = _firestore.collection(_collection).doc();
      batch.set(ref, {
        ...event,
        'serverTimestamp': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
