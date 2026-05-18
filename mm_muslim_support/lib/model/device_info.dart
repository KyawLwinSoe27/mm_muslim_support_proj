class DeviceInfo {
  final String deviceId;
  final String? deviceModel;
  final String? deviceName;
  final String? platform;
  final String? osVersion;
  final String? appVersion;
  final String? fcmToken;
  final String? language;
  final String? timezone;

  const DeviceInfo({
    required this.deviceId,
    this.deviceModel,
    this.deviceName,
    this.platform,
    this.osVersion,
    this.appVersion,
    this.fcmToken,
    this.language,
    this.timezone,
  });

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'deviceModel': deviceModel,
    'deviceName': deviceName,
    'platform': platform,
    'osVersion': osVersion,
    'appVersion': appVersion,
    'fcmToken': fcmToken,
    'language': language,
    'timezone': timezone,
  };

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
    deviceId: json['deviceId'] as String,
    deviceModel: json['deviceModel'] as String?,
    deviceName: json['deviceName'] as String?,
    platform: json['platform'] as String?,
    osVersion: json['osVersion'] as String?,
    appVersion: json['appVersion'] as String?,
    fcmToken: json['fcmToken'] as String?,
    language: json['language'] as String?,
    timezone: json['timezone'] as String?,
  );
}
