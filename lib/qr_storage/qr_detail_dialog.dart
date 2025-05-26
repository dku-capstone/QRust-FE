import 'package:flutter/material.dart';

Future<String?> showQrDetailDialog(
    BuildContext context,
    String initialTitle,
    void Function(String) onConfirm,
    ) async {
  TextEditingController titleController = TextEditingController(text: initialTitle);
  bool isEditingTitle = false;

  return showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
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
                        titleController.text,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(isEditingTitle ? Icons.check : Icons.edit),
                      onPressed: () {
                        setState(() {
                          if (isEditingTitle) {
                            onConfirm(titleController.text);
                            Navigator.pop(context, titleController.text);
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
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context, 'DELETE_CARD');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    onConfirm(titleController.text);
                    Navigator.pop(context, titleController.text);
                  },
                  child: const Text('저장 후 닫기'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


