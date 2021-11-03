import 'dart:async';
import 'dart:convert';

import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/repository/fcm.repository.dart';
import 'package:arungi_rasa/repository/notification_repository.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

const _fcmChannel = AndroidNotificationChannel(
  'fcm_channel', // id
  'FCM Channel', // title
  description: 'This channel is used for fcm notifications.', // description
  importance: Importance.max,
);

const _initializationSettingsAndroidNotification =
    AndroidInitializationSettings('splash');

const _initializationSettingsIOSNotification = IOSInitializationSettings();
const _initializationSettingsMacOSNotificaiton = MacOSInitializationSettings();

const _initializationSettingsNotification = InitializationSettings(
  android: _initializationSettingsAndroidNotification,
  iOS: _initializationSettingsIOSNotification,
  macOS: _initializationSettingsMacOSNotificaiton,
);

class NotificationService extends GetxService {
  static NotificationService get instance => Get.find<NotificationService>();

  final unreadCount = RxInt(0);
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, _setupNotification);
  }

  void _setupNotification() async {
    await flutterLocalNotificationsPlugin.initialize(
      _initializationSettingsNotification,
      onSelectNotification: onSelectNotification,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_fcmChannel);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      refreshUnreadCount();
      final notification = message.notification;
      final android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _fcmChannel.id,
              _fcmChannel.name,
              channelDescription: _fcmChannel.description,
            ),
          ),
          payload: json.encode(message.data),
        );
      }
    });
  }

  Future<void> onSelectNotification(final String? raw) async {
    if (raw == null) return;
    try {
      final data = json.decode(raw) as Map<String, dynamic>;
      if (!data.containsKey("type")) return;
      final type = data["type"];
      switch (type) {
        case "order:status:change":
          if (!data.containsKey("id")) break;
          Routes.openOrder(data["id"]);
          break;
      }
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  Future<void> refreshUnreadCount([final int? value]) async {
    if (value != null) {
      unreadCount.value = value;
      return;
    }
    try {
      final result = await NotificationRepository.instance.getUnreadCount();
      unreadCount.value = result.count ?? 0;
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  Future<void> registerNotification() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      FirebaseMessaging.instance.onTokenRefresh
          .listen(FcmRepository.instance.register);
      return;
    }
    await FcmRepository.instance.register(token);
    FirebaseMessaging.instance.onTokenRefresh
        .listen(FcmRepository.instance.register);
  }
}
