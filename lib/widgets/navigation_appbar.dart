import 'package:flutter/material.dart';

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NavigationAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 12),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Container(
            height: 56, // 높이 증가
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // 아이콘 세로 중앙 정렬
              children: [
                // Menu button
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
                // Settings button only
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.black),
                  onPressed: () {
                    // Settings action
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}