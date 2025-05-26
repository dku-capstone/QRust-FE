import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportHistoryApi {
  static Future<List<Map<String, dynamic>>> fetchReportHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final rawToken = prefs.getString('session_cookie');

    if (rawToken == null || rawToken.isEmpty) {
      print('❌ JWT 토큰이 없습니다. 로그인 후 다시 시도해주세요.');
      return [];
    }

    final cookieToken = rawToken.startsWith('access_token=')
        ? rawToken
        : 'access_token=$rawToken';

    final url = Uri.parse('http://mayfifth99.store:8080/api/v1/report/my');

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
        final List<dynamic> data = body['data'];

        print('📦 서버 원본 데이터 개수: ${data.length}');
        for (var item in data) {
          print('🔹 원본 항목: $item');
        }

        final List<Map<String, dynamic>> result = data.map((item) {
          final converted = {
            'id': item['id'], // ✅ 상세 페이지 이동에 필요
            'url': item['url'],
            'date': item['incidentDate'],
            'status': _convertStatus(item['approveType']),
          };
          print('✅ 변환된 항목: $converted');
          return converted;
        }).toList();

        print('📋 최종 변환된 리스트 크기: ${result.length}');
        return result;
      } else {
        print('❌ 서버 오류: 상태 코드 ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('⚠️ 예외 발생: $e');
      return [];
    }
  }

  static String _convertStatus(String approveType) {
    switch (approveType) {
      case 'APPROVED':
        return '승인됨';
      case 'REJECTED':
        return '거부됨';
      default:
        return '대기중';
    }
  }
}
