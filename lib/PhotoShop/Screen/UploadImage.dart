import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'single_photo_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  File? _selectedImage;
  bool _loading = false;

  final picker = ImagePicker();
  final supabase = Supabase.instance.client;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadData() async {
    if (_selectedImage == null || _priceController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select image, enter price & description")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
print("1");
      // Upload to Supabase Storage
      await supabase.storage.from('supabase-bucket').upload(fileName, _selectedImage!);
      print("2");

      // Get public URL
      final imageUrl = supabase.storage.from('supabase-bucket').getPublicUrl(fileName);
      print("3");

      // Insert into "photos" table
      await supabase.from('photos').insert({
        'image_url': imageUrl,
        'price': _priceController.text,
        'description': _descController.text,
      });
      print("4");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Uploaded Successfully")),
      );

      _priceController.clear();
      _descController.clear();
      setState(() => _selectedImage = null);

    } catch (e) {
      print("error");
      print("${e}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Photo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _uploadData,
              child: _loading ? const CircularProgressIndicator() : const Text("Upload"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SinglePhotoScreen()),
              ),
              child: const Text("View Uploaded Photos"),
            )
          ],
        ),
      ),
    );
  }
}
