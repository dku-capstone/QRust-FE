import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("http://mayfifth99.store:8080/api/v1/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print('◀️ 응답 코드: ${response.statusCode}');
      print('◀️ 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        // ✅ Set-Cookie 감지
        final setCookie = response.headers['set-cookie'];
        if (setCookie != null) {
          print('🍪 Set-Cookie 감지됨: $setCookie');

          // ✅ SharedPreferences에 쿠키 저장
          final sessionCookie = setCookie.split(';').first; // 예: "JSESSIONID=abc..."
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_cookie', sessionCookie);
          print('✅ session_cookie 저장 완료: $sessionCookie');
        } else {
          print('⚠️ Set-Cookie 헤더가 존재하지 않습니다.');
        }

        return true;
      } else {
        print("로그인 실패: ${response.statusCode} / ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ 로그인 중 오류 발생: $e");
      return false;
    }
  }
}
