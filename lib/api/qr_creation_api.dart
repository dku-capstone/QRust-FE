import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QrCreationApi {
  QrCreationApi({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  static const String _baseUrl = 'http://mayfifth99.store:8080/api/v1/qrcode';

  /// 서버에 URL과 제목을 전송하여 QR 이미지를 생성하고, 해당 이미지의 URL을 반환함
  Future<String> generateQrCode({
    required String url,
    required String title,
  }) async {
    final endpoint = '$_baseUrl/generate';
    final uri = Uri.parse(endpoint);

    // ✅ SharedPreferences에서 세션 쿠키 불러오기
    final prefs = await SharedPreferences.getInstance();
    final sessionCookie = prefs.getString('session_cookie');

    // ✅ 요청 헤더 구성
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      if (sessionCookie != null) 'Cookie': sessionCookie, // 세션 인증용 쿠키
    };

    // ✅ 요청 전송
    final response = await _client.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'type': 'URL',
        'url': url,
        'title': title,
      }),
    );

    // ✅ 로그 출력
    print('◀️ Status: ${response.statusCode}');
    print('◀️ Body: ${response.body}');

    // ✅ 오류 처리
    if (response.statusCode == 403) {
      throw Exception('403 Forbidden: 세션 쿠키가 누락되었거나 만료되었습니다.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }

    // ✅ 응답 파싱 및 QR URL 추출
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'];

    if (data is String) {
      return data; // ← 서버가 문자열 URL 직접 반환하는 경우
    } else if (data is Map<String, dynamic>) {
      return data['qrUrl'] ?? data['url'];
    } else {
      throw Exception('예상치 못한 응답 형식: $data');
    }
  }
}
