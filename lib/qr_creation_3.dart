import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'home_screen.dart';

class QrResultScreen extends StatelessWidget {
  final String url;
  final String title;
  final String? password;

  const QrResultScreen({
    super.key,
    required this.url,
    required this.title,
    this.password,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ URL, 제목, 비밀번호 포함한 QR 데이터 구성
    final qrData = '제목: $title\nURL: $url' +
        (password != null && password!.isNotEmpty ? '\n비밀번호: $password' : '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('QRust'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text('메뉴', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('홈으로'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('QR 코드 생성   step 3. QR 이미지 생성',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('3. QR 이미지 생성', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('생성된 QR 코드를 확인하세요! 저장하거나 공유도 가능합니다.'),
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('🚀 QR 코드를 생성하였습니다!',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    QrImageView(
                      data: qrData, // ✅ 수정된 부분
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text('다운로드'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          label: const Text('공유하기'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('홈으로', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

