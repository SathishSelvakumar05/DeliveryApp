import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' hide PdfDocument;
import 'package:pdf_render/pdf_render.dart';
import 'package:path_provider/path_provider.dart';

class RedactionHelper {
  static const MethodChannel _channel = MethodChannel('pdf_password_channel');

  static final Map<String, RegExp> _sensitivePatterns = {
    // Bank account numbers: 8–18 digits, but only if preceded by keywords like "Account" etc.
    'bank_account': RegExp(
      r'\b(?:Account\s*No\.?|Account\s*Number|Acct\.?|A/c)\b[:\s\-]*\d{8,18}\b',
    ),

    // Generic 16-digit card numbers (e.g., 1234-5678-9012-3456 or 1234567890123456)
    'card_16': RegExp(
      r'\b(?:\d{4}[-\s]?){3}\d{4}\b',
    ),

    // IFSC Code — only when followed by valid IFSC pattern
    // 'IFSC': RegExp(
    //   r'\bIFSC\b[:\s\-]*[A-Z]{4}0[0-9A-Z]{6}\b',
    // ),
    'IFSC': RegExp(
         r'\b(?:IFSC[\s:\-]*|[A-Z]{4}0[0-9A-Z]{6})\b',
      caseSensitive: false,
    ),


    // Phone number — block only if a valid number format appears
    // 'phone': RegExp(
    //   r'\b(?:\+?\d{1,3}[\-\s]?)?(?:\d{3}[\-\s]?\d{3}[\-\s]?\d{4}|\d{10})\b',
    // ),
    // Phone number — detects if preceded by keywords like "Phone", "Ph.", etc.
    'phone': RegExp(
      r'\b(?:Phone|Ph|Ph\.|Ph\s*No\.?|Phone\s*No\.?|Phone\s*Number)\b[:\s\-]*'
      r'(?:\+?\d{1,3}[\s\-]?)?(?:\d{3}[\s\-]?\d{3}[\s\-]?\d{4}|\d{10})\b',
      caseSensitive: false,
    ),


    // Email — standard valid email addresses
    'email': RegExp(
      r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b',
    ),

    // Address — only if typical address words + numbers pattern appear
    'address': RegExp(
      r'\b\d{1,5}\s+(?:[A-Za-z0-9]+\s){0,6}(?:Street|St|Road|Rd|Avenue|Ave|Lane|Ln|Boulevard|Blvd|Square|Sq|Block|Sector|Colony|Apartment|Apt|Floor)\b',
    ),
  };

  static Future<File> redactFile(File inputFile, {String? password}) async {
    final ext = inputFile.path.split('.').last.toLowerCase();

    if (ext == 'pdf') {
      final safeFile = await tryDecryptIfNeeded(inputFile, password: password);
      return _processPdfForRedaction(safeFile);
    } else {
      return _processImageForRedaction(inputFile);
    }
  }

  static Future<bool> isPdfPasswordProtected(File pdfFile) async {
    try {
      print('hiiiiiiiiiiiiiiiiiiiiiiii');
      final doc = await PdfDocument.openFile(pdfFile.path);
      await doc.dispose();
      return false;
    } catch (e) {
      print('hellooooooooooooooooooooooooo');

      final msg = e.toString().toLowerCase();
      if (msg.contains('password') ||
          msg.contains('encrypted') ||
          msg.contains('fail') ||
          msg.contains('cannot open')) {
        return true;
      }
      rethrow;
    }
  }

  static Future<File> tryDecryptIfNeeded(File pdfFile,
      {String? password}) async {
    final isProtected = await isPdfPasswordProtected(pdfFile);

    print("isProtected");
    print(isProtected);
    print(isProtected);
    print(isProtected);
    print(isProtected);
    if (!isProtected) return pdfFile;

    if (password == null || password.isEmpty) {
      throw Exception("PDF is password-protected. Please provide a password.");
    }

    final decrypted = await decryptPdf(pdfFile, password);
    if (decrypted == null) {
      throw Exception("Failed to decrypt PDF with provided password.");
    }

    return decrypted;
  }

  static Future<File?> decryptPdf(File encryptedFile, String password) async {
    try {
      final String decryptedPath = await _channel.invokeMethod(
        'decryptPdf',
        {
          'filePath': encryptedFile.path,
          'password': password,
        },
      );
      print("decryptedPath");
      print(decryptedPath);
      print(decryptedPath);
      print(decryptedPath);
      if (decryptedPath.isNotEmpty) {
        return File(decryptedPath);
      }
    } catch (e) {
      print('ddddddddddddddd');
      debugPrint('Decryption failed: $e');
    }
    return null;
  }

  static Future<File> _processImageForRedaction(File imageFile) async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await textRecognizer.processImage(inputImage);
    final originalImage = img.decodeImage(await imageFile.readAsBytes())!;

    bool hasRedactions = false;

    for (final block in recognizedText.blocks) {
      final text = block.text;
      for (final entry in _sensitivePatterns.entries) {
        if (entry.value.hasMatch(text)) {
          hasRedactions = true;
          final rect = block.boundingBox;
          img.fillRect(
            originalImage,
            x1: rect.left.toInt(),
            y1: rect.top.toInt(),
            x2: rect.right.toInt(),
            y2: rect.bottom.toInt(),
            color: img.ColorRgb8(0, 0, 0),
          );
        }
      }
    }

    final tempDir = await getTemporaryDirectory();
    final redactedPath =
        '${tempDir.path}/redacted_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // ✅ If no sensitive text found, just return the original image
    final outputImage = hasRedactions
        ? originalImage
        : img.decodeImage(await imageFile.readAsBytes())!;
    final redactedFile = File(redactedPath)
      ..writeAsBytesSync(img.encodePng(outputImage));

    await textRecognizer.close();
    return redactedFile;
  }

  static Future<File> _processPdfForRedaction(File pdfFile) async {
    PdfDocument doc;
    try {
      doc = await PdfDocument.openFile(pdfFile.path);
    } catch (e) {
      rethrow;
    }

    final pdf = pw.Document();

    for (int i = 1; i <= doc.pageCount; i++) {
      final page = await doc.getPage(i);
      const dpi = 150;
      final scale = dpi / 72.0;

      final targetWidth = (page.width * scale).toInt();
      final targetHeight = (page.height * scale).toInt();

      final pageImage =
      await page.render(width: targetWidth, height: targetHeight);
      final rgbaBytes = pageImage.pixels;
      final width = pageImage.width;
      final height = pageImage.height;

      final pageImg = img.Image.fromBytes(
        width: width,
        height: height,
        bytes: rgbaBytes.buffer,
        order: img.ChannelOrder.rgba,
      );

      final tempDir = await getTemporaryDirectory();
      final imgFile = File('${tempDir.path}/page_$i.png');
      await imgFile.writeAsBytes(img.encodePng(pageImg));

      final redactedImage = await _processImageForRedaction(imgFile);
      final bytes = await redactedImage.readAsBytes();

      if (bytes.isEmpty) continue;

      pdf.addPage(
        pw.Page(
          pageFormat:
          PdfPageFormat(page.width.toDouble(), page.height.toDouble()),
          build: (context) =>
              pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.fill),
        ),
      );
    }

    final tempDir = await getTemporaryDirectory();
    final output = File('${tempDir.path}/redacted_output.pdf');
    await output.writeAsBytes(await pdf.save());
    await doc.dispose();

    return output;
  }
}
