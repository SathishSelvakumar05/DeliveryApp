import 'package:flutter/material.dart';

class ProButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColors;
  final IconData? icon;
  final bool isOutlined;

  const ProButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColors,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Theme.of(context).primaryColor;
    final textColor = textColors ?? Colors.white;


    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color:textColor, size: 18),
          const SizedBox(width: 5),
        ],
        Text(
          text,
          style:  TextStyle(
            color:textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );

    return isOutlined
        ? OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: primaryColor, width: 1.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      onPressed: onPressed,
      child: buttonChild,
    )
        : ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        elevation: 6,
        shadowColor: primaryColor.withOpacity(0.4),
      ),
      onPressed: onPressed,
      child: buttonChild,
    );
  }
}
