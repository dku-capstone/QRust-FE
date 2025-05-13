import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qrust/home/home_screen.dart'; // 실제 경로에 맞게 수정하세요

class SignupSuccessScreen extends StatelessWidget {
  const SignupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Lottie 애니메이션 (로딩 후 재생)
                FutureBuilder(
                  future: Future.delayed(const Duration(milliseconds: 100)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Lottie.asset(
                        'assets/animations/check.json',
                        width: 140,
                        repeat: false,
                      );
                    }
                    return const SizedBox(height: 140);
                  },
                ),
                const SizedBox(height: 24),

                // 제목
                const Text(
                  "가입 완료!",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                // 설명
                const Text(
                  "지금부터 서비스를 자유롭게 이용하실 수 있어요.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // 홈으로 이동 버튼
                IntrinsicWidth(
                  child: SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false, // 뒤로가기 막고 홈으로 완전히 이동
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "홈으로",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

