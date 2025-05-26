import 'package:flutter/material.dart';
import 'package:qrust/api/qr_search_api.dart';
import 'package:qrust/qr_storage/qr_card_model.dart';
import 'package:qrust/qr_storage/qr_search_condition.dart';

class QrFilterBar extends StatefulWidget {
  final bool isEditMode;
  final bool allSelected;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedType;
  final String? selectedStatus;
  final VoidCallback onToggleEditMode;
  final VoidCallback onDeleteSelected;
  final VoidCallback onToggleSelectAll;
  final ValueChanged<String> onSearch;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onStatusChanged;

  // ✅ 추가된 파라미터
  final Function(List<QrCard>) onSearchResult;

  const QrFilterBar({
    super.key,
    required this.isEditMode,
    required this.allSelected,
    required this.startDate,
    required this.endDate,
    required this.selectedType,
    required this.selectedStatus,
    required this.onToggleEditMode,
    required this.onDeleteSelected,
    required this.onToggleSelectAll,
    required this.onSearch,
    required this.onStartDateTap,
    required this.onEndDateTap,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onSearchResult, // ✅ 생성자에 추가
  });

  @override
  State<QrFilterBar> createState() => _QrFilterBarState();
}

class _QrFilterBarState extends State<QrFilterBar> {
  bool isExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  // ✅ API 호출 함수 추가
  void _onSearchPressed() async {
    final condition = QrSearchCondition(
      title: _searchController.text,
      type: widget.selectedType,
      status: widget.selectedStatus == '활성화됨'
          ? 'ACTIVE'
          : widget.selectedStatus == '비활성화됨'
          ? 'INACTIVE'
          : null,
      start: widget.startDate?.toIso8601String(),
      end: widget.endDate?.toIso8601String(),
    );

    try {
      final result = await searchQrCodes(condition, 0, 30); // page=0, size=30
      widget.onSearchResult(result);
    } catch (e) {
      print('❌ 검색 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFF1AD282);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: widget.onSearch,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: '검색',
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: greenColor, width: 2),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                onPressed: () => setState(() => isExpanded = !isExpanded),
              )
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _onSearchPressed, // ✅ 여기에 연결
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 2,
            ),
            child: const Text('검색하기'),
          ),
          if (isExpanded) ...[
            const Divider(height: 32),
            const Text('날짜 검색'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onStartDateTap,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: greenColor),
                    ),
                    child: Text(
                      widget.startDate == null
                          ? '시작 날짜'
                          : '${widget.startDate!.year}/${widget.startDate!.month}/${widget.startDate!.day}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('-'),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onEndDateTap,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: greenColor),
                    ),
                    child: Text(
                      widget.endDate == null
                          ? '종료 날짜'
                          : '${widget.endDate!.year}/${widget.endDate!.month}/${widget.endDate!.day}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                dividerColor: Colors.grey[300],
                inputDecorationTheme: const InputDecorationTheme(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor, width: 2),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              child: DropdownButtonFormField<String>(
                value: widget.selectedType,
                onChanged: widget.onTypeChanged,
                decoration: const InputDecoration(
                  labelText: 'QR 코드 유형',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'URL', child: Text('URL')),
                  DropdownMenuItem(value: '사진', child: Text('사진')),
                  DropdownMenuItem(value: '비디오', child: Text('비디오')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                dividerColor: Colors.grey[300],
                inputDecorationTheme: const InputDecorationTheme(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor, width: 2),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              child: DropdownButtonFormField<String>(
                value: widget.selectedStatus,
                onChanged: widget.onStatusChanged,
                decoration: const InputDecoration(
                  labelText: 'QR 코드 상태',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '활성화됨', child: Text('활성화됨')),
                  DropdownMenuItem(value: '비활성화됨', child: Text('비활성화됨')),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
