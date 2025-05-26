import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrust/features/qr_decoder_util.dart';
import 'package:qrust/features/qr_result_handler.dart';
import 'package:qrust/features/qr_verification_service.dart';
import 'package:qrust/widgets/upper_navbar.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  bool _hasAnalyzed = false;

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
      _isLoading = false;
    });

    _triggerAutoQrAnalysisOnce();
  }

  Future<void> _triggerAutoQrAnalysisOnce() async {
    if (_hasAnalyzed) return;
    _hasAnalyzed = true;

    setState(() {
      _isLoading = true;
    });

    try {
      final file = await _cameraController.takePicture();
      final bytes = await file.readAsBytes();

      await _cameraController.dispose(); // 분석 중 카메라 정지

      final String? url = await QrDecoderUtil.decodeQrFromImagePath(file.path);
      if (url == null) {
        _showError('QR 코드에서 URL을 추출할 수 없습니다.');
        return;
      }

      final result = await QrVerificationService.sendQrImageForVerification(bytes);
      if (result == null) {
        _showError('서버 응답 실패');
        return;
      }

      final status = result['status']!;
      final parsedUrl = result['url']!;

      if (status == 'INVALID_QR') {
        _showRetryDialog();
        return;
      }

      QrResultHandler.handleQrVerificationResult(context, status, parsedUrl);
    } catch (e) {
      _showError('QR 처리 중 오류 발생');
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('❌ 올바르지 않은 QR 코드'),
        content: const Text('QR 코드를 정확히 촬영해주세요.\n다시 시도하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() {
                _hasAnalyzed = false;
                _isLoading = false;
                _isCameraInitialized = false;
              });
              await _initializeCamera();
            },
            child: const Text('재시도'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    setState(() {
      _isLoading = false;
    });
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
                            ? (_isLoading
                            ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D26A)),
                            strokeWidth: 5,
                          ),
                        )
                            : CameraPreview(_cameraController))
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
                        child: const Text('사진에서 불러오기', style: TextStyle(fontSize: 16)),
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
