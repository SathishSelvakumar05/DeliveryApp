import 'package:delivery_app/order_app/screen/print_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewCartScreen extends StatefulWidget {
  final Map<String, int> cartItems;
  final List<Map<String, dynamic>> menuItems;
  final double totalAmount;

  const ViewCartScreen({
    super.key,
    required this.cartItems,
    required this.menuItems,
    required this.totalAmount,
  });

  @override
  State<ViewCartScreen> createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends State<ViewCartScreen> {
  late Map<String, int> selectedItems;
  late double totalAmount;
  String selectedPayment = "Card";
  List<String> paymentModes = ["Card", "Cash", "UPI"];

  @override
  void initState() {
    super.initState();
    selectedItems = Map.from(widget.cartItems);
    totalAmount = widget.totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cartMenu = widget.menuItems
        .where((item) => selectedItems.containsKey(item["title"]))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("View Cart",
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: Text("Add Items",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Total items: ${selectedItems.length}",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: cartMenu.length,
                itemBuilder: (context, index) {
                  final item = cartMenu[index];
                  final quantity = selectedItems[item["title"]] ?? 0;

                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item["image"],
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item["title"],
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(
                                  "Addons: ketchup, fries, coke",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "£ ${item["price"].toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        if (selectedItems[item["title"]]! > 0) {
                                          selectedItems[item["title"]] =
                                              selectedItems[item["title"]]! - 1;
                                          totalAmount -= item["price"];
                                          if (selectedItems[item["title"]] == 0) {
                                            selectedItems.remove(item["title"]);
                                          }
                                        }
                                      });
                                    },
                                  ),
                                  Text(quantity.toString(),
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline,
                                        color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        selectedItems[item["title"]] =
                                            selectedItems[item["title"]]! + 1;
                                        totalAmount += item["price"];
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever,
                                color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                totalAmount -=
                                (item["price"] * selectedItems[item["title"]]!);
                                selectedItems.remove(item["title"]);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Summary Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow("Sub Total", "£ ${totalAmount.toStringAsFixed(2)}"),
                _buildSummaryRow("Tax", "£ 100"),
                _buildSummaryRow("Service Charges", "£ 50"),
                const Divider(thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green)),
                    Text(
                        "£ ${(totalAmount + 150).toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Payment Options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: paymentModes.map((mode) {
                return Row(
                  children: [
                    Radio<String>(
                      value: mode,
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() => selectedPayment = value!);
                      },
                      activeColor: const Color(0xFF6C63FF),
                    ),
                    Text(mode,
                        style: GoogleFonts.poppins(fontSize: 13)),
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 6),
            ElevatedButton.icon(
              onPressed: () {
                BillHelper.generateAndPrintBill(
                  subTotal: 500.0,
                  tax: 45.0,
                  serviceCharge: 20.0,
                  total: 565.0,
                  context: context,
                );
              },
              icon: const Icon(Icons.print, color: Colors.white),
              label: Text("Print Bill",
                  style: GoogleFonts.poppins(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: Colors.grey[700])),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
