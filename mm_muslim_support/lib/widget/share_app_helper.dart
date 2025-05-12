import 'package:mm_muslim_support/utility/constants.dart';
import 'package:share_plus/share_plus.dart';

class AppShareHelper {
  static void shareApp({String? message}) {
    final defaultMessage =
        '🕌 Check out ${AppConstants.appName}!\n\nYour daily Islamic companion for prayer times, Quran, Qibla direction, and more.\n\nDownload now: ${AppConstants.appLink}';
    SharePlus.instance.share(
      ShareParams(
        text: message ?? defaultMessage,
        subject: 'Download ${AppConstants.appName} App',
      ),
    );
  }
}
