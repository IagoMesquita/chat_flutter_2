import 'package:chat_flutter/components/message_bubble.dart';
import 'package:chat_flutter/core/models/chat_message.dart';
import 'package:chat_flutter/core/services/auth/auth_services.dart';
import 'package:chat_flutter/core/services/chat/chat_service.dart';
import 'package:chat_flutter/page/loading_page.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;

    return StreamBuilder<List<ChatMessage>>(
      stream: ChatService().messagesStream(),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else if (!snapShot.hasData || snapShot.data!.isEmpty) {
          return Center(child: Text('Sem mensagens. Vamos conversar?'));
        } else {
          final msgs = snapShot.data!;

          return ListView.builder(
            itemCount: msgs.length,
            itemBuilder: (ctx, i) => MessageBubble(
              key: ValueKey(msgs[i].id),
              message: msgs[i],
              belongsToCurrentUser: currentUser?.id == msgs[i].userId,
            ),
            reverse: true,
          );
        }
      },
    );
  }
}
