import 'package:flutter/material.dart';
import 'authorize screen/auth_screen.dart';
import 'authorize screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRust',
      theme: ThemeData(
        useMaterial3: true, // Material 3 스타일
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // 앱 시작 시 SplashScreen 먼저 실행
    );
  }
}


