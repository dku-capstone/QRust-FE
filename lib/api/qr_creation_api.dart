import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QrCreationApi {
  QrCreationApi({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  static const String _baseUrl = 'http://mayfifth99.store:8080/api/v1/qrcode';

  /// ✅ URL을 자동으로 보정해주는 함수 (http/https 없으면 https 붙임)
  String normalizeUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'https://$trimmed';
  }

  /// ✅ QR 생성 API 호출
  Future<String> generateQrCode({
    required String url,
    required String title,
  }) async {
    final endpoint = '$_baseUrl/generate';
    final uri = Uri.parse(endpoint);

    // SharedPreferences에서 로그인 세션 쿠키 불러오기
    final prefs = await SharedPreferences.getInstance();
    final sessionCookie = prefs.getString('session_cookie');

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      if (sessionCookie != null) 'Cookie': sessionCookie,
    };

    // ✅ URL 자동 보정
    final fixedUrl = normalizeUrl(url);

    final body = jsonEncode({
      'type': 'URL',
      'url': fixedUrl,
      'title': title,
    });

    // ✅ 디버깅 로그
    print('▶️ POST $endpoint');
    print('▶️ Payload: $body');
    print('📤 Request Headers: $headers');

    final response = await _client.post(uri, headers: headers, body: body);

    // ✅ 응답 디버깅 로그
    print('◀️ Status: ${response.statusCode}');
    print('◀️ Body: ${response.body}');
    print('🍪 Set-Cookie (if any): ${response.headers['set-cookie']}');

    if (response.statusCode == 403) {
      throw Exception('403 Forbidden: 세션 쿠키가 누락되었거나 만료되었습니다.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'];

    if (data is String) {
      return data; // ✅ QR 이미지 URL 문자열 그대로 반환
    } else if (data is Map<String, dynamic>) {
      return data['qrUrl'] ?? data['url'];
    }

    throw Exception('예상치 못한 응답 형식: $data');
  }
}
