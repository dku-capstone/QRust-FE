import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qrust/report/report_history_screen.dart';

class ReportSuccessScreen extends StatefulWidget {
  const ReportSuccessScreen({Key? key}) : super(key: key);

  @override
  State<ReportSuccessScreen> createState() => _ReportSuccessScreenState();
}

class _ReportSuccessScreenState extends State<ReportSuccessScreen>
    with SingleTickerProviderStateMixin {
  double _buttonScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/animations/check.json',
                        width: 160,
                        height: 160,
                        repeat: false,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '신고가 완료되었습니다!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '제보해주셔서 감사합니다. 사용자들의 안전한 인터넷 사용을 위해 소중히 활용하겠습니다.',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1AD282), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.black.withOpacity(0.2),
                    elevation: 4,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReportHistoryScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '접수 내역 확인',
                    style: TextStyle(fontSize: 16, color: Color(0xFF1AD282)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTapDown: (_) => setState(() => _buttonScale = 0.95),
                onTapUp: (_) => setState(() => _buttonScale = 1.0),
                onTapCancel: () => setState(() => _buttonScale = 1.0),
                child: AnimatedScale(
                  scale: _buttonScale,
                  duration: const Duration(milliseconds: 100),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1AD282),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home/home_screen.dart',
                              (route) => false,
                        );
                      },
                      child: const Text(
                        '홈으로',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

