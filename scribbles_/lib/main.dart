import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'package:flutter/material.dart';
import 'package:scribbles/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scribbles",
      home: MainScreen(),
    );
  }
}

//adding this comment as a test