import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:img_classifier/services/services.dart';
import 'package:img_classifier/routes/app_routes.dart';
import 'package:img_classifier/themes/app_theme.dart';

void main() => runApp(AppState());

class ImgClassifierApp extends StatelessWidget {
  ImgClassifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Img Classifier',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: AppTheme.lightTheme,
    );
  }
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserService(),
        )
      ],
      child: ImgClassifierApp(),
    );
  }
}
