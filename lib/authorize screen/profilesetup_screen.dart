import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'signupdone_screen.dart';
import 'package:qrust/storage/profile_storage.dart';
import 'package:qrust/api/signup_api.dart';
import 'dart:convert';
import 'package:http/http.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final saved = await ProfileStorage.loadProfileImage();
    if (saved != null) {
      setState(() {
        _profileImage = saved;
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final savedImage = await ProfileStorage.saveProfileImage(File(picked.path));
      if (savedImage != null) {
        setState(() {
          _profileImage = savedImage;
        });
      }
    }
  }

  void _goToNext() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    SignupState.userName = name;

    final url = Uri.parse("http://mayfifth99.store:8080/api/v1/auth/signup");  // ← 실제 API 주소
    final body = SignupState.toJson();

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 성공 시 가입 완료 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignupSuccessScreen()),
        );
      } else {
        // 실패 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("회원가입 실패: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("네트워크 오류: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 완전 흰 배경
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64), // 상단 전체 내림
              const Text(
                '프로필 설정',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4), // 줄인 간격
              const Text(
                '회원님의 이름을 알려주세요.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              // 프로필 이미지 + 추가 버튼
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60), // 이미지와 입력창 간 거리 넓힘

              // 이름 입력창 + x 버튼
              TextField(
                controller: _nameController,
                focusNode: _focusNode,
                onChanged: (_) => setState(() {}), // x 버튼 동기화
                decoration: InputDecoration(
                  hintText: '이름을 입력하세요',
                  filled: true,
                  fillColor: const Color(0xFFE9E8ED),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  suffixIcon: _nameController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _nameController.clear();
                      });
                    },
                  )
                      : null,
                ),
              ),

              const Spacer(),

              // 다음으로 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _goToNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    '다음으로',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
