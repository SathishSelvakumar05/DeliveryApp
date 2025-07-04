import 'dart:io';
import 'dart:typed_data';
import 'package:delivery_app/Components/CustomToast/CustomToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

class PDFEmailHelper {
  static Future<File> generateSimplePdf() async {
    final pdf = pw.Document();
    //
    // final ByteData bytes = await rootBundle.load('assets/images/logo.jpg'); // <-- Use your own image
    // final Uint8List imageBytes = bytes.buffer.asUint8List();
    // final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Column(
              children: [
                // pw.Image(image, width: 100),
                pw.SizedBox(height: 20),
                pw.Text('Sample Expense Report',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Date: ${DateTime.now()}'),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['S.No', 'Item', 'Amount'],
                  data: [
                    ['1', 'Groceries', '200.00'],
                    ['2', 'Rent', '1200.00'],
                    ['3', 'Transport', '150.00'],
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/report.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> sendPdfEmail(String recipientEmail, File file) async {
    final smtpServer = gmail('sathishselvakumar05@gmail.com', 'piwtcympsavawjzi');

    final message = Message()
      ..from = Address('sathishselvakumar55@gmail.com', 'Expense Reporter')
      ..recipients.add(recipientEmail)
      ..subject = 'Your PDF Report'
      ..text = 'Attached is your generated PDF report.'
      ..attachments.add(FileAttachment(file)
      );

    try {
      await send(message, smtpServer);
      showSuccessToast("Mail Sent Successfully");
      print('Email sent!');
    } catch (e) {
      print('Email failed: $e');
    }
  }
}
