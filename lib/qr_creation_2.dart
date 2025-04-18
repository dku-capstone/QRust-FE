import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'qr_creation_1.dart';
import 'qr_creation_3.dart'; // ✅ 결과 화면으로 이동하기 위해 추가

class QrCreationStep2Screen extends StatefulWidget {
  final String selectedType;
  const QrCreationStep2Screen({super.key, required this.selectedType});

  @override
  State<QrCreationStep2Screen> createState() => _QrCreationStep2ScreenState();
}

class _QrCreationStep2ScreenState extends State<QrCreationStep2Screen> {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool enablePassword = false;

  bool get _canProceed {
    return urlController.text.trim().isNotEmpty &&
        titleController.text.trim().isNotEmpty;
  }

  void _validateAndProceed() {
    if (_canProceed) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QrResultScreen(
            url: urlController.text.trim(),
            title: titleController.text.trim(),
            password: enablePassword ? passwordController.text.trim() : null,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 항목을 모두 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        title: const Text('QRust'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('QR 코드 생성   step 2. QR 정보 입력',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('2. QR 정보 입력', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildInputCard(
              title: '웹사이트 URL 주소 *',
              description: 'QR에 삽입할 URL을 입력해주세요.',
              hint: '예: https://jhiob.tistory.com/',
              controller: urlController,
            ),

            _buildInputCard(
              title: 'QR 코드 이름 *',
              description: 'QR 코드의 이름을 지정해주세요.',
              hint: '예: QRust QR Code',
              controller: titleController,
            ),

            Row(
              children: [
                Checkbox(
                  value: enablePassword,
                  onChanged: (val) => setState(() => enablePassword = val!),
                ),
                const Text('QR 코드에 비밀번호를 생성하시겠습니까?'),
              ],
            ),
            if (enablePassword)
              _buildInputCard(
                title: '비밀번호',
                description: 'QR 코드의 비밀번호를 부여하려면 입력해주세요.',
                hint: 'password',
                controller: passwordController,
              ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('이전'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const QrTypeSelectionScreen()),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: _validateAndProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('다음 →', style: TextStyle(color: Colors.white)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required String description,
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
          )
        ],
      ),
    );
  }
}