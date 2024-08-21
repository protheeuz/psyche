import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_strings.dart';
import '../services/ai_chat_service.dart';

class ChatAiScreen extends StatefulWidget {
  const ChatAiScreen({super.key});

  @override
  _ChatAiScreenState createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final AiChatService _aiChatService = AiChatService();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _loadChatHistory();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatHistory = _messages.map((message) {
      return "${message['sender']}|${message['message']}";
    }).toList();
    await prefs.setStringList('chat_history', chatHistory);
  }

  Future<void> _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chatHistory = prefs.getStringList('chat_history');
    if (chatHistory != null) {
      setState(() {
        _messages.addAll(chatHistory.map((message) {
          var parts = message.split('|');
          return {"sender": parts[0], "message": parts[1]};
        }).toList());
      });
    }
  }

  void _sendMessage() async {
    String userMessage = _controller.text;
    setState(() {
      _messages.add({"sender": "Kamu", "message": userMessage});
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();
    _saveChatHistory();

    try {
      String aiResponse = await _aiChatService.sendMessage(userMessage);
      setState(() {
        _isTyping = false;
        _messages.add({"sender": "Asisten Psyche", "message": aiResponse});
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add({"sender": "Error", "message": "Gagal berkomunikasi dengan AI. Detail: $e"});
      });
    }

    _scrollToBottom();
    _saveChatHistory();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildMessage(Map<String, String> messageData) {
    bool isUser = messageData["sender"] == "Kamu";
    bool isAi = messageData["sender"] == "Asisten Psyche";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser ? Colors.greenAccent[400] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: _buildFormattedText(messageData["message"] ?? ''),
          ),
          const SizedBox(height: 2),
          Text(
            messageData["sender"] ?? 'Asisten Psyche',
            style: TextStyle(
              fontSize: 10,
              color: isUser ? Colors.green[800] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedText(String message) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r'\*\*(.*?)\*\*'); // regex buat handle ketika ada chat ** dari gemini utk dibuat bold
    int start = 0;

    for (final match in exp.allMatches(message)) {
      if (match.start > start) {
        spans.add(TextSpan(text: message.substring(start, match.start)));
      }
      spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold))); // bold teks nya
    }

    if (start < message.length) {
      spans.add(TextSpan(text: message.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: spans,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animationController.value,
                      child: child,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Asisten Psyche sedang mengetik...",
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(AppStrings.chatAIWelcome),
        backgroundColor: Colors.green[600],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                } else {
                  return _buildMessage(_messages[index]);
                }
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
                    decoration: InputDecoration(
                      hintText: 'Ngobrol sekarang',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
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