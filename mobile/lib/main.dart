import 'dart:developer';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/firebase_options.dart';
import 'package:picmory/models/api/auth/access_token_model.dart';
import 'package:picmory/router.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // .env
  await dotenv.load(fileName: ".env");

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

final remoteConfig = FirebaseRemoteConfig.instance;
final analytics = FirebaseAnalytics.instance;
final messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

// 이벤트 버스
final EventBus eventBus = EventBus();

// 로그인 후 얻는 accessToken
AccessTokenModel? globalAccessToken;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: ColorsToken.neutral[50],
        fontFamily: 'SUITE-Variable',
        primaryColor: ColorsToken.primary,
        // primaryColorDark: ColorsToken.primaryDark,
        // primaryColorLight: ColorsToken.primaryLight,
        colorScheme: ColorScheme.fromSwatch(
          // backgroundColor: ColorFamily.backgroundGrey200,
          errorColor: ColorsToken.warning,
        ),
        // splashColor: Colors.red,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            // foregroundColor: ColorFamily.disabledGrey500,
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

  try {
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
  } catch (error) {
    log('error: $error');
  }
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
