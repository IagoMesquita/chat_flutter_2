import 'package:chat_flutter/core/services/auth_services.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chat page'),
            TextButton(onPressed: AuthService().logout, child: Text('Sair'))
          ],
        ),
      ),
    );
  }
}