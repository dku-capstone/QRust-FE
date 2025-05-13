import 'package:flutter/material.dart';
import 'package:qrust/widgets/navigation_appbar.dart';
import 'package:qrust/widgets/drawer_menu.dart';
import 'package:qrust/widgets/lower_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2;

  late AnimationController _welcomeController;
  late AnimationController _nameController;
  late Animation<Offset> _welcomeOffset;
  late Animation<Offset> _nameOffset;
  late Animation<double> _welcomeOpacity;
  late Animation<double> _nameOpacity;

  final Map<String, double> _buttonScales = {
    'qr': 1.0,
    'qrscan': 1.0,
    'report': 1.0,
    'save': 1.0,
  };

  @override
  void initState() {
    super.initState();

    _welcomeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _nameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _welcomeOffset = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _welcomeController, curve: Curves.easeOut));

    _nameOffset = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _nameController, curve: Curves.easeOut));

    _welcomeOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _welcomeController, curve: Curves.easeOut),
    );

    _nameOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _nameController, curve: Curves.easeOut),
    );

    _welcomeController.forward();
    Future.delayed(const Duration(milliseconds: 500), () => _nameController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) => setState(() => _selectedIndex = index),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 8), // overflow 방지
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Qrust',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.person, size: 28, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SlideTransition(
                      position: _welcomeOffset,
                      child: FadeTransition(
                        opacity: _welcomeOpacity,
                        child: const Text(
                          '어서오세요,',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SlideTransition(
                      position: _nameOffset,
                      child: FadeTransition(
                        opacity: _nameOpacity,
                        child: const Text(
                          '경민 님',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '오늘도 안전한 인증을 위해 준비했어요!',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              NavigationAppBar(scaffoldKey: _scaffoldKey),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: GestureDetector(
                              onTapDown: (_) => setState(() => _buttonScales['qrscan'] = 0.95),
                              onTapUp: (_) => setState(() => _buttonScales['qrscan'] = 1.0),
                              onTapCancel: () => setState(() => _buttonScales['qrscan'] = 1.0),
                              child: AnimatedScale(
                                scale: _buttonScales['qrscan'] ?? 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: _buildScanCreateButton(
                                  label: 'QR 스캔하기',
                                  imagePath: 'assets/pictures/qr_scan.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: GestureDetector(
                              onTapDown: (_) => setState(() => _buttonScales['qr'] = 0.95),
                              onTapUp: (_) => setState(() => _buttonScales['qr'] = 1.0),
                              onTapCancel: () => setState(() => _buttonScales['qr'] = 1.0),
                              child: AnimatedScale(
                                scale: _buttonScales['qr'] ?? 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: _buildScanCreateButton(
                                  label: 'QR 생성하기',
                                  imagePath: 'assets/pictures/qr_code.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSimpleButton(
                            icon: Icons.report,
                            label: '피싱 신고',
                            onTap: () {},
                            keyId: 'report',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSimpleButton(
                            icon: Icons.save,
                            label: '보관함',
                            onTap: () {},
                            keyId: 'save',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanCreateButton({required String label, required String imagePath}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, // ← 줄였음
            height: 100,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required String keyId,
  }) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _buttonScales[keyId] = 0.95),
      onTapUp: (_) => setState(() => _buttonScales[keyId] = 1.0),
      onTapCancel: () => setState(() => _buttonScales[keyId] = 1.0),
      onTap: onTap,
      child: AnimatedScale(
        scale: _buttonScales[keyId] ?? 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
