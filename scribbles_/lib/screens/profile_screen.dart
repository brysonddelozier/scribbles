import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbles/objects/palette.dart';
import 'package:scribbles/storage.dart';
import 'package:scribbles/widgets/palette_widget.dart';

import '../app_state.dart';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:provider/provider.dart';

import '../authentication.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController? controller;
  String name = "";

  @override
  void initState() {
    name = Storage.data.currentUsername()!;
    controller = TextEditingController(text: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Scribbles', style: GoogleFonts.nanumPenScript(fontSize: 50)),
            Text('Profile', style: GoogleFonts.nanumPenScript(fontSize: 50)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("This is the body of profile"),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ),
            TextField(
              onChanged: (s) {
                context.read<ApplicationState>().changeUsername(s);
                setState(() {
                  name = s;
                });
              },
              controller: controller,
            ),
            PaletteWidget(
              0,
              palette: ColorPalette(
                key: Storage.data.currentUsername() ?? "John Doe",
              ),
              callback: (x) => {},
            ),
          ],
        ),
      ),
    );
  }
}
