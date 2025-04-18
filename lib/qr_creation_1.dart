import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'qr_creation_2.dart';

class QrTypeSelectionScreen extends StatefulWidget {
  const QrTypeSelectionScreen({super.key});

  @override
  State<QrTypeSelectionScreen> createState() => _QrTypeSelectionScreenState();
}

class _QrTypeSelectionScreenState extends State<QrTypeSelectionScreen> {
  String? selectedType;

  final qrTypes = [
    {'type': 'website', 'label': '웹사이트', 'description': '웹사이트 URL 링크', 'icon': Icons.language},
    {'type': 'video', 'label': '비디오', 'description': '비디오 첨부', 'icon': Icons.video_library},
    {'type': 'image', 'label': '사진', 'description': '사진 첨부', 'icon': Icons.image},
  ];

  @override
  Widget build(BuildContext context) {
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
            const Text('QR 코드 생성   step 1. QR 유형 선택',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('1. QR코드 유형 선택', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('버튼을 선택하여 QR 유형을 선택해주세요.'),
            const SizedBox(height: 16),

            // 카드 리스트
            ...qrTypes.map((qrType) {
              final type = qrType['type'] as String;
              final isSelected = selectedType == type;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedType = type;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange[100] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.orange : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: const Color(0xFFFB8C00).withAlpha(76),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Icon(qrType['icon'] as IconData,
                          size: 32, color: isSelected ? Colors.orange : Colors.black54),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(qrType['label'] as String,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.orange[800] : Colors.black)),
                          Text(qrType['description'] as String),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),

            // 다음 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedType == null ? Colors.grey : Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: selectedType == null
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QrCreationStep2Screen(selectedType: selectedType!),
                    ),
                  );
                },
                child: const Text('다음 →', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
