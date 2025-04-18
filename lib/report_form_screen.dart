import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'report_success_screen.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedReason = '';
  DateTime? incidentDate;
  final TextEditingController urlController = TextEditingController();
  final TextEditingController etcReasonController = TextEditingController();
  final TextEditingController incidentDescController = TextEditingController();
  bool showWarningDetail = false;

  final List<String> reasons = [
    '악성 URL',
    '개인정보 입력 유도',
    '결제 요구',
    '기타',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != incidentDate) {
      setState(() {
        incidentDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'QRust',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          tabs: const [
            Tab(text: 'URL'),
            Tab(text: 'QR Code'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUrlTab(context),
          _buildQrTab(context),
        ],
      ),
    );
  }

  Widget _buildUrlTab(BuildContext context) {
    return _buildForm(context, includeUrlField: true);
  }

  Widget _buildQrTab(BuildContext context) {
    return _buildForm(context, includeUrlField: false);
  }

  Widget _buildForm(BuildContext context, {required bool includeUrlField}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('신고 내용 입력', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          if (includeUrlField)
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'URL', border: OutlineInputBorder()),
            )
          else
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                await picker.pickImage(source: ImageSource.gallery);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                  color: Colors.grey.shade200,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 50, color: Colors.black45),
                    SizedBox(height: 8),
                    Text('사진 보관함에서 선택'),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text('신고 사유', style: TextStyle(fontWeight: FontWeight.bold)),
          Column(
            children: reasons.map((reason) {
              return RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: selectedReason,
                onChanged: (value) {
                  setState(() {
                    selectedReason = value!;
                  });
                },
              );
            }).toList(),
          ),
          if (selectedReason == '기타')
            TextField(
              controller: etcReasonController,
              decoration: const InputDecoration(hintText: '기타 사유를 입력해주세요', border: OutlineInputBorder()),
            ),
          const SizedBox(height: 20),
          const Text('사건 날짜'),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('날짜 선택'),
              ),
              const SizedBox(width: 12),
              Text(
                incidentDate != null ? '${incidentDate!.year}-${incidentDate!.month}-${incidentDate!.day}' : '선택 안됨',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('사건 경위'),
          TextField(
            controller: incidentDescController,
            maxLines: 5,
            decoration: const InputDecoration(hintText: '텍스트를 입력해주세요', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => setState(() => showWarningDetail = !showWarningDetail),
            child: Row(
              children: const [
                Text('허위 신고에 관한 조항', style: TextStyle(decoration: TextDecoration.underline)),
                Icon(Icons.expand_more),
              ],
            ),
          ),
          if (showWarningDetail)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                '※ 허위 신고 시 법적 책임이 따를 수 있습니다. 신중히 작성해 주세요.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportSuccessScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
              ),
              child: const Text('제출하기'),
            ),
          ),
        ],
      ),
    );
  }
}