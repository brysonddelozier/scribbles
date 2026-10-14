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
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController controller;
  String name = "";
  ApplicationState? _applicationState;
  bool _isEditingUsername = false;

  @override
  void initState() {
    super.initState();
    name = Storage.data.currentUsername() ?? "John Doe";
    controller = TextEditingController(text: name);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = context.read<ApplicationState>();
    if (_applicationState != appState) {
      _applicationState?.removeListener(_syncUsernameFromProfile);
      _applicationState = appState;
      appState.addListener(_syncUsernameFromProfile);
      _syncUsernameFromProfile();
    }
  }

  @override
  void dispose() {
    _applicationState?.removeListener(_syncUsernameFromProfile);
    controller.dispose();
    super.dispose();
  }

  void _syncUsernameFromProfile() {
    final username = Storage.data.currentUsername();
    if (!mounted ||
        _isEditingUsername ||
        username == null ||
        username == name) {
      return;
    }

    setState(() {
      name = username;
      controller.value = TextEditingValue(
        text: username,
        selection: TextSelection.collapsed(offset: username.length),
      );
    });
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
                _isEditingUsername = true;
                context.read<ApplicationState>().changeUsername(s);
                setState(() {
                  name = s;
                });
              },
              controller: controller,
            ),
            PaletteWidget(
              0,
              palette: ColorPalette(key: name),
              callback: (x) => {},
            ),
            //Expanded(child: FeedScrollableWidget(filter: PostFilter.liked)),
          ],
        ),
      ),
    );
  }
}
