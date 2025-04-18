import 'package:flutter/material.dart';
import 'home_screen.dart';

class QrStorageScreen extends StatefulWidget {
  const QrStorageScreen({super.key});

  @override
  State<QrStorageScreen> createState() => _QrStorageScreenState();
}

class _QrStorageScreenState extends State<QrStorageScreen> {
  bool isExpanded = false;
  int selectedPage = 1;
  String? selectedType;
  String? selectedStatus;
  bool allSelected = false;
  bool isEditMode = false;
  List<int> deletedIndexes = [];
  List<String> cardTitles = List.generate(30, (i) => 'QR 카드 ${i + 1}');
  List<bool> cardSelected = List.generate(30, (_) => false);
  List<bool> cardPaused = List.generate(30, (_) => false);
  String searchQuery = '';
  DateTime? startDate;
  DateTime? endDate;
  int rebuildTrigger = 0;

  Future<String?> _showQrDetailDialog(int index) async {
    TextEditingController titleController = TextEditingController(text: cardTitles[index]);
    bool isEditingTitle = false;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context, null),
                  ),
                ),
                const Icon(Icons.qr_code, size: 150),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: isEditingTitle
                          ? TextField(
                        controller: titleController,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      )
                          : Text(
                        cardTitles[index],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(isEditingTitle ? Icons.check : Icons.edit),
                      onPressed: () {
                        setState(() {
                          if (isEditingTitle) {
                            //cardTitles[index] = titleController.text;
                            isEditingTitle = !isEditingTitle;
                          }
                          isEditingTitle = !isEditingTitle;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text('생성일: 2025-04-16'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.link, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Flexible(child: Text('https://jhiob.tistory.com')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text('다운로드'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('다운로드 완료되었습니다')),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text('공유'),
                      onPressed: () {
                        // 공유 기능은 나중에 구현
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context, 'DELETE_CARD');

                        //Future.delayed(const Duration(milliseconds: 50), () {
                          //if (mounted) {
                            //setState(() {
                              //deletedIndexes.add(index);
                            //});
                            //deletedIndexes.add(index);
                            //rebuildTrigger++;
                          //}
                        //});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () {
                  Navigator.pop(context, titleController.text);
                },
                child: const Text('저장 후 닫기')
                ),
              ],
            ),
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
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date, String placeholder) {
    if (date == null) return placeholder;
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  List<int> _visibleCardIndexes() {
    final indexes = <int>[];
    for (int i = 0; i < cardTitles.length; i++) {
      if (deletedIndexes.contains(i)) continue;
      if (!cardTitles[i].contains(searchQuery)) continue;
      if (selectedStatus == '일시중지됨' && !cardPaused[i]) continue;
      if (selectedStatus == '활성화됨' && cardPaused[i]) continue;
      indexes.add(i);
    }
    return indexes;
  }

  Widget _buildQrCardSection() {
    final visibleIndexes = _visibleCardIndexes();
    final totalPages = (visibleIndexes.length / 6).ceil().clamp(1, double.infinity).toInt();
    selectedPage = selectedPage.clamp(1, totalPages);
    final pagedIndexes = visibleIndexes.skip((selectedPage - 1) * 6).take(6).toList();

    final gridKey = ValueKey('${pagedIndexes.map((i) => i.toString()).join(',')}_$rebuildTrigger');
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: GridView.builder(
            key: gridKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pagedIndexes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, i) {
              final cardIndex = pagedIndexes[i];
              return GestureDetector(
                //onTap: () => _showQrDetailDialog(cardIndex), //팝업 열기
                onTap: () async {
                  if (!isEditMode) {
                    final result = await _showQrDetailDialog(cardIndex);

                    if (result == 'DELETE_CARD') {
                      setState(() {
                        deletedIndexes.add(cardIndex);
                      });
                    } else if (result != null && result != cardTitles[cardIndex]) {
                      setState(() {
                        cardTitles[cardIndex] = result;
                        rebuildTrigger++;
                      });
                    }
                  }
                },
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.vertical,
                        child: child,
                      ),
                    );
                  },
                  child: deletedIndexes.contains(cardIndex)
                      ? SizedBox.shrink(key: ValueKey('deleted_$cardIndex'))
                      : AnimatedContainer(
                    key: ValueKey('card_${cardIndex}_${cardTitles[cardIndex].hashCode}'), // <-- 여기 key에 title도 포함!
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: cardPaused[cardIndex]
                                  ? Colors.orange
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: PopupMenuButton<String>(
                                        onSelected: (value) {
                                          setState(() {
                                            if (value == 'delete') {
                                              deletedIndexes.add(cardIndex);
                                            } else if (value == 'pause') {
                                              cardPaused[cardIndex] = true;
                                            } else if (value == 'resume') {
                                              cardPaused[cardIndex] = false;
                                            }
                                          });
                                        },
                                        itemBuilder: (context) => [
                                          if (!cardPaused[cardIndex])
                                            const PopupMenuItem(
                                              value: 'pause',
                                              child: Text('정지하기'),
                                            )
                                          else
                                            const PopupMenuItem(
                                              value: 'resume',
                                              child: Text('활성화하기'),
                                            ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('삭제하기'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.qr_code, size: 80),
                                    const SizedBox(height: 8),
                                    Text(
                                      deletedIndexes.contains(cardIndex)
                                          ? '[삭제됨]'
                                          : cardTitles[cardIndex],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      '2025-04-16',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.download),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text('다운로드 완료되었습니다')),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isEditMode)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Checkbox(
                                    value: cardSelected[cardIndex],
                                    onChanged: (val) => setState(() {
                                      cardSelected[cardIndex] = val!;
                                    }),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: () => setState(() => selectedPage = 1),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => selectedPage = selectedPage > 1 ? selectedPage - 1 : 1),
              ),
              for (int i = 1; i <= totalPages; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () => setState(() => selectedPage = i),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedPage == i ? Colors.blue : Colors.grey.shade200,
                      foregroundColor: selectedPage == i ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text('$i'),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => selectedPage = selectedPage < totalPages ? selectedPage + 1 : totalPages),
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: () => setState(() => selectedPage = totalPages),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final startDateText = _formatDate(startDate, '시작일');
    final endDateText = _formatDate(endDate, '종료일');

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Text('내비게이션', style: TextStyle(fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('홈'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
        title: const Text(
          'QRust',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('QR 코드 보관함', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Column(
                  children: const [
                    Icon(Icons.qr_code, size: 32),
                    SizedBox(height: 4),
                    Text('QR 코드 생성', style: TextStyle(fontSize: 12, color: Colors.grey))
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('내 QR 코드', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => searchQuery = val),
                          onSubmitted: (val) => setState(() => searchQuery = val),
                          decoration: const InputDecoration(
                            hintText: '검색',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                        onPressed: () => setState(() => isExpanded = !isExpanded),
                      ),
                    ],
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('시작 날짜:'),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, true),
                          child: Text(_formatDate(startDate, '시작일')),
                        ),
                        const SizedBox(width: 16),
                        const Text('종료 날짜:'),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, false),
                          child: Text(_formatDate(endDate, '종료일')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Align(alignment: Alignment.centerLeft, child: Text('QR 코드 유형')),
                    Wrap(
                      spacing: 8,
                      children: ['웹사이트', '비디오', '사진'].map((type) => ChoiceChip(
                        label: Text(type),
                        selected: selectedType == type,
                        onSelected: (selected) => setState(() {
                          selectedType = selectedType == type ? null : type;
                        }),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Align(alignment: Alignment.centerLeft, child: Text('QR 코드 상태')),
                    Wrap(
                      spacing: 8,
                      children: ['활성화됨', '일시중지됨'].map((status) => ChoiceChip(
                        label: Text(status),
                        selected: selectedStatus == status,
                        onSelected: (selected) => setState(() {
                          selectedStatus = selectedStatus == status ? null : status;
                        }),
                      )).toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            isEditMode = !isEditMode;

                            // 완료 누르면 전체 선택 초기화
                            if (!isEditMode) {
                              allSelected = false;
                              for (int i = 0; i < cardSelected.length; i++) {
                                cardSelected[i] = false;
                              }
                            }
                          });
                        },
                        icon: Icon(isEditMode ? Icons.check : Icons.edit),
                        label: Text(isEditMode ? '완료' : '편집하기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isEditMode)
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: allSelected,
                          onChanged: (val) {
                            setState(() {
                              allSelected = val!;
                              for (int i = 0; i < cardSelected.length; i++) {
                                cardSelected[i] = val;
                              }
                            });
                          },
                        ),
                        const Text('전체 선택'),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          for (int i = 0; i < cardSelected.length; i++) {
                            if (cardSelected[i]) deletedIndexes.add(i);
                          }
                        });
                        //Navigator.pop(context, true);
                      },
                    ),
                  ],
                ),
              ),

            // QR 카드 표시 구간
            const SizedBox(height: 16),
            _buildQrCardSection(),
          ],
        ),
      ),
    );
  }
}
