import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Messagingservices {
  static const String _url =
      'https://fcm-backend-production-d47e.up.railway.app/send-notification';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1. Request Permission FIRST
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    // 3. Initialize Local Notifications & Listeners (don't block on token)
    await initLocalNotification();
    _setupForegroundListener();

    // 4. Listen to Token Refresh
    _listenToTokenRefresh();
  }

  void _setupForegroundListener() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("Foreground message received: ${message.notification?.title}");

      // ✅ To only show notifications in background, we DON'T call showNotification here.
      // The OS will automatically show the notification when the app is closed/backgrounded
      // if the FCM payload includes a 'notification' object.

      /* 
      if (message.notification != null || message.data.isNotEmpty) {
        showNotification(message);
      }
      */
    });
  }

  void _listenToTokenRefresh() {
    firebaseMessaging.onTokenRefresh.listen((newToken) async {
      debugPrint("FCM Token Refreshed: $newToken");
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        try {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.uid)
              .update({'token': newToken});
          debugPrint("Firestore updated with refreshed token");
        } catch (e) {
          debugPrint("Error updating refreshed token in Firestore: $e");
        }
      }
    });
  }

  Future<String?> getToken() async {
    String? token;
    try {
      if (Platform.isAndroid) {
        token = await firebaseMessaging.getToken();
      } else if (Platform.isIOS) {
        // iOS requires APNS token before FCM token.
        // Sometimes it takes a few seconds to register.
        String? apnsToken = await firebaseMessaging.getAPNSToken();

        // Retry logic for APNS token if it's not ready
        int retryCount = 0;
        while (apnsToken == null && retryCount < 3) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await firebaseMessaging.getAPNSToken();
          retryCount++;
        }

        if (apnsToken != null) {
          token = await firebaseMessaging.getToken();
        } else {
          // Check if we are on a simulator (APNS doesn't work on simulators)
          debugPrint('-------------------------------------------------------');
          debugPrint('CRITICAL: APNS token is NULL.');
          debugPrint(
            'If you are on a SIMULATOR, Push Notifications will NOT work.',
          );
          debugPrint('Please test on a PHYSICAL iOS device for APNS/FCM.');
          debugPrint('-------------------------------------------------------');
        }
      }

      if (token != null) {
        debugPrint("Firebase Token: $token");
      }
      return token;
    } catch (e) {
      debugPrint("Error fetching token: $e");
      return null;
    }
  }

  Future<void> initLocalNotification() async {
    const androidlocalNotificationSetting = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosLocalNotificationSetting = DarwinInitializationSettings();
    const initializationSetting = InitializationSettings(
      iOS: iosLocalNotificationSetting,
      android: androidlocalNotificationSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSetting,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: 'Used for important notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Null-safe extraction for both notification and data payloads
    String? title = message.notification?.title ?? message.data['title'];
    String? body = message.notification?.body ?? message.data['body'];

    if (title != null || body != null) {
      await _flutterLocalNotificationsPlugin.show(
        id: 0,
        title: title ?? "Flare Update",
        body: body ?? "New message received",
        notificationDetails: notificationDetails,
      );
    }
  }

  Future<bool> sendNotification({
    required String chatId,
    required String receiverId,
    required String message,
    required String senderName,
    required String receiverToken,
  }) async {
    if (chatId.isEmpty &&
        receiverId.isEmpty &&
        senderName.isEmpty &&
        message.isEmpty &&
        receiverToken.isEmpty) {
      return false;
    } else {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': receiverToken,
          'title': senderName,
          'body': message,
          'data': {
            'chatId': chatId,
            'senderId': receiverId,
            'type': 'chat_message',
          },
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Message Failed ${response.body}');
        return false;
      }
    }
  }
}
