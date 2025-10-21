import 'dart:async';
import 'dart:math';

import 'package:chat_flutter/core/models/chat_message.dart';
import 'package:chat_flutter/core/models/chat_user.dart';
import 'package:chat_flutter/core/services/chat_service.dart';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [
    ChatMessage(id: '01', text: 'E ai, Ana.', createdAt: DateTime.now(), userId: '123', userName: 'Bia', userImageURL: 'assets/images/avatar.png'),
    ChatMessage(id: '02', text: 'Bom dia, Bia.', createdAt: DateTime.now(), userId: '456', userName: 'Ana', userImageURL: 'assets/images/avatar.png'),
    ChatMessage(id: '01', text: 'Bom dia. O que vamos fazer hoje?', createdAt: DateTime.now(), userId: '123', userName: 'Bia', userImageURL: 'assets/images/avatar.png'),
  ];

  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    controller.add(_msgs);
  });

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStream;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async{
    final newMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageUrl,
    );

    _msgs.add(newMessage);
    _controller?.add(_msgs);

    return newMessage;
  }
}
