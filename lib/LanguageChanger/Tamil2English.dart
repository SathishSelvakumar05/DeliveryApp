// import 'package:flutter/material.dart';
// import 'package:google_mlkit_translation/google_mlkit_translation.dart';
//
// class TranslatorScreen extends StatefulWidget {
//   @override
//   _TranslatorScreenState createState() => _TranslatorScreenState();
// }
//
// class _TranslatorScreenState extends State<TranslatorScreen> {
//   final TextEditingController _controller = TextEditingController();
//   String _translatedText = "";
//
//   late final OnDeviceTranslator _translator;
//
//   @override
//   void initState() {
//     super.initState();
//     _translator = OnDeviceTranslator(
//       sourceLanguage: TranslateLanguage.english,
//       targetLanguage: TranslateLanguage.tamil,
//     );
//     _downloadModel();
//   }
//
//   Future<void> _downloadModel() async {
//     final modelManager = OnDeviceTranslatorModelManager();
//     await modelManager.downloadModel(TranslateLanguage.tamil.bcpCode);
//   }
//
//   void _translate() async {
//     final result = await _translator.translateText(_controller.text);
//     setState(() {
//       _translatedText = result;
//     });
//   }
//
//   @override
//   void dispose() {
//     _translator.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("English to Tamil Translator")),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(labelText: 'Enter English text'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _translate,
//               child: Text("Translate"),
//             ),
//             SizedBox(height: 24),
//             Text(
//               _translatedText,
//               style: TextStyle(fontSize: 18, color: Colors.black87),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
