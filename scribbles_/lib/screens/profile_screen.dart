import 'package:flutter/material.dart';
import 'package:scribbles/screens/main_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile')
      ),
      body: Center(
        child: const Text("This is the body of profile"),
      ),
    ); 
  }
}