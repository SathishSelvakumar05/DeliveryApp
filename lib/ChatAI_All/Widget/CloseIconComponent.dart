import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloseIconComponent extends StatelessWidget {
  const CloseIconComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return circularAvatarWithClose(
      text: "AI",
      onClose: () {
        print("Closed!");
      },
    );

  }
  Widget circularAvatarWithClose({
    required String text,
    VoidCallback? onClose,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Positioned(
          right: -4,
          top: -4,
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
              ),
              padding: const EdgeInsets.all(3),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

}

