import 'package:flutter/material.dart';
import 'package:qrust/widgets/upper_navbar.dart';
import 'package:qrust/qr_creation/qr_creation_2.dart'; // ← 실제 폴더명에 맞게 수정

class QrTypeSelectionScreen extends StatefulWidget {
  const QrTypeSelectionScreen({super.key});

  @override
  State<QrTypeSelectionScreen> createState() => _QrTypeSelectionScreenState();
}

class _QrTypeSelectionScreenState extends State<QrTypeSelectionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedType;

  final qrTypes = [
    {'type': 'website', 'label': '웹사이트', 'description': '웹사이트 URL 링크', 'icon': Icons.language},
    {'type': 'video', 'label': '비디오', 'description': '비디오 첨부', 'icon': Icons.video_library},
    {'type': 'image', 'label': '사진', 'description': '사진 첨부', 'icon': Icons.image},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: const Drawer(),
      body: SafeArea(
        child: Column(
          children: [
            NavigationAppBar(scaffoldKey: _scaffoldKey),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'QR 코드 생성 step1. QR 유형 선택',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'QR 코드 종류 선택',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '생성할 QR 코드의 종류를 선택해 주세요.',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: qrTypes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final typeInfo = qrTypes[index];
                  final isSelected = selectedType == typeInfo['type'];

                  return FractionallySizedBox(
                    widthFactor: 0.9,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = typeInfo['type'] as String;
                        });
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 104),
                        child: Card(
                          color: isSelected ? Colors.green.shade100 : null,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? Colors.green : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
                            child: Row(
                              children: [
                                Icon(
                                  typeInfo['icon'] as IconData,
                                  color: isSelected ? Colors.green : Colors.black,
                                  size: 28,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        typeInfo['label'] as String,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        typeInfo['description'] as String,
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle, color: Colors.green)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: selectedType == null
                        ? null
                        : () {
                      // ✅ 선택한 타입 넘기기 + 이동
                      final typeToSend = selectedType!;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrCreationStep2Screen(
                            selectedType: typeToSend,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      '다음',
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
