import 'package:flutter/material.dart';
import 'passwordinput_screen.dart'; // 실제 경로에 맞게 수정

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());

  bool get _isCodeComplete =>
      _controllers.every((controller) => controller.text.trim().isNotEmpty);

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.length == 1 && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _verifyCode() {
    final code = _controllers.map((c) => c.text).join();
    // TODO 실제 코드 인증 로직이 여기에 들어갑니다.
    // TODO 인증 성공 시 다음 화면으로 이동:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordInputPage(), // <- const 제거
      ),
    );
  }

  Widget _buildCodeInputField(int index) {
    final hasInput = _controllers[index].text.trim().isNotEmpty;
    return SizedBox(
      width: 75,
      height: 90,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        onChanged: (value) => _onCodeChanged(index, value),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.grey[300],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: hasInput ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
      ),
    );
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                '인증 코드',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text(
                    '이메일에 발송된 인증 코드를 입력해 주세요.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 120),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                List.generate(4, (index) => _buildCodeInputField(index)),
              ),
              const SizedBox(height: 40),
              const Text(
                '인증 코드를 받지 못하셨나요?',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  // 코드 재전송 로직
                },
                child: const Text(
                  '재전송하기',
                  style: TextStyle(
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isCodeComplete ? _verifyCode : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      '코드 인증하기',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}