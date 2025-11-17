// import 'package:flutter/material.dart';
// import 'health_assistant_screen.dart'; // your existing screen
//
// enum ChatMode { chatAI, appointment, consultation }
//
// class AIOptionsSection extends StatefulWidget {
//   const AIOptionsSection({super.key});
//
//   @override
//   State<AIOptionsSection> createState() => _AIOptionsSectionState();
// }
//
// class _AIOptionsSectionState extends State<AIOptionsSection> {
//   ChatMode? _currentMode;
//
//   void askDate() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Asking for date...")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
//
//   Widget _buildOptionTile({
//     required IconData icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.blueGrey.shade700, size: 22),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 text,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }
