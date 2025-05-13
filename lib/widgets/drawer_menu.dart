import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String selectedItem = '홈';

  Widget _sectionItem(String title, IconData icon) {
    final bool isSelected = selectedItem == title;
    return Column(
      children: [
        Container(
          color: isSelected ? Colors.green : const Color(0xFFF3F3F3),
          child: ListTile(
            leading: Icon(icon, color: isSelected ? Colors.white : Colors.black),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              setState(() {
                selectedItem = title;
              });
              // 페이지 이동 또는 기능 구현
            },
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.white),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/logo/qrust_logo1.png',
                    width: 160,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'user@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Icon(Icons.settings),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("내비게이션", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _sectionItem("홈", Icons.home),
                _sectionItem("QR 스캔", Icons.qr_code_scanner),
                _sectionItem("QR 생성", Icons.qr_code),
                _sectionItem("피싱 신고", Icons.warning_amber_rounded),
                _sectionItem("QR 보관함", Icons.save_alt),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("프로필", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                _sectionItem("프로필", Icons.person),
                _sectionItem("환경설정", Icons.settings),
              ],
            ),
          ),
        ],
      ),
    );
  }
}