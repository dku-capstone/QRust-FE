import 'package:flutter/material.dart';
import 'package:qrust/widgets/upper_navbar.dart';
import 'package:qrust/qr_creation/qr_creation_3.dart';

class QrCreationStep2Screen extends StatefulWidget {
  final String selectedType;

  const QrCreationStep2Screen({super.key, required this.selectedType});

  @override
  State<QrCreationStep2Screen> createState() => _QrCreationStep2ScreenState();
}

class _QrCreationStep2ScreenState extends State<QrCreationStep2Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool enablePassword = false;

  bool get _canProceed {
    return urlController.text.trim().isNotEmpty &&
        titleController.text.trim().isNotEmpty;
  }

  void _validateAndProceed() {
    if (_canProceed) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QrResultScreen(
            url: urlController.text.trim(),
            title: titleController.text.trim(),
            password: enablePassword ? passwordController.text.trim() : null,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 항목을 모두 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NavigationAppBar(scaffoldKey: _scaffoldKey),
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'QR 코드 생성 step2. 내용 입력',
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
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'QR 코드 내용 입력',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '선택한 유형에 맞는 정보를 입력해 주세요.',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: '제목',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: enablePassword,
                          onChanged: (value) {
                            setState(() {
                              enablePassword = value!;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        const Text('비밀번호 설정'),
                      ],
                    ),
                    if (enablePassword)
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),

                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _validateAndProceed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'QR 코드 생성',
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
