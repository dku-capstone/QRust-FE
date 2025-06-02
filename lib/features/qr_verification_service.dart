import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QrVerificationService {
  static Future<Map<String, String>?> sendQrImageForVerification(Uint8List imageBytes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionCookie = prefs.getString('session_cookie');

      final response = await http.post(
        Uri.parse('http://mayfifth99.store:8080/api/v1/recognize/verify'),
        headers: {
          'Content-Type': 'application/octet-stream',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
        body: imageBytes,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final status = json['data']['status'].toString().trim();
        final url = json['data']['url'].toString().trim();
        return {
          'status': status,
          'url': url,
          'reportCount': json['data']['reportCount']?.toString() ?? '0',
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
