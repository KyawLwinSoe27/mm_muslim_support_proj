import 'package:flutter/widgets.dart';
import 'package:mm_muslim_support/service/analytics_service.dart';

mixin AnalyticsMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logScreenView();
    });
  }

  String get screenName;

  Future<void> _logScreenView() async {
    await AnalyticsService().logScreenView(screenName: screenName);
  }

  Future<void> trackButtonTap(String buttonName, {Map<String, Object>? params}) async {
    await AnalyticsService().logButtonTap(
      buttonName: buttonName,
      screenName: screenName,
      additionalParams: params,
    );
  }

  Future<void> trackFeatureUsed(String featureName, {Map<String, Object>? params}) async {
    await AnalyticsService().logFeatureUsed(
      featureName: featureName,
      screenName: screenName,
      additionalParams: params,
    );
  }
}
