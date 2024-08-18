import '../services/ai_chat_service.dart';

class ChatAiViewModel {
  final AiChatService _aiChatService = AiChatService();

  Future<String> sendMessage(String message) async {
    return await _aiChatService.sendMessage(message);
  }
}
