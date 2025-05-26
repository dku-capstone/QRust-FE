import 'package:flutter/material.dart';

class QrCardItem extends StatefulWidget {
  final int index;
  final String title;
  final String createdAt;
  final String qrImageUrl;
  final bool isSelected;
  final bool isPaused;
  final bool isEditMode;
  final VoidCallback onTap;
  final VoidCallback onTogglePause;
  final VoidCallback onSelect;
  final VoidCallback onDelete;

  const QrCardItem({
    super.key,
    required this.index,
    required this.title,
    required this.createdAt,
    required this.qrImageUrl,
    required this.isSelected,
    required this.isPaused,
    required this.isEditMode,
    required this.onTap,
    required this.onTogglePause,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  State<QrCardItem> createState() => _QrCardItemState();
}

class _QrCardItemState extends State<QrCardItem> {
  bool _showMenu = false;

  void _toggleMenu() {
    setState(() => _showMenu = !_showMenu);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isPaused ? Colors.red : Colors.grey.shade300;

    return GestureDetector(
      onTap: widget.isEditMode ? widget.onSelect : widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              children: [
                // 상단 Row
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.isEditMode
                          ? Icon(
                        widget.isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: widget.isSelected ? const Color(0xFF1AD282) : Colors.grey,
                        size: 20,
                      )
                          : const SizedBox(width: 20),
                      GestureDetector(
                        onTap: _toggleMenu,
                        child: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // QR 이미지 및 텍스트
                Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.qrImageUrl,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.qr_code, size: 100),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.createdAt,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 토글 메뉴 (점 세 개 아래에 배치)
          if (_showMenu)
            Positioned(
              top: 30,
              right: 12,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.onDelete();
                        _toggleMenu();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('삭제하기', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const Divider(height: 1),
                    InkWell(
                      onTap: () {
                        widget.onTogglePause();
                        _toggleMenu();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          widget.isPaused ? '활성화하기' : '정지하기',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
