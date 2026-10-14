import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbles/screens/main_screen.dart';
import 'package:scribbles/objects/palette.dart';
import 'package:scribbles/widgets/palette_widget.dart';
import 'package:scribbles/storage.dart';
import '../app_state.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:provider/provider.dart';
import '../authentication.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<StatefulWidget> {
  late final TextEditingController controller;
  String name = "";
  ApplicationState? _applicationState;
  String buttonColor = "";

  @override
  void initState() {
    super.initState();
    name = Storage.data.currentUsername() ?? "John Doe";
    buttonColor = Storage.data.currentButtonColor() ?? "0xFFEB585A";
  }

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
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              "Select a color for buttons and highlights!",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            PaletteWidget(
              0,
              palette: ColorPalette(key: name),
              callback: (x) => {},
            ),
          ],
        ),
      ),
    );  
  }
}