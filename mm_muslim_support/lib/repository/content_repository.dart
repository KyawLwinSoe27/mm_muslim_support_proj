import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mm_muslim_support/dao/content_cache_dao.dart';
import 'package:mm_muslim_support/data/datasource/content_datasource.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

enum ContentType { quranVerses, dailyDuas, hadiths }

class ContentRepository {
  final ContentDataSource _dataSource = ContentDataSource();
  final ContentCacheDao _cacheDao = ContentCacheDao();

  Future<List<DailyQuranDuaModel>> getQuranVerses() async {
    final cached = await _cacheDao.getQuranVerses();
    if (cached.isNotEmpty) {
      _syncIfStale(ContentType.quranVerses);
      return cached;
    }
    final remote = await _fetchAndCache(ContentType.quranVerses);
    return remote.isNotEmpty ? remote : dailyQuranList;
  }

  Future<List<DailyQuranDuaModel>> getDailyDuas() async {
    final cached = await _cacheDao.getDailyDuas();
    if (cached.isNotEmpty) {
      _syncIfStale(ContentType.dailyDuas);
      return cached;
    }
    final remote = await _fetchAndCache(ContentType.dailyDuas);
    return remote.isNotEmpty ? remote : dailyDuaList;
  }

  Future<List<DailyQuranDuaModel>> getHadiths() async {
    final cached = await _cacheDao.getHadiths();
    if (cached.isNotEmpty) {
      _syncIfStale(ContentType.hadiths);
      return cached;
    }
    final remote = await _fetchAndCache(ContentType.hadiths);
    return remote.isNotEmpty ? remote : dailyDuaList;
  }

  Future<List<DailyQuranDuaModel>> _fetchAndCache(ContentType type) async {
    final isOnline = await _checkConnectivity();
    if (!isOnline) return [];

    try {
      final items = await _fetchFromFirestore(type);
      await _replaceCache(type, items);
      await _setLastSync(type);
      return items;
    } catch (_) {
      return [];
    }
  }

  Future<void> _syncIfStale(ContentType type) async {
    final lastSync = _getLastSyncKey(type);
    final lastSyncTime = SharedPreferenceService.getLastSyncTime(lastSync);
    if (lastSyncTime != null) {
      final diff = DateTime.now().difference(lastSyncTime);
      if (diff.inHours < 1) return;
    }

    final isOnline = await _checkConnectivity();
    if (!isOnline) return;

    try {
      final items = await _fetchFromFirestore(type);
      if (items.isNotEmpty) {
        await _replaceCache(type, items);
        await _setLastSync(type);
      }
    } catch (_) {}
  }

  Future<List<DailyQuranDuaModel>> _fetchFromFirestore(ContentType type) async {
    switch (type) {
      case ContentType.quranVerses:
        return _dataSource.getQuranVerses();
      case ContentType.dailyDuas:
        return _dataSource.getDailyDuas();
      case ContentType.hadiths:
        return _dataSource.getHadiths();
    }
  }

  Future<void> _replaceCache(
    ContentType type,
    List<DailyQuranDuaModel> items,
  ) async {
    switch (type) {
      case ContentType.quranVerses:
        return _cacheDao.replaceQuranVerses(items);
      case ContentType.dailyDuas:
        return _cacheDao.replaceDailyDuas(items);
      case ContentType.hadiths:
        return _cacheDao.replaceHadiths(items);
    }
  }

  String _getLastSyncKey(ContentType type) => 'last_sync_${type.name}';

  Future<void> _setLastSync(ContentType type) async {
    SharedPreferenceService.setLastSyncTime(
      _getLastSyncKey(type),
      DateTime.now(),
    );
  }

  Future<bool> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }
}
