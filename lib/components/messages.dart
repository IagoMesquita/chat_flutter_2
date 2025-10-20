import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(decoration: BoxDecoration(color: Colors.amber), child: Text('Mensagens')));
  }
}
