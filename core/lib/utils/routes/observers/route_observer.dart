import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:core/utils/analytics/analytics.dart';
import 'package:flutter/material.dart';

class AppRouteObserver extends AutoRouteObserver {
  final _analytics = Analytics.instance;
  @override
  Future<void> didPush(Route route, Route? previousRoute) async {
    log('route pushed: ${route.settings.name}');
    await _analytics.logScreenView(screenName: route.settings.name);
  }

  @override
  Future<void> didInitTabRoute(
      TabPageRoute route, TabPageRoute? previousRoute) async {
    log('tab route visited: ${route.name}');
    await _analytics.logScreenView(screenName: route.name);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    log('tab route re-visited: ${route.name}');
    _analytics.logScreenView(screenName: route.name);
  }
}
