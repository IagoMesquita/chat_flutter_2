import 'package:chat_flutter/core/models/chat_message.dart';
import 'package:chat_flutter/core/models/chat_user.dart';
import 'package:chat_flutter/core/services/chat_mock_service.dart';

abstract class ChatService {
  Stream<List<ChatMessage>> messagesStream();
  Future<ChatMessage> save(String text, ChatUser user);

  factory ChatService() {
    return ChatMockService();
  }
}

