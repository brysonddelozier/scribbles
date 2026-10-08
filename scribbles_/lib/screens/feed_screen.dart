import 'package:flutter/material.dart';
import 'package:scribbles/screens/main_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed')
      ),
      body: Center(
        child: const Text("This is the body of feed"),
      ),
    );
  }
}