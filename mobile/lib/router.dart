import 'package:go_router/go_router.dart';
import 'package:picmory/viewmodels/auth/signin/signin_viewmodel.dart';
import 'package:picmory/viewmodels/home/home_viewmodel.dart';
import 'package:picmory/viewmodels/memory/create/memory_create_viewmodel.dart';
import 'package:picmory/viewmodels/splash/splash_viewmodel.dart';
import 'package:picmory/views/auth/signin_view.dart';
import 'package:picmory/views/home/home_view.dart';
import 'package:picmory/views/memory/create/memory_create_view.dart';
import 'package:picmory/views/splash/splash_view.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    /**
     * 스플래시 스크린
     */
    GoRoute(
      path: '/splash',
      builder: (_, state) => ChangeNotifierProvider(
        create: (_) => SplashViewmodel(),
        child: const SplashView(),
      ),
    ),
    /**
     * 인증
     */
    GoRoute(
      path: '/auth/signin',
      builder: (_, state) => ChangeNotifierProvider(
        create: (_) => SigninViewmodel(),
        child: const SigninView(),
      ),
    ),
    /**
     * 홈
     */
    GoRoute(
      path: '/home',
      builder: (_, state) => ChangeNotifierProvider(
        create: (_) => HomeViewmodel(),
        child: const HomeView(),
      ),
    ),
    /**
     * memrory
     */
    GoRoute(
      path: '/memory/create',
      builder: (_, state) => ChangeNotifierProvider(
        create: (_) => MemoryCreateViewmodel(),
        child: const MemoryCreateView(),
      ),
    ),
  ],
);
