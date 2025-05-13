import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStorage {
  static const _key = 'profile_image_path';

  // 이미지 파일 저장 (앱 내부로 복사)
  static Future<File?> saveProfileImage(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final savedImage = await imageFile.copy('${appDir.path}/profile.png');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, savedImage.path);
      return savedImage;
    } catch (e) {
      return null;
    }
  }

  // 저장된 이미지 불러오기
  static Future<File?> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_key);
    if (path != null && File(path).existsSync()) {
      return File(path);
    }
    return null;
  }

  // 이미지 초기화 (선택적으로 사용 가능)
  static Future<void> clearProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
