import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home_screen.dart';
import 'qr_result_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool showTestButtons = false;

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 불러왔습니다')),
      );
    }
  }

  void _showBlacklistDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('블랙리스트 경고'),
        content: const Text('이 사이트는 블랙리스트에 등록되어 있습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'QR 코드 인식',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.qr_code_2, size: 100, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'QR 코드를 아래의 화면에 맞춰주세요',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _pickImageFromGallery(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  elevation: 4,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('사진에서 불러오기'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  elevation: 4,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('홈으로'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showTestButtons = !showTestButtons;
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  elevation: 3,
                  minimumSize: const Size.fromHeight(45),
                ),
                child: Text(showTestButtons ? '테스트 목록 닫기' : '테스트용 시나리오 열기'),
              ),
              if (showTestButtons) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrResultScreen(
                          url: 'https://dangerous.com',
                          riskType: QrRiskType.danger,
                        ),
                      ),
                    );
                  },
                  child: const Text('AI 판단: 위험'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrResultScreen(
                          url: 'https://safe.com',
                          riskType: QrRiskType.safe,
                        ),
                      ),
                    );
                  },
                  child: const Text('AI 판단: 안전'),
                ),
                ElevatedButton(
                  onPressed: _showBlacklistDialog,
                  child: const Text('블랙리스트'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrResultScreen(
                          url: 'https://reported.com',
                          riskType: QrRiskType.reported,
                          reportCount: 3,
                        ),
                      ),
                    );
                  },
                  child: const Text('사용자 신고'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('신뢰된 QR → 실제 접속 처리')),
                    );
                  },
                  child: const Text('신뢰된 QR'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}