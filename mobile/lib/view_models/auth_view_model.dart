import 'package:flutter/foundation.dart';

import 'package:picmory/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthService authService = AuthService();

  AuthViewModel({
    required this.authService,
  });

  signinWithGoogle() async {
    return await authService.signinWithGoogle();
  }
}
