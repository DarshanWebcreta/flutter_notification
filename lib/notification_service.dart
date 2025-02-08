// notification_service.dart

import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String darwinNotificationCategoryPlain = 'plainCategory';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> initialLocalNotification() async {
    // Request iOS permissions upfront
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    AndroidInitializationSettings androidSettings =
    const AndroidInitializationSettings("@mipmap/ic_launcher"); // Use const
    DarwinInitializationSettings iosSettings = const DarwinInitializationSettings( // Use const
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,

    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        if (_context != null) {
          handleNavigation(_context!, payload.payload.toString());
        } else {
          print("Context is Null");
        }
      },
    );
  }

  void fireBaseInit() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Hello I am Firebase Message opened Event ");
      handleNotification(event);
    });

    FirebaseMessaging.onMessage.listen((message) {
      print(
          "############# Notification_Event_Call ############### ${message.data}");
      print("title :${message.notification!.title}");
      print("Message_Body: ${message.notification!.body}");
      print("Message_data: ${message.data}");
      print("Message_category: ${message.category}");
      print("Message_sender_Id: ${message.senderId}");
      print("Message_type: ${message.messageType}");
      print("Message_id: ${message.messageId}");

      // Show local notification only if the app is in foreground
     // if (message.notification != null) {
        showNotification(message);
      //}
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    print("Bhai hu to aavuj chhuv ");
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'high importance',
      importance: Importance.max,
      enableVibration: true,
      sound: const RawResourceAndroidNotificationSound("msg"), // Use const
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "channel description",
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      sound: const RawResourceAndroidNotificationSound("msg"), // Use const
      category: AndroidNotificationCategory.message,
      indeterminate: true,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
    );

    DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails( categoryIdentifier: darwinNotificationCategoryPlain); // Use const

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(
      Duration.zero,
          () {
        try {
          print("About to show local notification");
          flutterLocalNotificationsPlugin.show(
              Random.secure().nextInt(10000),
              message.notification!.title ?? 'Default Title', // Provide a default
              message.notification!.body ?? 'Default Body', // Provide a default
              notificationDetails,
              payload: message.notification!.title!.contains("Call from")
                  ? "home"
                  : "details");
          print("Local notification shown (hopefully!)");
        } catch (e) {
          print("Error showing local notification: $e");
        }
      },
    );
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      provisional: true,
      sound: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("iOS: Granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("iOS: Granted provisional permission");
    } else {
      print(
          "iOS: Permission denied: ${settings.authorizationStatus}"); // Add this!
    }
  }

  Future<String> gettoken() async {
    String? token = "";
    if (Platform.isIOS) {
      print('FlutterFire Messaging Example: Getting APNs token...');
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      token = await messaging.getToken();
      print('FlutterFire Messaging Example: Got APNs token: $token');
    } else {
      token = await messaging.getToken();
    }
    print(token);
    return token ?? '';
  }

  void tokenRefress() {
    messaging.onTokenRefresh.listen((event) {
      print("token refress:${event}");
      SharedPreferences.getInstance()
          .then((value) => value.setString('uid', event));
    });
  }

  void handleNotification(RemoteMessage message) async {
    if (_context == null) {
      return;
    }

    handleNavigation(
        _context!, message.notification!.title.toString()); // Hardcoded payload here
  }

  void handleNavigation(BuildContext context, String payload) {
    if (payload == "details") {
      print("details screen call karse");

      //Navigator.pushNamed(context, '/details',arguments:  "This is from Notification Payload");
    } else {
      print("HomeScreen call karse");
      //   Navigator.pushNamed(context, '/home');
    }
  }

  void setBuildContext(BuildContext buildContext) {
    _context = buildContext;
  }
}