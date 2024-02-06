import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForYouViewmodel extends ChangeNotifier {
  routeToMenu(BuildContext context) {
    context.push('/menu');
  }
}
