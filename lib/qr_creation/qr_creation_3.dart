import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrust/widgets/upper_navbar.dart';
import 'package:qrust/home/home_screen.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Drawer(),
      body: SafeArea(
        child: Column(
          children: [
            NavigationAppBar(scaffoldKey: GlobalKey<ScaffoldState>()),
            const SizedBox(height: 20),

            // ✅ step 안내 문구 (좌측)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'QR 코드 생성 step3. QR 이미지 생성',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ✅ 중앙 정렬 성공 메시지
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Text(
                  'QR 코드를 생성하였습니다!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Text(
                  '안전한 QR 코드를 사용해 보세요.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ✅ 흰색 카드 안에 QR 코드 + 정보
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ QR 코드 (검정색)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child: QrImageView(
                          data: url,
                          version: QrVersions.auto,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green.withOpacity(0.8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ QR 정보 (내부 좌측 정렬)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("제목: $title", style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text("URL: $url", style: const TextStyle(fontSize: 16)),
                          if (password != null && password!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text("비밀번호: $password", style: const TextStyle(fontSize: 16)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ 다운로드 & 공유 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 다운로드 버튼
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: 다운로드 기능
                  },
                  icon: const Icon(Icons.download, color: Colors.green),
                  label: const Text(
                    '다운로드',
                    style: TextStyle(color: Colors.green),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 16),
                // 공유 버튼
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: 공유하기 기능
                  },
                  icon: const Icon(Icons.share, color: Colors.green),
                  label: const Text(
                    '공유하기',
                    style: TextStyle(color: Colors.green),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '홈으로 돌아가기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


