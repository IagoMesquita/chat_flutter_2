import 'package:chat_flutter/core/models/chat_user.dart';
import 'package:chat_flutter/core/services/auth_mock_service.dart';
import 'package:chat_flutter/page/auth_page.dart';
import 'package:chat_flutter/page/chat_page.dart';
import 'package:chat_flutter/page/loading_page.dart';
import 'package:flutter/material.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ChatUser?>(
        stream: AuthMockService().userChanges,
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();
          } else {
            return snapshot.hasData ? ChatPage() : AuthPage();
          }
        },
      ),
    );
  }
}
