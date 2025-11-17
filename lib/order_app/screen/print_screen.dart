import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class BillHelper {
  static Future<void> generateAndPrintBill({
    required double subTotal,
    required double tax,
    required double serviceCharge,
    required double total,
    required BuildContext context,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("emzo POS", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Text("Subtotal: Rs.${subTotal.toStringAsFixed(2)}"),
                  pw.Text("Tax: Rs.${tax.toStringAsFixed(2)}"),
                  pw.Text("Service Charges: Rs.${serviceCharge.toStringAsFixed(2)}"),
                  pw.Divider(),
                  pw.Text("Total: Rs.${total.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      );

      // Show preview & print
      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      print("puja ka");
      print("${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error printing bill: $e")),
      );
    }
  }

  static Future<void> saveBillLocally({
    required double subTotal,
    required double tax,
    required double serviceCharge,
    required double total,
    required BuildContext context,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("EnExpense Bill", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Text("Subtotal: ₹${subTotal.toStringAsFixed(2)}"),
                  pw.Text("Tax: ₹${tax.toStringAsFixed(2)}"),
                  pw.Text("Service Charges: ₹${serviceCharge.toStringAsFixed(2)}"),
                  pw.Divider(),
                  pw.Text("Total: ₹${total.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 30),
                  pw.Text("Generated on ${DateTime.now()}"),
                ],
              ),
            );
          },
        ),
      );

      final outputDir = await getApplicationDocumentsDirectory();
      final file = File("${outputDir.path}/Bill_${DateTime.now().millisecondsSinceEpoch}.pdf");

      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bill saved at: ${file.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving bill: $e")),
      );
    }
  }
}