import 'package:flutter/material.dart';
import 'package:qrust/home/home_screen.dart';
import 'package:qrust/authorize screen/emailsignup_screen.dart';
import 'package:qrust/api/login_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _logoController;
  late AnimationController _text1Controller;
  late AnimationController _text2Controller;
  late Animation<Offset> _text1Offset;
  late Animation<Offset> _text2Offset;
  late Animation<double> _logoOpacity;
  late Animation<double> _text1Opacity;
  late Animation<double> _text2Opacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _text1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _text2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _text1Offset = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _text1Controller, curve: Curves.easeOut),
    );
    _text2Offset = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _text2Controller, curve: Curves.easeOut),
    );
    _text1Opacity = Tween<double>(begin: 0, end: 1).animate(_text1Controller);
    _text2Opacity = Tween<double>(begin: 0, end: 1).animate(_text2Controller);

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 300), () => _text1Controller.forward());
    Future.delayed(const Duration(milliseconds: 1000), () => _text2Controller.forward());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _logoController.dispose();
    _text1Controller.dispose();
    _text2Controller.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const green = Colors.green;
    const greyText = TextStyle(color: Colors.grey, fontSize: 14);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _logoOpacity,
                  child: Center(
                    child: Image.asset('assets/logo/qrust_logo.png', width: 200),
                  ),
                ),
                const SizedBox(height: 32),
                SlideTransition(
                  position: _text1Offset,
                  child: FadeTransition(
                    opacity: _text1Opacity,
                    child: const Text(
                      '다시 만나서 반가워요!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SlideTransition(
                  position: _text2Offset,
                  child: FadeTransition(
                    opacity: _text2Opacity,
                    child: const Text('당신의 계정으로 로그인하세요.', style: greyText),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    floatingLabelStyle: const TextStyle(color: green),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: green),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    floatingLabelStyle: const TextStyle(color: green),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: green),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      // 로그인 로직
                      final email = _emailController.text.trim();
                      final password = _passwordController.text;
                      
                      if (email.isEmpty || password.isEmpty) {
                        _showSnackbar("이메일과 비밀번호를 모두 입력해 주세요.");
                        return;
                      }
                      
                      final success = await LoginApi.login(email: email, password: password);
                      
                      if (success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      } else {
                        _showSnackbar("로그인 실패. 이메일이나 비밀번호를 확인해 주세요.");
                      }
                    },
                    child: const Text(
                      '로그인',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Center(child: Text('SNS로 간편 로그인', style: greyText)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialCircle('assets/api/kakao.png', const Color(0xFFFFE812),
                            () => _showSnackbar("카카오 로그인")),
                    const SizedBox(width: 16),
                    _buildSocialCircle('assets/api/naver.png', const Color(0xFF03C75A),
                            () => _showSnackbar("네이버 로그인")),
                    const SizedBox(width: 16),
                    _buildSocialCircle('assets/api/google.png', const Color(0xFFF5F5F5),
                            () => _showSnackbar("구글 로그인")),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('계정이 없으신가요? ', style: greyText),
                      GestureDetector(
                        onTap: () {
                          // 계정 생성 화면으로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => EmailSignupScreen()),
                          );
                        },
                        child: const Text(
                          '계정 생성하기',
                          style: TextStyle(color: green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialCircle(String assetPath, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 28,
        backgroundColor: bgColor,
        child: ClipOval(
          child: Image.asset(assetPath, width: 32, height: 32, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

