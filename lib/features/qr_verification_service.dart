import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QrVerificationService {
  static Future<String?> sendQrImageForVerification(
      Uint8List imageBytes, BuildContext context) async {
    try {
      // ✅ 앱에 바이트 정보 출력
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('전송 디버그'),
          content: Text(
            '📦 바이트 크기: ${imageBytes.length}\n'
                '📦 앞 20바이트: ${imageBytes.take(20).toList()}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );

      // ✅ 서버 요청
      final response = await http.post(
        Uri.parse('http://mayfifth99.store:8080/api/v1/recognize/verify'),
        headers: {
          'Content-Type': 'application/octet-stream',
        },
        body: imageBytes,
      );

      // ✅ 앱에 응답 결과 출력
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('서버 응답'),
          content: Text(
            '📡 상태코드: ${response.statusCode}\n\n'
                '📄 응답 내용:\n${response.body}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );

      if (response.statusCode == 200) {
        return response.body.replaceAll('"', '').trim();
      } else {
        return null;
      }
    } catch (e) {
      // ❌ 예외 발생 시 앱에 표시
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('에러 발생'),
          content: Text('❌ 서버 전송 실패:\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return null;
    }
  }
}
