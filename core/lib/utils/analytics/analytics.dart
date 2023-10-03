import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  static Analytics? _instance;

  Analytics._internal();

  factory Analytics() {
    if (_instance == null) {
      throw UnimplementedError('Analytics must be initialized first.');
    }

    return _instance!;
  }

  factory Analytics.initialize() {
    log('initialized.', name: 'Analytics');
    _instance ??= Analytics._internal();
    return _instance!;
  }

  static Analytics get instance => Analytics();

  Future<void> logScreenView({
    required String? screenName,
  }) {
    return _firebaseAnalytics.setCurrentScreen(
      screenName: screenName,
    );
  }

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? params,
  }) {
    return _firebaseAnalytics.logEvent(name: name, parameters: params);
  }
}
