import 'package:chat_flutter/core/models/chat_user.dart';
import 'package:chat_flutter/core/services/auth/auth_services.dart';
import 'package:chat_flutter/page/auth_page.dart';
import 'package:chat_flutter/page/chat_page.dart';
import 'package:chat_flutter/page/loading_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
    print('Init Firebase');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading para inicializacao firebase
          return LoadingPage();
        } else {
          return StreamBuilder<ChatUser?>(
            stream: AuthService().userChanges,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingPage();
              } else {
                return snapshot.hasData ? ChatPage() : AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
