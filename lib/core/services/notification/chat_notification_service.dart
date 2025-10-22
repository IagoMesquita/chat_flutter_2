import 'package:chat_flutter/core/models/chat_notification.dart';
import 'package:flutter/material.dart';

class ChatNotificationService with ChangeNotifier {
  List<ChatNotification> _items = [];

  List<ChatNotification> get items {
    return [..._items];
  }

  void add(ChatNotification notificaion) {
    _items.add(notificaion);
    notifyListeners();
  }

  void remove(int i) {
    _items.removeAt(i);
    notifyListeners();
  }
}
