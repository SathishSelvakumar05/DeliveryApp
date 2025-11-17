import 'package:flutter/material.dart';

class DynamicDropdownField extends StatefulWidget {
  final bool isLocationDropDown;
  final bool isNeedDropDown;
  final void Function({
      required bool isLocation,
      required String input,
      })
  onClick;
  final void Function({required String text})onSubmit;
  const DynamicDropdownField({
    Key? key,
    required this.isLocationDropDown,
    required this.isNeedDropDown,
    required this.onClick,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<DynamicDropdownField> createState() => _DynamicDropdownFieldState();
}

class _DynamicDropdownFieldState extends State<DynamicDropdownField> {
  final TextEditingController _controller = TextEditingController();

  final List<String> myLocations = [
    "Chennai",
    "Coimbatore",
    "Madurai",
    "Trichy",
    "Salem"
  ];

  final List<String> complaints = [
    "Fever",
    "Cough",
    "Headache",
    "Body Pain",
    "Cold"
  ];

  List<String> filteredList = [];

  void handleDropDown(String value) {
    if (!widget.isNeedDropDown) {
      widget.onSubmit(text: value);
      setState(() => filteredList = []);
      return;
    }

    final List<String> baseList =
    widget.isLocationDropDown ? myLocations : complaints;

    setState(() {
      filteredList = baseList
          .where((item) =>
      item.toLowerCase().contains(value.toLowerCase()) && value.isNotEmpty)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("filteredList.isNotEmpty");
    print("${widget.isLocationDropDown}");
    print("${filteredList.isNotEmpty}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🟩 Show dropdown list dynamically
        if (filteredList.isNotEmpty)...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return ListTile(
                  title: Text(item, style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    widget.onClick(input: item,isLocation: widget.isLocationDropDown);
                    _controller.text = item;
                    setState(() => filteredList.clear());
                  },
                );
              },
            ),
          ),
        ],

        TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          cursorColor: Colors.tealAccent,
          decoration: InputDecoration(
            hintText: 'Type your message...',
            hintStyle: TextStyle(color: Colors.white70.withOpacity(0.7)),
            border: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
          ),
          onChanged: handleDropDown,
        ),


      ],
    );
  }
}
