import 'package:flutter/material.dart';

class NewMessages extends StatelessWidget {
  const NewMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: Text('Nova Mensagem'),
      ),
    );
  }
}
