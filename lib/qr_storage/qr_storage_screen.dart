import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qrust/widgets/upper_navbar.dart';
import 'package:qrust/qr_storage/qr_card_item.dart';
import 'package:qrust/qr_storage/qr_filter_bar.dart';
import 'package:qrust/qr_storage/qr_detail_dialog.dart';
import 'package:qrust/api/qr_card_data.dart';
import 'package:qrust/qr_storage/qr_card_model.dart';

class QrStorageScreen extends StatefulWidget {
  const QrStorageScreen({super.key});

  @override
  State<QrStorageScreen> createState() => _QrStorageScreenState();
}

class _QrStorageScreenState extends State<QrStorageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<QrCard> qrCardList = [];
  List<bool> cardSelected = [];
  List<bool> cardPaused = [];
  int selectedPage = 1;
  bool allSelected = false;
  bool isEditMode = false;
  bool isLoading = true;
  final int cardsPerPage = 4;
  String searchQuery = '';
  String? selectedType;
  String? selectedStatus;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      qrCardList = await fetchQrCardList(page: 0, size: 30);
      setState(() {
        cardSelected = List.generate(qrCardList.length, (_) => false);
        cardPaused = List.generate(qrCardList.length, (_) => false);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('[ERROR] QR 카드 불러오기 실패: $e');
    }
  }

  // ✅ 검색 결과로 리스트 업데이트
  void _updateQrList(List<QrCard> result) {
    setState(() {
      qrCardList = result;
      cardSelected = List.generate(result.length, (_) => false);
      cardPaused = List.generate(result.length, (_) => false);
      selectedPage = 1;
    });
  }

  void _toggleEditMode() => setState(() => isEditMode = !isEditMode);
  void _onSearchChanged(String value) => setState(() => searchQuery = value);
  void _onTypeChanged(String? value) => setState(() => selectedType = value);
  void _onStatusChanged(String? value) => setState(() => selectedStatus = value);
  void _onTogglePause(int index) => setState(() => cardPaused[index] = !cardPaused[index]);
  void _onSelectCard(int index) => setState(() => cardSelected[index] = !cardSelected[index]);

  void _toggleSelectAll() {
    setState(() {
      allSelected = !allSelected;
      for (int i = 0; i < cardSelected.length; i++) {
        cardSelected[i] = allSelected;
      }
    });
  }

  void _deleteSelectedCards() {
    setState(() {
      for (int i = cardSelected.length - 1; i >= 0; i--) {
        if (cardSelected[i]) {
          qrCardList.removeAt(i);
          cardSelected.removeAt(i);
          cardPaused.removeAt(i);
        }
      }
      allSelected = false;
      isEditMode = false;
    });
  }

  Future<void> _onCardTap(int index) async {
    final result = await showQrDetailDialog(
      context,
      qrCardList[index].title,
          (newTitle) {
        final old = qrCardList[index];
        setState(() {
          qrCardList[index] = QrCard(
            id: old.id,
            title: newTitle,
            imageUrl: old.imageUrl,
            createdAt: old.createdAt,
          );
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF1AD282)),
            dialogTheme: const DialogTheme(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) startDate = picked;
        else endDate = picked;
      });
    }
  }

  // ✅ 수정됨: 필터 조건 제거 → API 결과 그대로 출력
  List<int> _visibleCardIndexes() {
    return List.generate(qrCardList.length, (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    final indexes = _visibleCardIndexes();
    final totalPages = (indexes.length / cardsPerPage).ceil();
    final start = (selectedPage - 1) * cardsPerPage;
    final end = min(start + cardsPerPage, indexes.length);
    final paginatedIndexes = indexes.sublist(start, end);

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: NavigationAppBar(scaffoldKey: _scaffoldKey),
      drawer: const Drawer(),
      endDrawer: const Drawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QR 코드 보관함', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  QrFilterBar(
                    isEditMode: isEditMode,
                    allSelected: allSelected,
                    startDate: startDate,
                    endDate: endDate,
                    selectedType: selectedType,
                    selectedStatus: selectedStatus,
                    onToggleEditMode: _toggleEditMode,
                    onDeleteSelected: _deleteSelectedCards,
                    onToggleSelectAll: _toggleSelectAll,
                    onSearch: _onSearchChanged,
                    onStartDateTap: () => _selectDate(context, true),
                    onEndDateTap: () => _selectDate(context, false),
                    onTypeChanged: _onTypeChanged,
                    onStatusChanged: _onStatusChanged,
                    onSearchResult: _updateQrList, // ✅ 연결됨
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: _toggleEditMode,
                        icon: const Icon(Icons.edit, color: Colors.black),
                        label: const Text('편집하기', style: TextStyle(color: Colors.black)),
                      ),
                      if (isEditMode)
                        Row(
                          children: [
                            IconButton(
                              onPressed: _toggleSelectAll,
                              icon: Icon(
                                allSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: const Color(0xFF1AD282),
                              ),
                            ),
                            IconButton(
                              onPressed: _deleteSelectedCards,
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double paddingInnerHeight = constraints.maxHeight;
                        final double adjustedCardHeight = (paddingInnerHeight / 2) + 32;
                        final double cardAspectRatio = constraints.maxWidth / adjustedCardHeight;

                        return GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                          physics: const NeverScrollableScrollPhysics(),
                          children: paginatedIndexes.map((index) {
                            final card = qrCardList[index];
                            return QrCardItem(
                              index: index,
                              title: card.title,
                              qrImageUrl: card.imageUrl,
                              createdAt: card.createdAt,
                              isSelected: cardSelected[index],
                              isPaused: cardPaused[index],
                              isEditMode: isEditMode,
                              onTap: () => _onCardTap(index),
                              onTogglePause: () => _onTogglePause(index),
                              onSelect: () => _onSelectCard(index),
                              onDelete: () {
                                setState(() {
                                  qrCardList.removeAt(index);
                                  cardSelected.removeAt(index);
                                  cardPaused.removeAt(index);
                                });
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFF0F0F0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: selectedPage > 1 ? () => setState(() => selectedPage--) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPage > 1 ? const Color(0xFF1AD282) : Colors.white,
                    foregroundColor: selectedPage > 1 ? Colors.white : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text('이전'),
                ),
                Text('$selectedPage페이지'),
                ElevatedButton(
                  onPressed: selectedPage < totalPages ? () => setState(() => selectedPage++) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPage < totalPages ? const Color(0xFF1AD282) : Colors.white,
                    foregroundColor: selectedPage < totalPages ? Colors.white : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text('다음'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
