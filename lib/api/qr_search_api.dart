import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qrust/qr_storage/qr_search_condition.dart';
import 'package:qrust/qr_storage/qr_card_model.dart'; // QrCard 정의된 파일

Future<List<QrCard>> searchQrCodes(
    QrSearchCondition condition, int page, int size) async {
  final uri = Uri.parse(
      'http://mayfifth99.store:8080/api/v1/qrcode/search?page=$page&size=$size');

  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode(condition.toJson());

  print('🔍 [QR 조건 검색 요청]');
  print('▶️ POST $uri');
  print('▶️ Headers: $headers');
  print('▶️ Body: $body');

  final response = await http.post(uri, headers: headers, body: body);

  print('📥 [QR 조건 검색 응답]');
  print('◀️ Status Code: ${response.statusCode}');
  print('◀️ Body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> items = data['content'];
    return items.map((item) => QrCard.fromJson(item)).toList();
  } else {
    throw Exception('QR 코드 검색 실패: ${response.statusCode}');
  }
}
