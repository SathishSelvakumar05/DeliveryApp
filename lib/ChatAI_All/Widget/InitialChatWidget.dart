import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialChatWidget extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  const InitialChatWidget({super.key,required this.onTap,required this.icon,required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueGrey.shade700, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
