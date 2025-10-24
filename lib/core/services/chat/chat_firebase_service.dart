import 'dart:async';

import 'package:chat_flutter/core/models/chat_message.dart';
import 'package:chat_flutter/core/models/chat_user.dart';
import 'package:chat_flutter/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirestoreService implements ChatService {
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {});

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return Stream<List<ChatMessage>>.empty();
  }

  // Enviando uma model ChatMessage -> Map<String, dynamic> do firestore
  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageUrl,
    );

    final docRef = await store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore) // Jã faz a conversao. Depois prefiro fazer usando direto no model.
        .add(msg);

    final docSnapshot = await docRef.get();
    return docSnapshot.data()!;
  }

  // Map<String, dynamic> (firestore) => ChatMessage (objeto dart)
  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'] ?? 'unknown',
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'] ?? 'userId',
      userName: doc['userName'] ?? 'unknown',
      userImageURL: doc['userImageURL'],
    );
  }

  Map<String, dynamic> _toFirestore(ChatMessage msg, SetOptions? options) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageULR': msg.userImageURL,
    };
  }
}
