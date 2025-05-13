import 'package:flutter/material.dart';
import 'emailverification_screen.dart';
import 'package:qrust/api/signup_api.dart';

class EmailSignupScreen extends StatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late AnimationController _slide1Controller;
  late AnimationController _slide2Controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeLogo;
  late Animation<double> _fadeText1;
  late Animation<double> _fadeText2;
  late Animation<Offset> _slide1Animation;
  late Animation<Offset> _slide2Animation;

  @override
  void initState() {
    super.initState();

    _slide1Controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _slide2Controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _fadeLogo = CurvedAnimation(parent: _fadeController, curve: const Interval(0.0, 0.3));
    _fadeText1 = CurvedAnimation(parent: _fadeController, curve: const Interval(0.3, 0.6));
    _fadeText2 = CurvedAnimation(parent: _fadeController, curve: const Interval(0.6, 1.0));

    _slide1Animation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slide1Controller, curve: Curves.easeOut),
    );

    _slide2Animation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slide2Controller, curve: Curves.easeOut),
    );

    _slide1Controller.forward();
    Future.delayed(const Duration(milliseconds: 500), () => _slide2Controller.forward());
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose();
    _slide1Controller.dispose();
    _slide2Controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _fadeLogo,
                  child: Image.asset(
                    'assets/logo/qrust_logo.png',
                    height: 200,
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeText1,
                  child: SlideTransition(
                    position: _slide1Animation,
                    child: const Text(
                      '반가워요!',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FadeTransition(
                  opacity: _fadeText2,
                  child: SlideTransition(
                    position: _slide2Animation,
                    child: const Text(
                      '이메일로 계정을 생성할게요.',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  '아래에 이메일을 입력해 주세요.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: TextField(
                    controller: _emailController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(fontSize: 12),
                      hintText: 'example',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () {
                        final email = _emailController.text.trim();
                        if (email.isNotEmpty && email.contains('@')) {
                          SignupState.email = email;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmailVerificationPage(email: email),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("올바른 이메일을 입력해주세요.")),
                          );
                        }
                      },
                      child: const Text(
                        '다음으로',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NextSignupScreen extends StatelessWidget {
  const NextSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('비밀번호 입력 화면 등 다음 단계 구현')),
    );
  }
}
