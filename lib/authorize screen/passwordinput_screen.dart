import 'package:flutter/material.dart';
import 'profilesetup_screen.dart';
import 'package:qrust/api/signup_api.dart';

class PasswordInputPage extends StatefulWidget {
  const PasswordInputPage({super.key});

  @override
  State<PasswordInputPage> createState() => _PasswordInputPageState();
}

class _PasswordInputPageState extends State<PasswordInputPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmFocusNode = FocusNode();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _showPasswordRule = false;

  bool _passwordsMatch() =>
      _confirmController.text == _passwordController.text;

  bool _isPasswordValid(String password) {
    final lengthValid = password.length >= 8;
    final specialCharValid = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
    return lengthValid && specialCharValid;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordText = _passwordController.text;
    final confirmText = _confirmController.text;

    final passwordFilled = passwordText.isNotEmpty;
    final confirmFilled = confirmText.isNotEmpty;
    final match = _passwordsMatch();
    final valid = _isPasswordValid(passwordText);
    final isReady = passwordFilled && confirmFilled && match && valid;

    final lengthValid = passwordText.length >= 8;
    final specialCharValid =
    RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(passwordText);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/pictures/password.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '패스워드',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '아래에 비밀번호를 입력하세요.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 56),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: !_showPassword,
                        onChanged: (value) {
                          setState(() {});
                          if (value.length >= 8 &&
                              RegExp(r'[!@#\$%^&*(),.?":{}|<>]')
                                  .hasMatch(value)) {
                            _confirmFocusNode.requestFocus();
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'password',
                          labelStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                            const BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (passwordFilled && !lengthValid)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '• 비밀번호는 최소 8자 이상이어야 합니다.',
                            style: TextStyle(fontSize: 13, color: Colors.red),
                          ),
                        ),
                      if (passwordFilled && !specialCharValid)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '• 특수문자를 하나 이상 포함해야 합니다.',
                            style: TextStyle(fontSize: 13, color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 38),
                      TextField(
                        controller: _confirmController,
                        focusNode: _confirmFocusNode,
                        obscureText: !_showConfirmPassword,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'password verify',
                          labelStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: confirmFilled && !match
                                  ? Colors.red
                                  : Colors.green,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: confirmFilled && !match
                                  ? Colors.red
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPasswordRule = !_showPasswordRule;
                          });
                        },
                        child: const Text(
                          '비밀번호 조건',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            '- 최소 8자 이상\n- 특수문자 포함',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        crossFadeState: _showPasswordRule
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isReady
                      ? () {
                    SignupState.password = _passwordController.text.trim(); //api에 password 저장
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSetupScreen(),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    '다음으로',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
