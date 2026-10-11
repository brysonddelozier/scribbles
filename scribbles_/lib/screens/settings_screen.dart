import 'package:flutter/material.dart';
import 'package:scribbles/screens/main_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings')
      ),
      body: Center(
        child: const Text("This is the body of settings"),
      ),
    );  
  }
}