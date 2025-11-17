import 'dart:async';
import 'package:delivery_app/order_app/screen/view_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = "Starters";
  bool showCategoryMenu = false;
  Map<String, int> selectedItems = {}; // tracks items with quantity
  double totalAmount = 0.0;
  String currentTime = "";

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(const Duration(seconds: 30), (timer) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      currentTime = DateFormat('MMM dd, yyyy | hh:mm a').format(DateTime.now());
    });
  }

  final List<String> categories = [
    "Starters",
    "Main Course",
    "Pizza",
    "Burger",
    "Desert",
    "Bread",
    "Beverages",
    "Kids Menu",
  ];

  final List<Map<String, dynamic>> menuItems = [
    // 🥗 Starters
    {
      "category": "Starters",
      "title": "Chicken Burger Meal Combo",
      "price": 8.00,
      "oldPrice": 10.00,
      "image": "https://i.imgur.com/r7v8jzR.png"
    },
    {
      "category": "Starters",
      "title": "Crispy Chicken Wings",
      "price": 6.50,
      "oldPrice": 8.00,
      "image": "https://i.imgur.com/zYIlgBl.png"
    },
    {
      "category": "Starters",
      "title": "Garlic Bread",
      "price": 4.50,
      "oldPrice": 6.00,
      "image": "https://i.imgur.com/7P2nCBn.png"
    },
    {
      "category": "Starters",
      "title": "Cheese Balls",
      "price": 5.00,
      "oldPrice": 7.00,
      "image": "https://i.imgur.com/OT4A6Yq.png"
    },

    // 🍕 Pizza
    {
      "category": "Pizza",
      "title": "Margherita Pizza",
      "price": 12.00,
      "oldPrice": 15.00,
      "image": "https://i.imgur.com/QrVqZbT.png"
    },
    {
      "category": "Pizza",
      "title": "Pepperoni Pizza",
      "price": 14.00,
      "oldPrice": 17.00,
      "image": "https://i.imgur.com/KnM1bJW.png"
    },
    {
      "category": "Pizza",
      "title": "BBQ Chicken Pizza",
      "price": 16.00,
      "oldPrice": 18.00,
      "image": "https://i.imgur.com/3LmkK6H.png"
    },
    {
      "category": "Pizza",
      "title": "Veggie Delight Pizza",
      "price": 11.00,
      "oldPrice": 14.00,
      "image": "https://i.imgur.com/RSvZW6K.png"
    },

    // 🍔 Burger
    {
      "category": "Burger",
      "title": "Veg Supreme Burger",
      "price": 7.00,
      "oldPrice": 9.00,
      "image": "https://i.imgur.com/H2yDjf2.png"
    },
    {
      "category": "Burger",
      "title": "Cheese Burst Burger",
      "price": 9.00,
      "oldPrice": 12.00,
      "image": "https://i.imgur.com/gh6y3vU.png"
    },
    {
      "category": "Burger",
      "title": "Grilled Chicken Burger",
      "price": 10.00,
      "oldPrice": 13.00,
      "image": "https://i.imgur.com/f5y5Uwx.png"
    },
    {
      "category": "Burger",
      "title": "Paneer Tikka Burger",
      "price": 8.50,
      "oldPrice": 10.50,
      "image": "https://i.imgur.com/M4l9BQJ.png"
    },

    // 🍨 Dessert
    {
      "category": "Dessert",
      "title": "Chocolate Lava Cake",
      "price": 6.00,
      "oldPrice": 8.00,
      "image": "https://i.imgur.com/DKjS7qK.png"
    },
    {
      "category": "Dessert",
      "title": "Ice Cream Sundae",
      "price": 5.50,
      "oldPrice": 7.00,
      "image": "https://i.imgur.com/Mf3C3Pj.png"
    },
    {
      "category": "Dessert",
      "title": "Brownie with Ice Cream",
      "price": 7.00,
      "oldPrice": 9.00,
      "image": "https://i.imgur.com/7bQ0qFQ.png"
    },
    {
      "category": "Dessert",
      "title": "Fruit Tart",
      "price": 6.50,
      "oldPrice": 8.50,
      "image": "https://i.imgur.com/nfu1Izm.png"
    },

    // 🍞 Bread
    {
      "category": "Bread",
      "title": "Garlic Naan",
      "price": 3.00,
      "oldPrice": 4.00,
      "image": "https://i.imgur.com/xu7aUoV.png"
    },
    {
      "category": "Bread",
      "title": "Butter Roti",
      "price": 2.50,
      "oldPrice": 3.50,
      "image": "https://i.imgur.com/9QqZx0M.png"
    },
    {
      "category": "Bread",
      "title": "Stuffed Kulcha",
      "price": 4.00,
      "oldPrice": 5.50,
      "image": "https://i.imgur.com/l8g2yXD.png"
    },
    {
      "category": "Bread",
      "title": "Cheese Garlic Bread",
      "price": 5.00,
      "oldPrice": 6.50,
      "image": "https://i.imgur.com/CNZg1Vr.png"
    },

    // ☕ Beverages
    {
      "category": "Beverages",
      "title": "Cold Coffee",
      "price": 4.00,
      "oldPrice": 5.50,
      "image": "https://i.imgur.com/K7YzDzt.png"
    },
    {
      "category": "Beverages",
      "title": "Iced Lemon Tea",
      "price": 3.50,
      "oldPrice": 4.50,
      "image": "https://i.imgur.com/p0zPavN.png"
    },
    {
      "category": "Beverages",
      "title": "Mojito",
      "price": 4.50,
      "oldPrice": 5.50,
      "image": "https://i.imgur.com/nj5wCKg.png"
    },
    {
      "category": "Beverages",
      "title": "Milkshake",
      "price": 5.00,
      "oldPrice": 6.50,
      "image": "https://i.imgur.com/l4kGKyF.png"
    },

    // 👶 Kids Menu
    {
      "category": "Kids Menu",
      "title": "Mini Burger Meal",
      "price": 6.00,
      "oldPrice": 8.00,
      "image": "https://i.imgur.com/hmXWv7x.png"
    },
    {
      "category": "Kids Menu",
      "title": "Cheese Sandwich",
      "price": 4.50,
      "oldPrice": 6.00,
      "image": "https://i.imgur.com/N1L5VbZ.png"
    },
    {
      "category": "Kids Menu",
      "title": "Mini Fries Combo",
      "price": 3.50,
      "oldPrice": 5.00,
      "image": "https://i.imgur.com/Yx9P0hT.png"
    },
    {
      "category": "Kids Menu",
      "title": "Chocolate Donut",
      "price": 2.50,
      "oldPrice": 4.00,
      "image": "https://i.imgur.com/NPlDthL.png"
    },
  ];

  List<String> paymentModes = ["Card", "Cash", "UPI"];
  String selectedPayment = "Card";

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = menuItems
        .where((item) => item["category"] == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Menu",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            Text(currentTime,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: Colors.black54)),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: "Search...",
                    hintStyle: GoogleFonts.poppins(
                        color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  selectedCategory,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                // 👇 MENU LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final itemTitle = item["title"];
                      final quantity = selectedItems[itemTitle] ?? 0;

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item["image"],
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item["title"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          "£${item["price"].toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "£${item["oldPrice"].toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                            TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // ✅ Add / Quantity Control
                              quantity == 0
                                  ? ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedItems[itemTitle] = 1;
                                    totalAmount += item["price"];
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(0xFF6C63FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Add",style: TextStyle(color: Colors.white),),
                              )
                                  : Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        if (selectedItems[itemTitle]! >
                                            0) {
                                          selectedItems[itemTitle] =
                                              selectedItems[itemTitle]! -
                                                  1;
                                          totalAmount -= item["price"];
                                          if (selectedItems[itemTitle] ==
                                              0) {
                                            selectedItems
                                                .remove(itemTitle);
                                          }
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        selectedItems[itemTitle] =
                                            selectedItems[itemTitle]! + 1;
                                        totalAmount += item["price"];
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 👇 Footer (Cart + Payment + Total + Print)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewCartScreen(
                                cartItems: selectedItems,
                                menuItems: menuItems,
                                totalAmount: totalAmount,
                              ),
                            ),
                          );
                        },

                        child: Text("View Cart",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF6C63FF))),
                      ),
                      Row(
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
                                  style:
                                  GoogleFonts.poppins(fontSize: 13)),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text("£ ${totalAmount.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
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
                const SizedBox(height: 12),
              ],
            ),
          ),

          // 👇 Floating Category Button
          Positioned(
            bottom: 72,
            right: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(mini: true,
              backgroundColor: const Color(0xFF6C63FF),
              onPressed: () =>
                  setState(() => showCategoryMenu = !showCategoryMenu),
              child: Icon(showCategoryMenu ? Icons.close : Icons.grid_view_rounded,
                  color: Colors.white),
            ),
          ),

          // 👇 Category Popup Overlay
          if (showCategoryMenu)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showCategoryMenu = false),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return ListTile(
                            title: Text(category,
                                style: GoogleFonts.poppins(fontSize: 14)),
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                                showCategoryMenu = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
