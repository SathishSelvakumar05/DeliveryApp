// // lib/main.dart
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:tflite_flutter/tflite_flutter.dart';
//
//
// class GenerateAIData extends StatefulWidget {
//   const GenerateAIData({super.key});
//   @override
//   HomePageState createState() => HomePageState();
// }
//
// class HomePageState extends State<GenerateAIData> {
//   Interpreter? _interpreter;
//   List<String> _labels = [];
//   File? _image;
//   String _resultText = '';
//   final picker = ImagePicker();
//
//   // model info
//   late int inputHeight;
//   late int inputWidth;
//   late int inputChannels;
//   late int numClasses;
//   late TfLiteType inputType;
//   bool modelLoaded = false;
//   // change this if your model expects normalization in [-1,1]
//   bool useMeanStdNormalization = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadModelAndLabels();
//   }
//
//   Future<void> _loadModelAndLabels() async {
//     try {
//       // Try to load interpreter (two path variants)
//       try {
//         _interpreter = await Interpreter.fromAsset('assets/1.tflite');
//       } catch (_) {
//         _interpreter ??= await Interpreter.fromAsset('1.tflite');
//       }
//
//       // Read input / output tensor info
//       final inputTensor = _interpreter!.getInputTensor(0);
//       final inputShape = inputTensor.shape; // e.g. [1,224,224,3]
//       inputType = inputTensor.type as TfLiteType;
//       // Handle different rank formats
//       if (inputShape.length == 4) {
//         inputHeight = inputShape[1];
//         inputWidth = inputShape[2];
//         inputChannels = inputShape[3];
//       } else {
//         // fallback
//         inputHeight = inputShape[2];
//         inputWidth = inputShape[3];
//         inputChannels = inputShape[1];
//       }
//
//       final outputTensor = _interpreter!.getOutputTensor(0);
//       final outShape = outputTensor.shape; // e.g. [1,5]
//       numClasses = outShape.last;
//
//       // Load labels
//       final rawLabels = await rootBundle.loadString('assets/labels.txt');
//       _labels = rawLabels
//           .split('\n')
//           .map((s) => s.trim())
//           .where((s) => s.isNotEmpty)
//           .toList();
//
//       setState(() {
//         modelLoaded = true;
//       });
//
//       debugPrint('Model loaded. Input: $inputHeight x $inputWidth x $inputChannels, '
//           'inputType: $inputType, numClasses: $numClasses');
//       debugPrint('Labels: $_labels');
//     } catch (e) {
//       debugPrint('Error loading model: $e');
//       setState(() {
//         _resultText = 'Failed to load model: $e';
//       });
//     }
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     final picked = await picker.pickImage(source: source, maxWidth: 1600);
//     if (picked == null) return;
//     setState(() {
//       _image = File(picked.path);
//       _resultText = 'Running inference...';
//     });
//     await _runInference(File(picked.path));
//   }
//
//   Future<void> _runInference(File imageFile) async {
//     if (!modelLoaded || _interpreter == null) {
//       setState(() => _resultText = 'Model not loaded');
//       return;
//     }
//
//     // decode & resize to model input size
//     final bytes = await imageFile.readAsBytes();
//     final oriImage = img.decodeImage(bytes);
//     if (oriImage == null) {
//       setState(() => _resultText = 'Cannot decode image');
//       return;
//     }
//     final resized = img.copyResizeCropSquare(oriImage, radius: inputHeight,size: 224 );
//
//     // Prepare input
//     dynamic input;
//     if (inputType == TfLiteType.uint8 || inputType == TfLiteType.int8) {
//       // quantized model: pass int values 0..255
//       input = List.generate(1, (_) => List.generate(
//         inputHeight,
//             (y) => List.generate(
//           inputWidth,
//               (x) {
//             final pixel = resized.getPixel(x, y);
//             return [
//               // img.getRed(pixel),
//               // img.getGreen(pixel),
//               // img.getBlue(pixel)
//             ];
//           },
//         ),
//       ));
//     } else {
//       // float model: normalize to 0..1 or -1..1 based on flag
//       input = List.generate(1, (_) => List.generate(
//         inputHeight,
//             (y) => List.generate(
//           inputWidth,
//               (x) {
//             final pixel = resized.getPixel(x, y);
//             double r = 22.4;
//             double g = 33.2;
//             double b = 11.1;
//             // double r = img.getRed(pixel).toDouble();
//             // double g = img.getGreen(pixel).toDouble();
//             // double b = img.getBlue(pixel).toDouble();
//             if (useMeanStdNormalization) {
//               return [
//                 (r - 127.5) / 127.5,
//                 (g - 127.5) / 127.5,
//                 (b - 127.5) / 127.5
//               ];
//             } else {
//               return [r / 255.0, g / 255.0, b / 255.0];
//             }
//           },
//         ),
//       ));
//     }
//
//     // Prepare output buffer: [1, numClasses]
//     dynamic output;
//     if (outputTypeIsQuantized(_interpreter!)) {
//       output = List.generate(1, (_) => List.filled(numClasses, 0));
//     } else {
//       output = List.generate(1, (_) => List.filled(numClasses, 0.0));
//     }
//
//     // Run inference
//     try {
//       _interpreter!.run(input, output);
//     } catch (e) {
//       setState(() => _resultText = 'Inference failed: $e');
//       return;
//     }
//
//     // Extract results as doubles
//     List<double> scores = List.filled(numClasses, 0.0);
//     if (output[0] is List<int>) {
//       for (int i = 0; i < numClasses; i++) {
//         scores[i] = (output[0][i] as int).toDouble();
//       }
//     } else {
//       for (int i = 0; i < numClasses; i++) {
//         scores[i] = (output[0][i] as num).toDouble();
//       }
//     }
//
//     // Normalize for display
//     final double sum = scores.fold(0.0, (a, b) => a + b);
//     if (sum > 0) {
//       for (int i = 0; i < scores.length; i++) {
//         scores[i] = scores[i] / sum;
//       }
//     }
//
//     // top-3
//     final top = topK(scores, 3);
//
//     final resultText = top.map((t) {
//       final label = (t.index < _labels.length) ? _labels[t.index] : 'Label ${t.index}';
//       return '$label : ${(t.score * 100).toStringAsFixed(1)}%';
//     }).join('\n');
//
//     setState(() {
//       _resultText = resultText;
//     });
//   }
//
//   bool outputTypeIsQuantized(Interpreter interpreter) {
//     final outTensor = interpreter.getOutputTensor(0);
//     final type = outTensor.type;
//     return (type == TfLiteType.uint8 || type == TfLiteType.int8);
//   }
//
//   List<_ScoreIndex> topK(List<double> scores, int k) {
//     final List<_ScoreIndex> list = [];
//     for (var i = 0; i < scores.length; i++) {
//       list.add(_ScoreIndex(i, scores[i]));
//     }
//     list.sort((a, b) => b.score.compareTo(a.score));
//     return list.take(k).toList();
//   }
//
//   @override
//   void dispose() {
//     _interpreter?.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('SmileScan (tflite)')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             if (_image != null) Image.file(_image!, height: 250),
//             if (_image == null) Container(
//               height: 250,
//               color: Colors.grey[200],
//               child: const Center(child: Text('No image selected')),
//             ),
//             const SizedBox(height: 12),
//             Text(_resultText, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera),
//                     label: const Text('Camera'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo_library),
//                     label: const Text('Gallery'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             if (!modelLoaded) const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ScoreIndex {
//   final int index;
//   final double score;
//   _ScoreIndex(this.index, this.score);
// }
