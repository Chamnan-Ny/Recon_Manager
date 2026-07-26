import 'package:flutter/material.dart';
import 'package:red_doc/theme/app_theme.dart';
import 'package:red_doc/ui/screens/auth/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RedDocApp());
}

class RedDocApp extends StatelessWidget {
  const RedDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RedDoc',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
