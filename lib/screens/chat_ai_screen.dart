import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../services/ai_chat_service.dart';

class ChatAiScreen extends StatefulWidget {
  const ChatAiScreen({super.key});

  @override
  _ChatAiScreenState createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> {
  final TextEditingController _controller = TextEditingController();
  final AiChatService _aiChatService = AiChatService();
  final List<String> _messages = [];

  void _sendMessage() async {
    String userMessage = _controller.text;
    setState(() {
      _messages.add("You: $userMessage");
      _controller.clear();
    });

    try {
      String aiResponse = await _aiChatService.sendMessage(userMessage);
      setState(() {
        _messages.add("AI: $aiResponse");
      });
    } catch (e) {
      setState(() {
        _messages.add("Error: Failed to communicate with AI");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.chatAIWelcome),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}