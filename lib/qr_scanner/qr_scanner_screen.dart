import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrust/features/qr_capture_util.dart';
import 'package:qrust/features/qr_verification_service.dart';
import 'package:qrust/features/qr_result_handler.dart';
import 'package:qrust/features/qr_decoder_util.dart';
import 'package:qrust/widgets/upper_navbar.dart';
import 'package:qrust/qr_scanner/result_safe.dart';
import 'package:qrust/qr_scanner/result_warning.dart';
import 'package:qrust/qr_scanner/result_danger.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _hasAnalyzed = false;
  String? scannedUrl;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });

    _triggerAutoQrAnalysisOnce(); // ✅ 자동 분석 시작
  }

  Future<void> _triggerAutoQrAnalysisOnce() async {
    if (_hasAnalyzed) return;
    _hasAnalyzed = true;

    try {
      final file = await _cameraController.takePicture();
      final bytes = await file.readAsBytes();

      final String? url = await QrDecoderUtil.decodeQrFromImagePath(file.path);
      if (url == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR 코드에서 바이트를 추출할 수 없습니다.')),
        );
        return;
      }

      final String? result =
      await QrVerificationService.sendQrImageForVerification(bytes);
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서버 응답 실패')),
        );
        return;
      }

      QrResultHandler.handleQrVerificationResult(context, result, url);
    } catch (e) {
      print('❌ QR 자동 분석 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR 처리 중 오류 발생')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 불러왔습니다')),
      );
    }
  }

  void _showResultSelector() {
    String selectedType = 'safe';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '분석 결과 선택',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile(
                    title: const Text('안전'),
                    value: 'safe',
                    groupValue: selectedType,
                    onChanged: (value) =>
                        setState(() => selectedType = value.toString()),
                  ),
                  RadioListTile(
                    title: const Text('주의'),
                    value: 'warning',
                    groupValue: selectedType,
                    onChanged: (value) =>
                        setState(() => selectedType = value.toString()),
                  ),
                  RadioListTile(
                    title: const Text('위험'),
                    value: 'danger',
                    groupValue: selectedType,
                    onChanged: (value) =>
                        setState(() => selectedType = value.toString()),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (selectedType == 'safe') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QrResultSafeScreen(
                                url: scannedUrl ?? '',
                              ),
                            ),
                          );
                        } else if (selectedType == 'warning') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QrResultWarningScreen(
                                url: scannedUrl ?? '',
                                reportCount: 17,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  QrResultDangerScreen(url: scannedUrl ?? ''),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1AD282),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '결과 확인',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            NavigationAppBar(scaffoldKey: _scaffoldKey),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'QR 코드 인식 중...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'QR 코드를 화면에 맞춰주세요.',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D26A), Color(0xFF00B4D8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: _isCameraInitialized
                            ? CameraPreview(_cameraController)
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _pickImageFromGallery,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('사진에서 불러오기',
                            style: TextStyle(fontSize: 16)),
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
