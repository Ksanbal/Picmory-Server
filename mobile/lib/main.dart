import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/firebase_options.dart';
import 'package:picmory/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // .env
  await dotenv.load(fileName: ".env");

  // Supabase
  await Supabase.initialize(
    url: dotenv.get("SUPABASE_URL"),
    anonKey: dotenv.get("SUPABASE_KEY"),
  );

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await remoteConfig.fetchAndActivate();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  // FCM 설정
  settingFCM();

  // local notification 설정
  settingLocalNotification();

  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

final remoteConfig = FirebaseRemoteConfig.instance;
final analytics = FirebaseAnalytics.instance;
final messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'SUITE-Variable',
        primaryColor: ColorFamily.primary,
        primaryColorDark: ColorFamily.primaryDark,
        primaryColorLight: ColorFamily.primaryLight,
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: ColorFamily.backgroundGrey200,
          errorColor: ColorFamily.error,
        ),
        // splashColor: Colors.red,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            foregroundColor: ColorFamily.disabledGrey500,
          ),
        ),
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

// FCM 설정
settingFCM() async {
  // 권한 요청
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');
    log('Message id: ${message.messageId}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
      _localNotification.show(
        int.parse((message.messageId ?? "1").substring(10)),
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          android: AndroidNotificationDetails(
            message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
            message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  // Background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  log('fcmToken: $fcmToken');
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  log("Handling a background message: ${message.messageId}");
}

// local notification
void settingLocalNotification() async {
  AndroidInitializationSettings android =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings ios = const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  InitializationSettings settings = InitializationSettings(android: android, iOS: ios);
  await _localNotification.initialize(settings);
}
