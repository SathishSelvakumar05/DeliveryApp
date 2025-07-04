import 'package:flutter/material.dart';
import 'PdfEmailHelper.dart';
import 'package:delivery_app/ShareApp/PDFEmailHelper.dart' as helper1;
import 'package:delivery_app/ShareApp/PdfEmailHelper.dart' as helper2;




class EmailPDFScreen extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Email Example")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Enter recipient email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Generate & Send PDF"),
              onPressed: () async {
                final file = await PDFEmailHelper.generateSimplePdf();
                await PDFEmailHelper.sendPdfEmail(emailCtrl.text.trim(), file);
              },
            )
          ],
        ),
      ),
    );
  }
}
