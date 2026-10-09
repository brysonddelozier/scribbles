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
late ColorPalette palette;

void main() async {
  palette = ColorPalette(key: "lukespeer");
  canvas = ScribbleCanvas(palette, 1024, 1024);

  ScribbleLayer layer = ScribbleLayer(
    palette: palette,
    width: 1024,
    height: 1024,
  );

  canvas.addLayer(layer);

  for (int x = 0; x < 1024; x++) {
    for (int y = 0; y < 1024; y++) {
      canvas.layer.setPixel(x, y, 4);
      layer.setPixel(x, y, 7);
    }
  }

  canvas.redraw();

  runApp(TestCanvas());
}

class TestCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CanvasScreen(canvas: canvas, palette: palette),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApplicationState(),
      child: MaterialApp.router(
        title: 'Scribbles',
        theme: ThemeData(
          buttonTheme: Theme.of(context).buttonTheme
              .copyWith(highlightColor: Colors.pinkAccent),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          visualDensity: VisualDensity.adaptivePlatformDensity,
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
