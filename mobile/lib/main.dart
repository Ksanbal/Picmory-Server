import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:picmory/common/families/color_family.dart';
import 'package:picmory/firebase_options.dart';
import 'package:picmory/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

final remoteConfig = FirebaseRemoteConfig.instance;

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
