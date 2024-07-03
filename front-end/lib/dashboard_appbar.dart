import 'package:flutter/material.dart';

class DashboardAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  const DashboardAppbar({
    Key? key,
    required this.title,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}