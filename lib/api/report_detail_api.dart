import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportDetailApi {
  static Future<Map<String, dynamic>?> fetchReportDetail(int reportId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawToken = prefs.getString('session_cookie');

    if (rawToken == null || rawToken.isEmpty) {
      print("❌ JWT 토큰이 없습니다.");
      return null;
    }

    final cookieToken = rawToken.startsWith('access_token=')
        ? rawToken
        : 'access_token=$rawToken';

    final url = Uri.parse('http://mayfifth99.store:8080/api/v1/report/$reportId');

    print('📤 [GET] $url');
    print('🍪 Cookie: $cookieToken');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Cookie': cookieToken,
        },
      );

      print('📥 응답 상태 코드: ${response.statusCode}');
      print('📄 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'];
      } else {
        print('❌ 서버 오류: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('⚠️ 예외 발생: $e');
      return null;
    }
  }
}
