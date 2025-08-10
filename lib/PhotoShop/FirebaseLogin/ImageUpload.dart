import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  String? _downloadUrl;

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference ref = _storage.ref().child('uploads/$fileName.jpg');

      await ref.putFile(_image!);
      final String url = await ref.getDownloadURL();

      setState(() {
        _downloadUrl = url;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Upload Successful")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Image Upload")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 150)
                : const Icon(Icons.image, size: 150, color: Colors.grey),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _pickImage, child: const Text("Pick Image")),
            ElevatedButton(
                onPressed: _uploadImage, child: const Text("Upload Image")),
            const SizedBox(height: 20),
            _downloadUrl != null
                ? Column(
              children: [
                const Text("Uploaded Image:"),
                Image.network(_downloadUrl!, height: 150),
                Text(_downloadUrl!,
                    style: const TextStyle(fontSize: 12)),
              ],
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
