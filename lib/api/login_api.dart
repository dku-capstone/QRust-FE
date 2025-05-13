import 'dart:convert';
import 'package:http/http.dart' as http;

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

      if (response.statusCode == 200) {
        // 성공적으로 로그인함
        return true;
      } else {
        // 서버 응답은 왔지만 로그인 실패
        print("로그인 실패: ${response.statusCode} / ${response.body}");
        return false;
      }
    } catch (e) {
      // 네트워크 에러 등
      print("로그인 중 오류 발생: $e");
      return false;
    }
  }
}
