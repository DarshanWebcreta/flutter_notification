// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_demo/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

NotificationService notificationService = NotificationService();
bool _isContextSet = false;


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  notificationService.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  notificationService.requestNotificationPermission();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    notificationService.initialLocalNotification(); // Moved here

    notificationService.fireBaseInit();
    notificationService.tokenRefress();

    notificationService.gettoken().then((value) {
      print("Device_Token: $value");
    });

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    runApp(MyApp(initialMessage: initialMessage,));
  });
}

class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;
  const MyApp({super.key, this.initialMessage});
  @override
  _MyAppState createState()=>_MyAppState();
}
class _MyAppState extends State<MyApp>{
  @override
  void initState() {
    super.initState();
    if(widget.initialMessage !=null){
      Future.delayed(Duration.zero, () {
        if(_isContextSet)
          notificationService.handleNotification(widget.initialMessage!);

      });
    }


  }
  @override
  Widget build(BuildContext context) {
    notificationService.setBuildContext(context);
    _isContextSet = true;
    return MaterialApp(
      title: 'Flutter Notifications',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
      routes: {
        '/home': (context) => MyHomePage(),
        '/details': (context) => DetailScreen(payload:""),
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Notifications')),
      body: Center(
        child: Text(
          'Welcome to the app! Wait for a notification.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String payload;
  DetailScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: Text('Details for: $payload'),
      ),
    );
  }
}