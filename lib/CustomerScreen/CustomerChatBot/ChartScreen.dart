import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rxdart/rxdart.dart';

class CustomerChatScreen extends StatefulWidget {
  final String userId; // Google UID
  const CustomerChatScreen({required this.userId, super.key});

  @override
  State<CustomerChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<CustomerChatScreen> {
  final TextEditingController controller = TextEditingController();
  final String ADMIN_ID = "admin-001";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat with Admin")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: listenMessages(widget.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];

                    final bool isMe = msg['sender_id'] == widget.userId;

                    return Align(
                      alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['message'] ?? "",
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Text Box and Send Button
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Type a message...",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    sendMessage(controller.text.trim(), widget.userId);
                    controller.clear();
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  // 🔥 MERGED STREAM FOR CHAT (NO ERRORS)
  Stream<List<Map<String, dynamic>>> listenMessages(String userId) {
    final supabase = Supabase.instance.client;

    final stream = supabase
        .from('message')
        .stream(primaryKey: ['id'])
        .asBroadcastStream();

    return stream.map((messages) => messages.where((m) =>
    (m['sender_id'] == userId && m['receiver_id'] == ADMIN_ID) ||
        (m['sender_id'] == ADMIN_ID && m['receiver_id'] == userId)
    ).toList()
    ).map((list) {
      list.sort((a, b) => DateTime.parse(a['created_at'])
          .compareTo(DateTime.parse(b['created_at'])));
      return list;
    });
  }

  // 🔥 SEND MESSAGE (USER → ADMIN)
  Future<void> sendMessage(String text, String userId) async {
    final supabase = Supabase.instance.client;

    await supabase.from('message').insert({
      'sender_id': userId,
      'receiver_id': ADMIN_ID,
      'message': text,
    });
  }

  // 🔥 ADMIN REPLY (ADMIN → USER)
  Future<void> adminReply(String text, String userId) async {
    final supabase = Supabase.instance.client;

    await supabase.from('message').insert({
      'sender_id': ADMIN_ID,
      'receiver_id': userId,
      'message': text,
    });
  }
}
