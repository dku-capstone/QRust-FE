import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'report_form_screen.dart';

enum QrRiskType { danger, safe, reported }

class QrResultScreen extends StatelessWidget {
  final String url;
  final QrRiskType riskType;
  final int? reportCount;

  const QrResultScreen({
    super.key,
    required this.url,
    required this.riskType,
    this.reportCount,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color backgroundColor;
    String message;
    Icon emoji;

    switch (riskType) {
      case QrRiskType.danger:
        borderColor = Colors.red;
        backgroundColor = Colors.red.shade50;
        message = '⚠️ 위험: AI 확인 결과 위험한 페이지입니다.';
        emoji = const Icon(Icons.warning_amber, color: Colors.red);
        break;
      case QrRiskType.safe:
        borderColor = Colors.green;
        backgroundColor = Colors.green.shade50;
        message = '✅ 안전: AI 확인 결과 안전한 페이지입니다.';
        emoji = const Icon(Icons.check_circle, color: Colors.green);
        break;
      case QrRiskType.reported:
        borderColor = Colors.amber.shade800;
        backgroundColor = Colors.amber.shade100;
        message = '🚨 주의: 사용자 신고된 URL입니다.\n(예: 신고 ${reportCount ?? 0}회)';
        emoji = const Icon(Icons.report_problem, color: Colors.orange);
        break;
    }

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'QRust',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'QR 코드 분석 결과',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: url,
              decoration: const InputDecoration(
                labelText: 'URL',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  emoji,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('접속하기'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportFormScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('신고하기'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('뒤로'),
            ),
          ],
        ),
      ),
    );
  }
}
