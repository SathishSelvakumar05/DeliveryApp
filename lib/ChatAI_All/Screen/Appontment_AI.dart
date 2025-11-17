import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../../gen_ai/GenAI_Screen.dart' hide Message;
import '../Widget/Button_Component.dart';
import '../Widget/InitialChatWidget.dart';
import '../Widget/SendButtonwidget.dart';
import '../Widget/enumClass.dart';

class AppointmentChatScreen extends StatefulWidget {
  const AppointmentChatScreen({Key? key}) : super(key: key);
  @override
  State<AppointmentChatScreen> createState() => _AppointmentChatScreenState();
}

class _AppointmentChatScreenState extends State<AppointmentChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  final openAIKey = dotenv.env["OPENAI_SECRETKEY"]!;

  ChatMode _currentMode = ChatMode.none;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String? _selectedLocation;
  String? _selectedComplaint;
  String? _description;
  bool isLocationDropDown = false;
  bool isComplaintDropDown = false;

  final List<PreferredTime> _timeSlots = [
    PreferredTime(time: "Morning (09:00 - 13:00)", value: "morning"),
    PreferredTime(time: "Afternoon (13:00 - 17:00)", value: "afternoon"),
    PreferredTime(time: "Evening (17:00 - 21:00)", value: "evening"),
  ];

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
  List laaaa = List.generate(
    66,
    (index) => index,
  ).toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Smart Clinic Assistant'),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _currentMode == ChatMode.none ? 1 : _messages.length,
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  print("index start from");
                  print(index);
                  // show initial mode selection (Chat with AI / Appointment / etc.)
                  if (_currentMode == ChatMode.none &&
                      index == _messages.length) {
                    return buildModeSelection();
                  }

                  final message = _messages[_messages.length - 1 - index];
                  // final message = _messages[index];
                  print("12121");
                  print("${message.text}");

                  final isLastMsg = index == 0; // because ListView is reversed

                  return buildMessage(
                    message,
                    isLastMsg: isLastMsg,
                  );
                },
              )),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CupertinoActivityIndicator(),
            ),
          buildInputBar(),
          // 🔽 Dropdown suggestion box
          if (filteredList.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filteredList.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey[300]),
                itemBuilder: (context, index) {
                  final suggestion = filteredList[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      isLocationDropDown
                          ? Icons.location_on_outlined
                          : Icons.healing_outlined,
                      color: Colors.teal,
                    ),
                    title: Text(
                      suggestion,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      _controller.text = suggestion;
                      filteredList.clear();
                      setState(() {});

                      // 👇 Automatically handle selection
                      // handleUserInput(suggestion);
                    },
                  );
                },
              ),
            ),
          if (_currentMode != ChatMode.none)
            SendButtonComponent(
              controller: _controller,
              onChanged: (value) {
                handleDropDown(
                  value,
                  isLocationDropDown,
                  isLocationDropDown || isComplaintDropDown,
                );
              },
              onpressed: () {
                bool canSend = isComplaintDropDown || isLocationDropDown;
                print("true or false");
                print("$isComplaintDropDown");
                print("$isLocationDropDown");
                print("${_selectedDate != null}");
                print("${_selectedTimeSlot != null}");
                bool Send = _currentMode == ChatMode.none ||
                        _currentMode == ChatMode.chatAI
                    ? true
                    : _currentMode == ChatMode.freeTeleConsultation
                        ? _selectedDate != null && _selectedTimeSlot != null
                        : (_selectedDate != null && _selectedTimeSlot != null);
                Send ? handleUserInput(_controller.text) : null;
              },
            ),
        ],
      ),
    );
  }

  // ------------------- MESSAGE UI ----------------------
  Widget buildMessage(Message message, {required bool isLastMsg}) {
    final isAI = !message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Align(
        alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isAI ? Colors.white : Colors.blue.shade600,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(isAI ? 0 : 14),
                bottomRight: Radius.circular(isAI ? 14 : 0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
              border: isAI
                  ? Border.all(color: Colors.blueGrey.withOpacity(0.2))
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isAI)
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.smart_toy,
                            color: Colors.blueAccent, size: 16),
                      ),
                    if (isAI) const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isAI ? Colors.black87 : Colors.white,
                          fontSize: 15,
                          height: 1.4,
                          fontWeight: isAI ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isAI && isLastMsg)
                      GestureDetector(
                        onTap: resetConversation,
                        child: Container(
                          margin: const EdgeInsets.only(left: 6, top: 2),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent.withOpacity(0.1),
                          ),
                          child: const Icon(Icons.close,
                              size: 14, color: Colors.redAccent),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------- MODE SELECTION ----------------------
  Widget buildModeSelection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("👋 Hi! What would you like to do today?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                InitialChatWidget(
                  icon: Icons.smart_toy_outlined,
                  title: "Chat with AI",
                  onTap: () {
                    setState(() => _currentMode = ChatMode.chatAI);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Started Chat with AI 🤖")),
                    );
                  },
                ),
                const Divider(height: 0),
                InitialChatWidget(
                  icon: Icons.health_and_safety_outlined,
                  title: "Medical Assistant with AI",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => HealthAssistantScreen()),
                    );
                  },
                ),
                const Divider(height: 0),
                InitialChatWidget(
                  icon: Icons.calendar_today,
                  title: "Book Appointment",
                  onTap: () {
                    setState(
                        () => _currentMode = ChatMode.freeTeleConsultation);
                    askDate();
                  },
                ),
                const Divider(height: 0),
                InitialChatWidget(
                  icon: Icons.local_hospital_outlined,
                  title: "Clinic Consultation",
                  onTap: () {
                    setState(() => _currentMode = ChatMode.clinicConsultation);
                    askDate();
                  },
                ),
                const Divider(height: 0),
                InitialChatWidget(
                  icon: Icons.local_hospital_rounded,
                  title: "Free Scaling Consultation",
                  onTap: () {
                    setState(
                        () => _currentMode = ChatMode.freeScalingConsultation);
                    askDate();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ------------------- CHAT INPUT BAR ----------------------
  Widget buildInputBar() {
    // Date picker for freeTeleConsultation/clinicConsultation
    if (_currentMode != ChatMode.chatAI &&
        _selectedDate == null &&
        _currentMode != ChatMode.none) {
      return ProButton(
        text: "Select Date",
        icon: Icons.date_range,
        color: Colors.teal,
        onPressed: pickDate,
      );
    }

    // Time slot selection
    if ((_currentMode == ChatMode.freeTeleConsultation ||
            _currentMode == ChatMode.clinicConsultation ||
            _currentMode == ChatMode.freeScalingConsultation) &&
        _selectedDate != null &&
        _selectedTimeSlot == null) {
      return Wrap(
        spacing: 8,
        alignment: WrapAlignment.center,
        children: _timeSlots.map((slot) {
          return ProButton(
            text: slot.time,
            isOutlined: true,
            icon: Icons.date_range,
            color: Colors.teal,
            textColors: Colors.black,
            onPressed: () => selectTimeSlot(slot),
          );
        }).toList(),
      );
    }

    // Submit button after all fields done
    if (_currentMode == ChatMode.freeTeleConsultation &&
        _selectedDate != null &&
        _selectedTimeSlot != null &&
        _description != null) {
      return ProButton(
        text: "Submit",
        icon: Icons.save,
        color: Colors.teal,
        onPressed: submitAppointment,
      );
    }

    if (_currentMode == ChatMode.clinicConsultation &&
        _selectedDate != null &&
        _selectedTimeSlot != null &&
        _selectedLocation != null &&
        _selectedComplaint != null &&
        _description != null) {
      return ProButton(
        text: "Submit",
        icon: Icons.save,
        color: Colors.teal,
        onPressed:(){ submitConsultation( isClinicConsultation: _currentMode == ChatMode.clinicConsultation);},
      );

    }


    // Normal text input
    return SizedBox();
  }

  // ------------------- LOGIC HANDLERS ----------------------

  void handleUserInput(String input) {
    final text = input.trim();
    if (text.isEmpty) return;
    _controller.clear();

    if (_currentMode == ChatMode.chatAI) {
      sendMessage(text);
      return;
    }

    _messages.add(Message(text, true));

    if (_currentMode == ChatMode.freeTeleConsultation) {
      if (_description == null) {
        _description = text;
        _messages.add(Message("Appointment details noted ✅", false));
      }
    } else if (_currentMode == ChatMode.clinicConsultation ||
        _currentMode == ChatMode.freeScalingConsultation) {
      if (_selectedLocation == null) {
        _selectedLocation = text;
        isLocationDropDown = false;

        // _selectedLocation = suggestFromList(text, myLocations);
        askComplaint();
      } else if (_selectedComplaint == null) {
        _selectedComplaint = text;
        isComplaintDropDown = false;
        // _selectedComplaint = suggestFromList(text, complaints);
        askDescription();
      } else if (_description == null) {
        _description = text;
        _messages.add(Message(
            _currentMode == ChatMode.freeScalingConsultation
                ? "Free Scaling Consultation details noted ✅"
                : "Clinic Consultation details noted ✅",
            false));
      }
    }
    setState(() {});
  }

  void askDate() {
    _messages.add(Message("Please select your preferred date 🗓️", false));
    setState(() {});
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _messages.add(Message(
            "Selected date: ${picked.toLocal().toString().split(' ')[0]}",
            true));
      });
      askTimeSlot();
    }
  }

  void askTimeSlot() {
    _messages.add(Message("Choose a preferred time slot ⏰", false));
    setState(() {});
  }

  void selectTimeSlot(
    PreferredTime slot,
  ) {
    _selectedTimeSlot = slot.value;
    _messages.add(Message("Selected time: ${slot.time}", true));

    if (_currentMode == ChatMode.freeTeleConsultation) {
      askDescription();
    } else if (_currentMode == ChatMode.clinicConsultation ||
        _currentMode == ChatMode.freeScalingConsultation) {
      askLocation();
    }
    setState(() {});
  }

  void askLocation() {
    _messages.add(Message("Please enter your location 🏙️", false));
    setState(() {
      isLocationDropDown = true;
    });
  }

  void askComplaint() {
    _messages.add(Message("Please describe your primary complaint 🩺", false));
    setState(() {
      isComplaintDropDown = true;
    });
  }

  void askDescription() {
    _messages.add(Message("Please enter a short description 📝", false));
    setState(() {});
  }

  String suggestFromList(String input, List<String> list) {
    return list.firstWhere(
      (item) => item.toLowerCase().contains(input.toLowerCase()),
      orElse: () => input,
    );
  }

  void resetConversation() {
    setState(() {
      print("happen");
      _messages.clear();
      _controller.clear();
      _isLoading = false;
      _currentMode = ChatMode.none;
      _selectedDate = null;
      _selectedTimeSlot = null;
      _selectedLocation = null;
      _selectedComplaint = null;
      _description = null;
      isLocationDropDown = false;
      isComplaintDropDown = false;
    });
  }

  void submitAppointment() {
    // final DateFormat inputDateFormat = DateFormat("d-M-y");

    final String? preferredDate = _selectedDate != null
        ? DateFormat("yyyy-MM-dd").format(_selectedDate!)
        : null;
    Map<String, dynamic> requestData = {
      "from_date": preferredDate,
      "to_date": preferredDate,
      // "preferred_location": locationController.text.toString(),
      "patient_id": "userId",
      "slot_time": {
        // "from": timeFromController.text,
        // "to": timeToController.text,
      },
      "preferred_time": _selectedTimeSlot?? "",
      "request_type": "free_request",
      "primary_complaint": [],
      // "notes": complaintDescriptionController.text.toString(),
      "referral_status": "pending",
    };
    print("---- Appointment Submitted ----");
    print("${requestData}");
    // print("Date: $_selectedDate");
    // print("Time: $_selectedTimeSlot");
    // print("Description: $_description");
    _messages.add(Message("✅ Appointment booked successfully!", false));
    setState(() {});
  }

  void submitConsultation({required bool isClinicConsultation}) {
    final String? preferredDate = _selectedDate != null
        ? DateFormat("yyyy-MM-dd").format(_selectedDate!)
        : null;
    final int? complaintId = 1;
    // final int? complaintIds = getSelectedComplaintId();

    Map<String, dynamic> requestData = {
      "from_date": preferredDate,
      "to_date": preferredDate,
      "preferred_location": _selectedLocation.toString(),
      "patient_id": "userId",
      "slot_time": {
        "from": "",
        "to": "",
        // "to": timeToController.text,
      },
      "preferred_time": _selectedTimeSlot?? "",
      "primary_complaint": [complaintId],
      "notes": _selectedComplaint.toString(),
      "referral_status": "pending",
      "request_type":
      isClinicConsultation
          ? "appointment_request"
          : "free_scaling_request",
    };

    print("---- Consultation Submitted ----");
    print("$requestData");
    // print("Date: $_selectedDate");
    // print("Time: $_selectedTimeSlot");
    // print("Location: $_selectedLocation");
    // print("Complaint: $_selectedComplaint");
    // print("Description: $_description");
    _messages.add(
        Message("✅ Clinic clinicConsultation booked successfully!", false));
    setState(() {});
  }

  // ------------------- AI CHAT ----------------------
  Future<void> sendMessage(String prompt) async {
    setState(() {
      _messages.add(Message(prompt, true));
      _isLoading = true;
      print("now the messages ${_messages.last.text}");
    });

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openAIKey',
    };

    final body = jsonEncode({
      "model": "gpt-4o-mini",
      "messages": [
        {"role": "user", "content": prompt}
      ],
      "max_tokens": 150,
      "temperature": 0.7,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        setState(() {
          _messages.add(Message(reply, false));
        });
      } else {
        setState(() {
          _messages.add(Message("Error: ${response.body}", false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message("Error: $e", false));
      });
    } finally {
      setState(() {
        _controller.text = '';
        _isLoading = false;
      });
    }
  }

  List<String> filteredList = [];

  void handleDropDown(
      String value, bool isLocationDropDown, bool isNeedDropDown) {
    if (!isNeedDropDown) {
      setState(() => filteredList = []);
      return;
    }

    final dataSource = isLocationDropDown ? myLocations : complaints;

    setState(() {
      filteredList = dataSource
          .where((item) => item.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
}
