import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;

  const CustomAppBar({super.key, required this.title, required this.backgroundColor});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Default app bar height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: true,
      title: Image.asset(
        'assets/tiny-detector-white.png', // Your image asset
        height: 40,
        fit: BoxFit.contain,
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, size: 35, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }
}