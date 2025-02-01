// notification_service.dart
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
// notification_service.dart
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String darwinNotificationCategoryPlain = 'plainCategory';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  BuildContext? _context;
  void setContext(BuildContext context){
    _context = context;
  }


  void initialLocalNotification() async {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
      AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings("@mipmap/ic_launcher");

      DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestCriticalPermission: true,
          requestSoundPermission: true);

      InitializationSettings initializationSettings = InitializationSettings(
          android: androidSettings, iOS: iosSettings);

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
    } else if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestCriticalPermission: true,
          requestSoundPermission: true);

      InitializationSettings initializationSettings =
      InitializationSettings(iOS: iosSettings);

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
  }

  void fireBaseInit() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Hello I am Firebase Message opened Event ");
      handleNotification(event);
    });

    FirebaseMessaging.onMessage.listen((message) {
      print("############# Notification_Event_Call ############### ${message.data}");
      print("title :${message.notification!.title}");
      print("Message_Body: ${message.notification!.body}");
      print("Message_data: ${message.data}");
      print("Message_category: ${message.category}");
      print("Message_sender_Id: ${message.senderId}");
      print("Message_type: ${message.messageType}");
      print("Message_id: ${message.messageId}");

      // Show local notification only if the app is in foreground
      if (message.notification != null) {
        showNotification(message);
      }
    });
  }


  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'high importance',
      importance: Importance.max,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound("msg"),
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "channel description",
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      sound: RawResourceAndroidNotificationSound("msg"),
      category: AndroidNotificationCategory.message,
      indeterminate: true,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
    );

    DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
        categoryIdentifier: darwinNotificationCategoryPlain,
        attachments: []);

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(
      Duration.zero,
          () {
        flutterLocalNotificationsPlugin.show(
            Random.secure().nextInt(10000),
            message.notification!.title,
            message.notification!.body,
            notificationDetails,
            payload:message.notification!.title!.contains("Call from")? "home":"details"); // Hardcoded payload here

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
        criticalAlert: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("grant permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("grant permission from provisional");
    } else {
      print("permission denined");
    }
  }

  Future<String> gettoken() async {
    String? token = "";
    if (Platform.isIOS) {
      print('FlutterFire Messaging Example: Getting APNs token...');

      token = await messaging.getAPNSToken();
      print('FlutterFire Messaging Example: Got APNs token: $token');
    } else {
      token = await messaging.getToken();
    }
    print(token);
    return token!;
  }

  void tokenRefress() {
    messaging.onTokenRefresh.listen((event) {
      print("token refress:${event}");
      SharedPreferences.getInstance().then((value) => value.setString('uid', event));
    });
  }


  void handleNotification(RemoteMessage message) async {
    if (_context == null) {
      return;
    }

    handleNavigation(_context!,message.notification!.title.toString()); // Hardcoded payload here

  }
  void handleNavigation(BuildContext context, String payload){
    if(payload == "details"){
      print("details screen call karse");

      //Navigator.pushNamed(context, '/details',arguments:  "This is from Notification Payload");
    }else{
      print("HomeScreen call karse");
    //   Navigator.pushNamed(context, '/home');
    }
  }

  void setBuildContext(BuildContext buildContext) {
    _context = buildContext;
  }
}
