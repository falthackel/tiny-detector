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
      title: SizedBox(
        height: 40,
        child: Center(
          child: Image(
            image: const AssetImage('assets/tiny-detector-white.png'), // Assuming your image asset
            fit: BoxFit.contain,
          ),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, size: 35, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {}, // Add your action here
          ),
        ),
      ],
    );
  }
}