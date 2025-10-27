import 'package:chat_flutter/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatNotificationService with ChangeNotifier {
  List<ChatNotification> _items = [];

  int get itemsCount => _items.length;

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

  // Push Notifications (firebase)
  Future<void> init() async {
    _configureForeground();
    _configureBackground();
  }

  Future<bool> get _isAuthorized async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _configureForeground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessage.listen(_handleMessage);
    }
  }

  Future<void> _configureBackground() async {
    if(await _isAuthorized) {
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    }
  }



  void _handleMessage(RemoteMessage? msg) {
    if (msg == null || msg.notification == null) return;
    add(
      ChatNotification(
        title: msg.notification?.title ?? 'Não informado!',
        body: msg.notification?.body ?? '',
      ),
    );
  }
}
