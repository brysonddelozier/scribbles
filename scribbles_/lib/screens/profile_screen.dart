import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../authentication.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Scribbles_Logo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 24),
                const CircleAvatar(
                  backgroundImage: AssetImage('images/pic.jpg'),
                  radius: 80,
                  child: Icon(Icons.person, size: 80),
                ),
                const SizedBox(height: 18),
                OutlinedButton(
                  onPressed: () {
                    // Handle profile picture change
                  },
                  child: const Text('Edit Profile Picture'),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Colors.black45),
                  child: const Text(
                    'Fred D',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to your profile! Here you can view and edit your personal information',
                ),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => AuthFunc(
                    loggedIn: appState.loggedIn,
                    signOut: () {
                      FirebaseAuth.instance.signOut();
                    },
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
