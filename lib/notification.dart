import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pushy/tiga.dart';
import 'status.dart'; // Import the StatusPage
import 'cubaan.dart'; // Import the CubaanPage
import 'resetflag.dart'; // Import ResetFlagObserver

class Result {
  final Notification notification;

  Result(this.notification);
}

class Notification {
  final String title;

  Notification(this.title);
}

class NotificationHandler {
  static final Queue<Result> _notificationQueue = Queue<Result>();
  static bool _isProcessing = false;
  static bool isTest1Processed = false;
  static bool isTest2Processed = false;
  static bool isTest3Processed = false;

  static void initialize(BuildContext context) {
    OneSignal.Notifications.addClickListener((result) {
      debugPrint("Notification Clicked: ${result.notification?.title}");
      print("______________________________________________");
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      enqueueNotification(
        Result(Notification(result.notification?.title ?? '')),
        context,
      );
    });
  }

  static void enqueueNotification(Result result, BuildContext context) {
    _notificationQueue.add(result);
    _processNextNotification(context);
  }

  static void _processNextNotification(BuildContext context) {
    if (_isProcessing || _notificationQueue.isEmpty) return;

    _isProcessing = true;
    final Result result = _notificationQueue.removeFirst();

    final String title = result.notification.title;

    if (title == 'test1' && !_processNotification(isTest1Processed, () => isTest1Processed = true)) {
      navigateTo(context, const StatusPage(), "Status Page");
    } else if (title == 'test2' && !_processNotification(isTest2Processed, () => isTest2Processed = true)) {
      navigateTo(context, const Cubapage(), "Cubaan Page");
    } else if (title == 'test3' && !_processNotification(isTest3Processed, () => isTest3Processed = true)) {
      navigateTo(context, const tiga(), "Tiga Page");
    } else {
      debugPrint("No matching title or already processed: $title");
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _isProcessing = false;
      _processNextNotification(context);
    });
  }

  static bool _processNotification(bool isProcessed, VoidCallback markProcessed) {
    if (!isProcessed) {
      markProcessed();
      return false;
    }
    debugPrint("Notification already processed.");
    return true;
  }

  static void resetProcessingFlags() {
    isTest1Processed = false;
    isTest2Processed = false;
    isTest3Processed = false;
    debugPrint("Processing flags reset.");
  }

  static void navigateTo(BuildContext context, Widget page, String pageName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
    debugPrint("Navigated to $pageName");
  }
}
