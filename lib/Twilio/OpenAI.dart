import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chat_dialog_flow/MainChatScreen.dart';



class OpenAIScreen extends StatelessWidget {
  // Your OpenAI API key here
  static const openAIKey = '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';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'OpenAI Chatbot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChatScreen(apiKey: openAIKey),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String apiKey;

  ChatScreen({required this.apiKey});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class Message {
  final String text;
  final bool isUser;

  Message(this.text, this.isUser);
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  Future<void> sendMessage(String prompt) async {
    setState(() {
      _messages.add(Message(prompt, true));
      _isLoading = true;
    });
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    print("1");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.apiKey}',
    };

    final body = jsonEncode({
      "model": "gpt-4o-mini", // You can use "gpt-3.5-turbo" or others
      "messages": [
        {"role": "user", "content": prompt}
      ],
      "max_tokens": 150,
      "temperature": 0.7,
    });
    print("2");

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("3");
        final data = jsonDecode(response.body);
        print("${data.toString()}");
        final reply = data['choices'][0]['message']['content'];
        setState(() {
          _messages.add(Message(reply, false));
        });
        print("${reply}");
      } else {
        print("noo");
        print("${response.body}");
        setState(() {
          _messages.add(Message("Error: ${response.body}", false));
        });
      }
    } catch (e) {
      print("$e");
      setState(() {
        _messages.add(Message("Error: $e", false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget buildMessage(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue.shade100 : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OpenAI Chatbot'),actions: [ Padding(
        padding: const EdgeInsets.only(right: 16),
        child: GestureDetector(
          onTap: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => DialogFlowChat(),));          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.skip_next,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),],),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                reverse: true,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return buildMessage(message);
                },
              )),
          if (_isLoading) Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    cursorColor: Colors.tealAccent,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.white70.withOpacity(0.7)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        sendMessage(value.trim());
                        _controller.clear();
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.shade400,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.shade400.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        sendMessage(text);
                        _controller.clear();
                      }
                    },
                    icon: const Icon(Icons.send, size: 20),
                    color: Colors.blueGrey.shade900,
                    splashRadius: 22,
                    tooltip: 'Send message',
                  ),
                ),
              ],
            ),
          )


          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: _controller,
          //           decoration:
          //           InputDecoration(hintText: 'Type your message here...'),
          //           onSubmitted: (value) {
          //             if (value.trim().isNotEmpty) {
          //               sendMessage(value.trim());
          //               _controller.clear();
          //             }
          //           },
          //         ),
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.send),
          //         onPressed: () {
          //           final text = _controller.text.trim();
          //           if (text.isNotEmpty) {
          //             sendMessage(text);
          //             _controller.clear();
          //           }
          //         },
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
