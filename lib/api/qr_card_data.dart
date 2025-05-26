import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrust/qr_storage/qr_card_model.dart';

Future<List<QrCard>> fetchQrCardList({
  required int page,
  required int size,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final sessionCookie = prefs.getString('session_cookie');

  if (sessionCookie == null) {
    throw Exception('❌ session_cookie가 없습니다.');
  }

  final url = Uri.parse('http://mayfifth99.store:8080/api/v1/qrcode/user?page=$page&size=$size');

  print('▶️ GET $url');
  print('🍪 쿠키 전송: $sessionCookie');

  final response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Cookie': sessionCookie,
    },
  );

  print('◀️ 응답 코드: ${response.statusCode}');
  print('◀️ 응답 본문: ${response.body}');

  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    final List<dynamic>? content = jsonBody['data']?['content'];
    if (content == null) throw Exception('❌ content가 없습니다.');

    return content.map((e) => QrCard.fromJson(e)).toList();
  } else {
    throw Exception('❌ 서버 오류: ${response.statusCode}');
  }
}
