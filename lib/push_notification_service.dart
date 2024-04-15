import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static int i = 0;

  Future initialize() async {
    _fcm.subscribeToTopic('badge_testing');
    _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _fcm.setAutoInitEnabled(true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      i=0;
      FlutterAppBadger.removeBadge();
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    bool res = await FlutterAppBadger.isAppBadgeSupported();
    if (res) {
      FlutterAppBadger.updateBadgeCount(i++);
    }
  }
}
