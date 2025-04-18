import 'package:flutter/material.dart';
import 'auth_screen.dart'; // 우리가 만든 로그인 페이지

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthScreen(), // 로그인 화면을 앱 시작화면으로!
    );
  }
}

