import 'package:flutter/material.dart';

class ResetFlagObserver extends NavigatorObserver {
  static bool isTest1Processed = false;
  static bool isTest2Processed = false;
  static bool isTest3Processed = false;

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Check if the previous route is the main page
    if (previousRoute?.settings.name == '/mainPage') {
      resetProcessingFlags();
    }
  }

  static void resetProcessingFlags() {
    isTest1Processed = false;
    isTest2Processed = false;
    isTest3Processed = false;
    print("Processing flags reset.");
  }
}
