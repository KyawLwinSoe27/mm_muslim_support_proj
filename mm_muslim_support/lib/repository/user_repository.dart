import 'package:mm_muslim_support/data/datasource/user_datasource.dart';
import 'package:mm_muslim_support/model/device_info.dart';

class UserRepository {
  final UserDataSource _dataSource = UserDataSource();

  Future<void> registerOrUpdateDevice(DeviceInfo info) async {
    final existing = await _dataSource.getByDeviceId(info.deviceId);
    if (existing != null) {
      await _dataSource.update(info);
    } else {
      await _dataSource.create(info);
    }
  }

  Future<void> updateFcmToken(String deviceId, String? token) async {
    await _dataSource.updateFcmToken(deviceId, token);
  }
}
