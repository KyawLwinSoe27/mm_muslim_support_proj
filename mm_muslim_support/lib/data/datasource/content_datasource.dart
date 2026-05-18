import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';

class ContentDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DailyQuranDuaModel>> getQuranVerses() async {
    final snapshot = await _firestore
        .collection('quran_verses')
        .where('active', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs.map(_toModel).toList();
  }

  Future<List<DailyQuranDuaModel>> getDailyDuas() async {
    final snapshot = await _firestore
        .collection('daily_duas')
        .where('active', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs.map(_toModel).toList();
  }

  Future<List<DailyQuranDuaModel>> getHadiths() async {
    final snapshot = await _firestore
        .collection('hadiths')
        .where('active', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs.map(_toModel).toList();
  }

  DailyQuranDuaModel _toModel(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyQuranDuaModel(
      arabic: data['arabic'] as String,
      translation: data['translation'] as String,
      mmTranslation: data['mmTranslation'] as String? ?? '',
      reference: data['reference'] as String? ?? '',
    );
  }
}
