import 'package:go_router/go_router.dart';
import 'package:picmory/screens/home/home.dart';

import 'package:picmory/screens/signin/signin.dart';
import 'package:picmory/services/auth_service.dart';
import 'package:picmory/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/signin',
  routes: [
    // 로그인
    GoRoute(
      path: '/signin',
      builder: (_, state) => ChangeNotifierProvider(
        create: (_) => AuthViewModel(
          authService: AuthService(),
        ),
        child: const SigninScreen(),
      ),
    ),
    // 홈
    GoRoute(
      path: '/home',
      builder: (_, state) => const HomeScreen(),
    ),
  ],
);
