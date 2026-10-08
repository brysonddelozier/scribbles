import 'package:flutter/material.dart';
import 'package:scribbles/screens/main_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages')
      ),
      body: Center(
        child: const Text("This is the body of messages"),
      ),
    );  
  }
}