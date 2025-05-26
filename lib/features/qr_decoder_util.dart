import 'dart:io';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class QrDecoderUtil {
  static Future<String?> decodeQrFromImagePath(String imagePath) async {
    final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);
    final inputImage = InputImage.fromFilePath(imagePath);
    final barcodes = await barcodeScanner.processImage(inputImage);
    await barcodeScanner.close();

    if (barcodes.isNotEmpty) {
      return barcodes.first.rawValue;
    } else {
      return null;
    }
  }
}
