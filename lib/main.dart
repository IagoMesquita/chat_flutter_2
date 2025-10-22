import 'package:chat_flutter/core/services/notification/chat_notification_service.dart';
import 'package:chat_flutter/page/auth_or_app_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatNotificationService(),
          ),
      ],
      child: MaterialApp(
        title: 'Chat Flutter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: AuthOrAppPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
