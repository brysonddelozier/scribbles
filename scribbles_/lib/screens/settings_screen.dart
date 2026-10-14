import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbles/screens/main_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/Scribbles_Logo.png',
              height: 100,
            ),
            Text(
              'Settings',
              style: GoogleFonts.nanumPenScript(
                fontSize: 50,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: const Text("This is the body of settings"),
      ),
    );  
  }
}