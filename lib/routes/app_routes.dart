import 'package:flutter/material.dart';
import 'package:img_classifier/pages/pages.dart';

class AppRoutes {
  static const initialRoute = 'login';

  static Map<String, Widget Function(BuildContext)> routes = {
    'inicio': (_) => HomePage(),
    'login': (_) => LoginPage(),
    'registro': (_) => RegisterPage(),
  };
}
