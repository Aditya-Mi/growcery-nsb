import 'package:flutter/material.dart';
import 'package:grocery_app/core/constants/colors.dart';

class ProfileListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback function;
  const ProfileListItem({
    super.key,
    required this.title,
    required this.function,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      onTap: function,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: lightBg,
        ),
        child: Icon(
          icon,
          color: Colors.grey[700],
        ),
      ),
      shape: const BeveledRectangleBorder(),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'NuntioSans',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
        size: 16,
      ),
    );
  }
}
