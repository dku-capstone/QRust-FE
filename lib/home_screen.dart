import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';
import 'report_form_screen.dart';
import 'qr_storage_screen.dart';
import 'qr_creation_1.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> _isPressedMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RichText(
                text: const TextSpan(
                  text: 'Welcome home, ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'QRust',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildMenuCard(
                    context,
                    key: 'scan',
                    icon: Icons.qr_code_scanner,
                    title: 'QR 코드 인식',
                    subtitle: 'QR code recognition',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QrScannerScreen(),
                        ),
                      );
                    },
                    height: 120,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    context,
                    key: 'generate',
                    icon: Icons.qr_code,
                    title: 'QR 코드 생성',
                    subtitle: 'QR code Generation',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QrTypeSelectionScreen(),
                        ),
                      );
                    },
                    height: 100,
                    color: Colors.grey.shade800,
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    context,
                    key: 'report',
                    icon: Icons.report,
                    title: '피싱 신고',
                    subtitle: 'Report Phishing',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportFormScreen(),
                        ),
                      );
                    },
                    height: 100,
                    color: Colors.grey.shade800,
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    context,
                    key: 'storage',
                    icon: Icons.save,
                    title: 'QR 코드 보관함',
                    subtitle: 'QR code storage',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QrStorageScreen()),
                      );
                    },
                    height: 100,
                    color: Colors.grey.shade800,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, {
        required String key,
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        required double height,
        required Color color,
      }) {
    final isPressed = _isPressedMap[key] ?? false;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressedMap[key] = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressedMap[key] = false;
        });
        onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressedMap[key] = false;
        });
      },
      child: AnimatedScale(
        scale: isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.white70)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Text('내비게이션', style: TextStyle(fontSize: 20)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('QR 인식'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScannerScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('피싱 신고'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportFormScreen())),
          ),
        ],
      ),
    );
  }
}
