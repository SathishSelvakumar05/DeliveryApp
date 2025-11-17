import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendButtonComponent extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onpressed;

  const SendButtonComponent({super.key,required this.controller,required this.onChanged,required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
              color: Colors.black38, offset: Offset(0, 2), blurRadius: 6)
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child:Column(
                children: [
                  TextField(
                    // enabled: _currentMode!=ChatMode.none,
                    controller: controller,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    cursorColor: Colors.tealAccent,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.white70.withOpacity(0.7)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                    ),
                    onChanged: onChanged,
                    //     (value) {
                    //   handleDropDown(
                    //     value,
                    //     isLocationDropDown,
                    //     isLocationDropDown || isComplaintDropDown,
                    //   );
                    // },
                  ),

                ],
              )
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.tealAccent.shade400),
            onPressed: onpressed,
            //     () {
            //   bool canSend=isComplaintDropDown||isLocationDropDown;
            //   print("true or false");
            //   print("$isComplaintDropDown");
            //   print("$isLocationDropDown");
            //   print("${_selectedDate!=null}");
            //   print("${_selectedTimeSlot!=null}");
            //   bool Send=_currentMode==ChatMode.none||_currentMode==ChatMode.chatAI?true:_currentMode==ChatMode.freeTeleConsultation?_selectedDate!=null&&_selectedTimeSlot!=null:(_selectedDate!=null&&_selectedTimeSlot!=null);
            //   Send?
            //   handleUserInput(_controller.text):null;
            // },
          ),
        ],
      ),
    );
  }
}
//
// Container(
// padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// decoration: BoxDecoration(
// color: Colors.blueGrey.shade800,
// borderRadius: BorderRadius.circular(24),
// boxShadow: const [
// BoxShadow(
// color: Colors.black38, offset: Offset(0, 2), blurRadius: 6)
// ],
// ),
// child: Row(
// children: [
// Expanded(
// child: Column(
// children: [
// TextField(
// // enabled: _currentMode!=ChatMode.none,
// controller: _controller,
// style: const TextStyle(color: Colors.white, fontSize: 15),
// cursorColor: Colors.tealAccent,
// decoration: InputDecoration(
// hintText: 'Type your message...',
// hintStyle:
// TextStyle(color: Colors.white70.withOpacity(0.7)),
// border: InputBorder.none,
// contentPadding: const EdgeInsets.symmetric(
// vertical: 0, horizontal: 14),
// ),
// onChanged: (value) {
// handleDropDown(
// value,
// isLocationDropDown,
// isLocationDropDown || isComplaintDropDown,
// );
// },
// ),
// ],
// )),
// IconButton(
// icon: Icon(Icons.send, color: Colors.tealAccent.shade400),
// onPressed: () {
// bool canSend = isComplaintDropDown || isLocationDropDown;
// print("true or false");
// print("$isComplaintDropDown");
// print("$isLocationDropDown");
// print("${_selectedDate != null}");
// print("${_selectedTimeSlot != null}");
// bool Send = _currentMode == ChatMode.none ||
// _currentMode == ChatMode.chatAI
// ? true
//     : _currentMode == ChatMode.freeTeleConsultation
// ? _selectedDate != null && _selectedTimeSlot != null
//     : (_selectedDate != null &&
// _selectedTimeSlot != null);
// Send ? handleUserInput(_controller.text) : null;
// },
// ),
// ],
// ),
// )
