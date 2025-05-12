import 'package:share_plus/share_plus.dart';

class AppShareHelper {
  static void shareApp({String? message}) {
    final defaultMessage =
        'Check out this amazing app! 🔗\nhttps://yourappstore.link';
    SharePlus.instance.share(
      ShareParams(
        text: message ?? defaultMessage,
        subject: 'Check out this amazing app!',
      ),
    );
  }
}
