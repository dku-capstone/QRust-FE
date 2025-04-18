import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'report_detail_screen.dart';

class ReportHistoryScreen extends StatelessWidget {
  const ReportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'QRust',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '신고 내역',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildReportCard(
                      context,
                      title: '악성 URL 신고',
                      url: 'https://example1.com',
                      status: '승인 대기중',
                      icon: Icons.hourglass_empty,
                      color: Colors.orange
                  ),
                  _buildReportCard(
                      context,
                      title: '악성 URL 신고',
                      url: 'https://example2.com',
                      status: '승인됨',
                      icon: Icons.check_circle,
                      color: Colors.green
                  ),
                  _buildReportCard(
                      context,
                      title: '악성 URL 신고',
                      url: 'https://example3.com',
                      status: '거부됨',
                      icon: Icons.cancel,
                      color: Colors.red
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('홈으로'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
      BuildContext context, {
        required String title,
        required String url,
        required String status,
        required IconData icon,
        required Color color,
      }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(url, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReportDetailScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('접수 내역 확인'),
                ),
                Row(
                  children: [
                    Icon(icon, color: color),
                    const SizedBox(width: 6),
                    Text(status, style: TextStyle(color: color)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}