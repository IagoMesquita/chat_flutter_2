import 'package:chat_flutter/components/messages.dart';
import 'package:chat_flutter/components/new_message.dart';
import 'package:chat_flutter/core/models/chat_notification.dart';
import 'package:chat_flutter/core/services/auth/auth_services.dart';
import 'package:chat_flutter/core/services/notification/chat_notification_service.dart';
import 'package:chat_flutter/page/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int itemsCount = Provider.of<ChatNotificationService>(
      context,
    ).itemsCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cod3r Chat', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return NotificationPage();
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  maxRadius: 10,
                  backgroundColor: Colors.red.shade800,
                  child: Text(
                    '$itemsCount',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Message()),
            NewMessages(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ChatNotificationService>(context, listen: false).add(
            ChatNotification(
              title: 'Teste',
              body: 'Essa é uma mensagem de teste, para testar a nitificação.',
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
