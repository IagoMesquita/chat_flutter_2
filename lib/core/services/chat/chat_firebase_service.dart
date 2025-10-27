import 'dart:async';

import 'package:chat_flutter/core/models/chat_message.dart';
import 'package:chat_flutter/core/models/chat_user.dart';
import 'package:chat_flutter/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirestoreService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;
    final snapshotChat = store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshotChat.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });

    // (Prefiro essa)Abordagem mais explicita de conversao de  QuerySnapshot<ChatMessage> para List<ChatMessage>  
    // return Stream<List<ChatMessage>>.multi((controller) {
    //   snapshotChat.listen((snapshot) {
    //     final List<ChatMessage> list = snapshot.docs.map((doc) {
    //       return doc.data();
    //     }).toList();
    //   });
    // });
  }

  // Enviando uma model ChatMessage -> Map<String, dynamic> do firestore
  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    // Como optou por save enviar apenas um text, temos que montar a estrutura do ChatMessage antes
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
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        ) // Jã faz a conversao. Depois prefiro fazer usando direto no model.
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
      'userImageURL': msg.userImageURL,
    };
  }
}
