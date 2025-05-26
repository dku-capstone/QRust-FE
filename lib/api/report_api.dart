import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportApi {
  static Future<bool> submitReport({
    required String url,
    required String reportType,
    required String incidentDate,
    required String reportText,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final rawToken = prefs.getString('session_cookie');

    if (rawToken == null || rawToken.isEmpty) {
      print('❌ JWT 토큰 없음: 로그인 먼저 필요');
      return false;
    }

    final cookieToken = rawToken.startsWith('access_token=')
        ? rawToken
        : 'access_token=$rawToken';

    final requestBody = {
      'url': url,
      'reportType': reportType,
      'incidentDate': incidentDate,
      'reportText': reportText,
    };

    final urlEndpoint =
    Uri.parse('http://mayfifth99.store:8080/api/v1/report/register');

    print('🚀 신고 요청 시작');
    print('▶️ POST $urlEndpoint');
    print('🧾 요청 본문: ${jsonEncode(requestBody)}');
    print('🍪 쿠키: $cookieToken');

    try {
      final response = await http.post(
        urlEndpoint,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Cookie': cookieToken,
        },
        body: jsonEncode(requestBody),
      );

      print('📥 응답 상태 코드: ${response.statusCode}');
      print('📄 응답 본문: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ 신고 등록 성공');
        return true;
      } else {
        print('❌ 신고 실패 - 상태 코드: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ 예외 발생: $e');
      return false;
    }
  }
}
