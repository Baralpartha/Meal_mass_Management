import 'package:flutter/material.dart';

class AppEmpty extends StatelessWidget {
  final String message;
  final IconData? icon;
  const AppEmpty(
      {super.key, this.message = 'No data available', this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
