import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';

import '../Components/CustomToast/CustomToast.dart' as Fluttertoast;
import 'helper.dart';

class PdfCheckScreen extends StatefulWidget {
  const PdfCheckScreen({super.key});

  @override
  State<PdfCheckScreen> createState() => _PdfCheckScreenState();
}

class _PdfCheckScreenState extends State<PdfCheckScreen> {
  File? file;
  bool isLoading = false;

  /// Pick file -> decrypt if needed -> redact
  Future<void> fileUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf", "jpg", "jpeg", "png"],
      );

      if (result == null || result.files.single.path == null) return;
      File selectedFile = File(result.files.single.path!);

      setState(() => isLoading = true);

      // Check if PDF is password-protected
      bool passwordProtected = false;
      String ext = selectedFile.path.split('.').last.toLowerCase();
      if (ext == "pdf") {
        try {
          passwordProtected =
          await RedactionHelper.isPdfPasswordProtected(selectedFile);
        } catch (e) {
          passwordProtected = false;
        }
      }

      String? password;
      if (passwordProtected) {
        final controller = TextEditingController();
        password = await showCupertinoDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CupertinoAlertDialog(
                title: const Text("Enter PDF Password",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                content: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: CupertinoTextField(
                    controller: controller,
                    placeholder: "Password",
                    obscureText: true,
                    clearButtonMode: OverlayVisibilityMode.editing,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () =>
                        Navigator.pop(context, controller.text.trim()),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          },
        );

        if (password == null || password.isEmpty) {
          Fluttertoast.showToast("Password required to open file");
          setState(() => isLoading = false);
          return;
        }

        final decryptedFile =
        await RedactionHelper.decryptPdf(selectedFile, password);
        if (decryptedFile != null) {
          selectedFile = decryptedFile;
        } else {
          Fluttertoast.showToast("Incorrect password or failed decryption");
          setState(() => isLoading = false);
          return;
        }
      }

      // Perform redaction (your helper)
      final redactedFile =
      await RedactionHelper.redactFile(selectedFile, password: password);

      setState(() {
        file = redactedFile;
        isLoading = false;
      });

      Fluttertoast.showToast("Redaction complete ✅");
    } catch (e) {
      Fluttertoast.showToast("Error: $e");
      setState(() => isLoading = false);
    }
  }

  /// Render preview widgets (use RawImage for PDF pages)
  Future<List<Widget>> _renderPreviewImages(File file) async {
    final ext = file.path.split('.').last.toLowerCase();

    if (ext == 'pdf') {
      final doc = await PdfDocument.openFile(file.path);
      final List<Widget> pages = [];

      try {
        for (int i = 1; i <= doc.pageCount; i++) {
          final page = await doc.getPage(i);
          final pageImage = await page.render(
            width: page.width.toInt(),
            height: page.height.toInt(),
          );

          // ✅ Create Flutter Image safely
          final ui.Image flutterImage =
          await pageImage.createImageIfNotAvailable();

          // ✅ Convert ui.Image → independent MemoryImage
          final byteData =
          await flutterImage.toByteData(format: ui.ImageByteFormat.png);
          final Uint8List bytes = byteData!.buffer.asUint8List();

          // Now you can safely dispose the pageImage
          pageImage.dispose();

          // ✅ Use MemoryImage — completely safe to reuse in RawImage
          pages.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.memory(bytes, fit: BoxFit.contain),
            ),
          );
        }
      } finally {
        await doc.dispose();
      }

      return pages;
    } else {
      return [Image.file(file, fit: BoxFit.contain)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Redaction Preview")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : file == null
            ? ElevatedButton(
          onPressed: fileUpload,
          child: const Text("UPLOAD PDF OR IMAGE"),
        )
            : FutureBuilder<List<Widget>>(
          future: _renderPreviewImages(file!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Text("No preview available");
            } else {
              final pages = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemCount: pages.length,
                      itemBuilder: (context, index) => SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: pages[index],
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload Another File"),
                    onPressed: fileUpload,
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
