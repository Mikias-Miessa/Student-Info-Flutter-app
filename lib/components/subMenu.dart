import 'package:flutter/material.dart';
import '../screens/exam_result_screen.dart';
import '../screens/dashboard_screen.dart';

class SubMenu extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback onTap;
  final BuildContext context;
  SubMenu(
      {required this.title,
      required this.icon,
      required this.onTap,
      required this.context});
  void navigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      enabled: true,
      onTap: () => onTap(),
    );
  }
}
