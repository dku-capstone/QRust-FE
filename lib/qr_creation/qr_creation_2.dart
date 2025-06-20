import 'package:flutter/material.dart';
import 'package:qrust/widgets/upper_navbar.dart';
import 'package:qrust/api/qr_creation_api.dart';
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
  bool _isLoading = false;
  bool _isVerified = false;

  bool get _canProceed =>
      urlController.text.trim().isNotEmpty &&
          titleController.text.trim().isNotEmpty &&
          _isVerified;

  Future<void> _onGeneratePressed() async {
    if (!_canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 항목을 모두 입력하고 검증을 완료해주세요.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final api = QrCreationApi();
      final fixedUrl = await api.generateQrCode(
        url: urlController.text.trim(),
        title: titleController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QrResultScreen(
            url: fixedUrl,
            title: titleController.text.trim(),
            password: enablePassword ? passwordController.text.trim() : null,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR 코드 생성 실패: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    titleController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: const Drawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                          Text(
                            'QR 코드 내용 입력',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '선택한 유형에 맞는 정보를 입력해 주세요.',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                            textAlign: TextAlign.center,
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
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF1AD282)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '웹사이트 URL 주소 *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'QR에 삽입할 URL을 입력해 주세요.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: urlController,
                                        keyboardType: TextInputType.url,
                                        onChanged: (_) => setState(() {}),
                                        decoration: const InputDecoration(
                                          hintText: '예: https://jhiob.tistory.com/',
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF1AD282),
                                                width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: urlController.text
                                            .trim()
                                            .isEmpty
                                            ? null
                                            : () {
                                          // TODO: 검증 로직 연동
                                          setState(() {
                                            _isVerified = true;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                Text('검증이 완료되었습니다.')),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: urlController.text
                                              .trim()
                                              .isEmpty
                                              ? Colors.grey
                                              : (_isVerified
                                              ? const Color(0xFF1AD282)
                                              : Colors.red),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text(
                                          '검증',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF1AD282)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'QR 코드 이름 *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'QR 코드의 이름을 지정해 주세요.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: titleController,
                                  decoration: const InputDecoration(
                                    hintText: '예: QRust QR Code',
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF1AD282), width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: enablePassword,
                                onChanged: (value) =>
                                    setState(() => enablePassword = value!),
                                activeColor: Color(0xFF1AD282),
                              ),
                              const Text('비밀번호 설정'),
                            ],
                          ),
                          if (enablePassword) ...[
                            const SizedBox(height: 8),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: '비밀번호',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF1AD282), width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading || !_canProceed
                          ? null
                          : _onGeneratePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canProceed
                            ? const Color(0xFF1AD282)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        '생성하기',
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
            ),
          ],
        ),
      ),
    );
  }
}
