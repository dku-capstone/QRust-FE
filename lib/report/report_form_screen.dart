import 'package:flutter/material.dart';
import 'package:qrust/widgets/upper_navbar.dart';
import 'package:qrust/widgets/drawer_menu.dart';
import 'package:qrust/report/report_success_screen.dart';
import 'package:qrust/api/report_api.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({Key? key}) : super(key: key);

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _selectedReason;
  DateTime? _selectedDate;
  bool _showReasonDropdown = false;

  final List<String> _reasonOptions = [
    '악성 URL',
    '개인정보 입력 유도',
    '결제 요구',
    '기타',
  ];

  bool get _isFormValid =>
      _urlController.text.isNotEmpty &&
          _selectedReason != null &&
          _selectedDate != null &&
          _descriptionController.text.isNotEmpty;

  String _convertReasonToCode(String reason) {
    switch (reason) {
      case '악성 URL':
        return 'MALICIOUS_URL';
      case '개인정보 입력 유도':
        return 'PHISHING_INPUT';
      case '결제 요구':
        return 'FAKE_PAYMENT';
      case '기타':
      default:
        return 'ETC';
    }
  }

  Future<void> _handleSubmit() async {
    final url = _urlController.text.trim();
    final reasonCode = _convertReasonToCode(_selectedReason!);
    final date = _selectedDate!.toIso8601String().split('T').first;
    final text = _descriptionController.text.trim();

    final success = await ReportApi.submitReport(
      url: url,
      reportType: reasonCode,
      incidentDate: date,
      reportText: text,
    );

    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReportSuccessScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NavigationAppBar(scaffoldKey: _scaffoldKey),
            Expanded(
              child: SingleChildScrollView(
                physics: _showReasonDropdown
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: Text(
                          '피싱 URL 신고',
                          style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: Text(
                          '악성으로 의심되는 URL을 신고해주세요',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildLabeledTextField(
                      label: 'URL 입력',
                      controller: _urlController,
                      hintText: '신고할 URL을 입력하세요.',
                    ),
                    const SizedBox(height: 24),
                    _buildReasonSelector(),
                    const SizedBox(height: 24),
                    _buildDateSelector(),
                    const SizedBox(height: 24),
                    _buildLabeledTextField(
                      label: '사건 경위',
                      controller: _descriptionController,
                      hintText: '텍스트를 입력해주세요',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _isFormValid ? const Color(0xFF1AD282) : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isFormValid ? _handleSubmit : null,
                  child: const Text(
                    '신고하기',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                border: InputBorder.none,
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('신고 사유',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GestureDetector(
            onTap: () => setState(() => _showReasonDropdown = !_showReasonDropdown),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedReason ?? '선택',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                      _selectedReason == null ? Colors.grey : Colors.black,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
        if (_showReasonDropdown)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF1AD282)),
                ),
                child: Column(
                  children: _reasonOptions.map((reason) {
                    return Material(
                      color: _selectedReason == reason
                          ? Colors.grey[200]
                          : Colors.transparent,
                      child: ListTile(
                        title: Text(reason,
                            style: const TextStyle(color: Colors.black)),
                        onTap: () {
                          setState(() {
                            _selectedReason = reason;
                            _showReasonDropdown = false;
                          });
                        },
                        selected: _selectedReason == reason,
                        selectedTileColor:
                        const Color(0xFF1AD282).withOpacity(0.1),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('사건 날짜',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF1AD282),
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Color(0xFF1AD282),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
                child: const Text('날짜 선택'),
              ),
              const SizedBox(width: 12),
              Text(
                _selectedDate == null
                    ? '선택 안됨'
                    : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                style: const TextStyle(fontSize: 14),
              )
            ],
          ),
        ],
      ),
    );
  }
}
