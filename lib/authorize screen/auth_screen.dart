import 'package:flutter/material.dart';
import 'emailsignup_screen.dart'; // 파일 이름 수정됨
import 'login_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late AnimationController _text1Controller;
  late AnimationController _text2Controller;
  late AnimationController _logoController;
  late Animation<Offset> _text1Offset;
  late Animation<Offset> _text2Offset;
  late Animation<Offset> _logoOffset;

  @override
  void initState() {
    super.initState();

    _text1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _text2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _text1Offset = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _text1Controller, curve: Curves.easeOut),
    );
    _text2Offset = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _text2Controller, curve: Curves.easeOut),
    );
    _logoOffset = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _text1Controller.forward();
    Future.delayed(const Duration(seconds: 1), () => _text2Controller.forward());
    Future.delayed(const Duration(seconds: 2), () => _logoController.forward());
  }

  @override
  void dispose() {
    _text1Controller.dispose();
    _text2Controller.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 100.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SlideTransition(
                    position: _text1Offset,
                    child: FadeTransition(
                      opacity: _text1Controller,
                      child: const Text(
                        '간편한 인증,',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SlideTransition(
                    position: _text2Offset,
                    child: FadeTransition(
                      opacity: _text2Controller,
                      child: const Text(
                        '믿을 수 있는 연결.',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SlideTransition(
                    position: _logoOffset,
                    child: FadeTransition(
                      opacity: _logoController,
                      child: Image.asset(
                        'assets/logo/qrust_logo1.png',
                        width: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 24.0, bottom: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'SNS 계정으로 간편 가입하기',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedCircleButton(
                          icon: Icons.email,
                          backgroundColor: Colors.blueAccent,
                          size: 72,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EmailSignupScreen()),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        AnimatedCircleButton(
                          iconAsset: 'assets/api/kakao.png',
                          backgroundColor: const Color(0xFFFFE812),
                          size: 72,
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        AnimatedCircleButton(
                          iconAsset: 'assets/api/naver.png',
                          backgroundColor: const Color(0xFF03C75A),
                          size: 72,
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        AnimatedCircleButton(
                          iconAsset: 'assets/api/google.png',
                          backgroundColor: const Color(0xFFF5F5F5),
                          size: 72,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('이미 계정이 있으신가요?'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCircleButton extends StatefulWidget {
  final IconData? icon;
  final String? iconAsset;
  final Color backgroundColor;
  final VoidCallback onTap;
  final double size;

  const AnimatedCircleButton({
    this.icon,
    this.iconAsset,
    required this.backgroundColor,
    required this.onTap,
    this.size = 56,
    super.key,
  });

  @override
  State<AnimatedCircleButton> createState() => _AnimatedCircleButtonState();
}

class _AnimatedCircleButtonState extends State<AnimatedCircleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: CircleAvatar(
          radius: widget.size / 2,
          backgroundColor: widget.backgroundColor,
          child: widget.icon != null
              ? Icon(widget.icon, color: Colors.white, size: widget.size / 2)
              : ClipOval(
            child: Image.asset(
              widget.iconAsset!,
              width: widget.size * 0.65,
              height: widget.size * 0.65,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}