import 'dart:typed_data';
import 'package:camera/camera.dart';

class QrCaptureUtil {
  static Future<Uint8List?> captureImageAsBytes(CameraController controller) async {
    try {
      final XFile file = await controller.takePicture();
      return await file.readAsBytes();
    } catch (e) {
      print('❌ 캡처 실패: $e');
      return null;
    }
  }
}
