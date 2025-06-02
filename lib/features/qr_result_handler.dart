import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrust/qr_scanner/result_safe.dart';
import 'package:qrust/qr_scanner/result_warning.dart';
import 'package:qrust/qr_scanner/result_danger.dart';

class QrResultHandler {
  static void handleQrVerificationResult(
      BuildContext context,
      String result,
      String url, [
        int reportCount = 0, // 기본값 0
      ]) {
    switch (result) {
      case 'TRUSTED_QR':
      // 🔗 신뢰된 QR → 웹사이트로 바로 이동
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        break;

      case 'VERIFIED_SAFE':
      // ✅ 안전 결과 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QrResultSafeScreen(url: url)),
        );
        break;

      case 'AI_MODEL_BLOCKED':
      // ❌ AI 모델 차단 → 위험 화면
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QrResultDangerScreen(url: url)),
        );
        break;

      case 'GOOGLE_BLOCKED':
      // ⚠️ 블랙리스트 팝업 차단
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('⚠️ 블랙리스트 사이트'),
            content: const Text('이 사이트는 사용자 신고로 차단되었습니다.\n접속할 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
        break;

      case 'REPORT_BLACKLISTED':
      // ⚠️ 신고 누적 → 경고 화면
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QrResultWarningScreen(url: url, reportCount: reportCount),
          ),
        );
        break;

      case 'INVALID_QR':
      default:
      // ❌ 오류 or 미지원 응답
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('올바르지 않은 QR 코드입니다.')),
        );
        break;
    }
  }
}
