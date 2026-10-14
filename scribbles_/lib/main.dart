import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:provider/provider.dart';
import 'package:scribbles/objects/canvas.dart';
import 'package:scribbles/objects/palette.dart';
import 'package:scribbles/screens/canvas_screen.dart';

import 'app_state.dart';

import 'package:flutter/material.dart';
import 'package:scribbles/screens/main_screen.dart';
import 'package:go_router/go_router.dart';

late ScribbleCanvas canvas;
late ScribbleLayer layer;
late ColorPalette palette;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApplicationState(),
      child: MaterialApp.router(
        title: 'Scribbles',
        theme: ThemeData.dark().copyWith(
          colorScheme: ThemeData.dark().colorScheme.copyWith(
            primary: Colors.pinkAccent,
          )
        ),
        routerConfig: _router, // new
      ),
    );
  }
}

//adding this comment as a test

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{'email': email},
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null,
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                      content: Text(
                        'Please check your email to verify your email address',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  context.pushReplacement('/');
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
      ],
    ),
  ],
);
