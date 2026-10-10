import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scribbles/objects/canvas.dart';
import 'package:scribbles/objects/palette.dart';
import 'package:scribbles/objects/post.dart';

import 'firebase_options.dart';
import 'storage.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    unawaited(init());
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _profilesSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _postsSubscription;
  bool _disposed = false;

  Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

      _authSubscription = FirebaseAuth.instance.userChanges().listen(
        (user) {
          _loggedIn = user != null;
          notifyListeners();
        },
        onError: (Object error, StackTrace stackTrace) {
          _reportError('Authentication', error, stackTrace);
        },
      );

      _profilesSubscription = FirebaseFirestore.instance
          .collection('profiles')
          .snapshots()
          .listen(
            (snapshot) {
              try {
                final tempData = <String, Map<String, Object>>{};
                for (final document in snapshot.docs) {
                  final data = document.data();
                  tempData[document.id] = {
                    'Username': data['Username'] as String,
                    'pfp': data['pfp'] as String,
                  };
                }
                Storage.data.profiles = tempData;
              } catch (error, stackTrace) {
                _reportError('Profiles data', error, stackTrace);
              }
            },
            onError: (Object error, StackTrace stackTrace) {
              _reportError('Profiles', error, stackTrace);
            },
          );

      _postsSubscription = FirebaseFirestore.instance
          .collection('posts')
          .snapshots()
          .listen(
            (snapshot) {
              try {
                final tempData = <String, Post>{};
                for (final document in snapshot.docs) {
                  final data = document.data();
                  final tempPost = Post(
                    id: document.id,
                    parentID: data['parentID'],
                    timeStamp: data['timeStamp'],
                    canvas: ScribbleCanvas.withLayers(
                      layers: [
                        for (final layer in data['layers'])
                          ScribbleLayer.withDrawing(
                            palette: ColorPalette(key: layer['palette']),
                            width: layer['width'] as int,
                            height: layer['height'] as int,
                            drawing: layer['drawing'] as List<int>,
                          ),
                      ],
                      palette: ColorPalette(key: data['user']),
                    ),
                  );
                  tempData[document.id] = tempPost;
                }
                Storage.data.posts = tempData;
              } catch (error, stackTrace) {
                _reportError('Posts data', error, stackTrace);
              }
            },
            onError: (Object error, StackTrace stackTrace) {
              _reportError('Posts', error, stackTrace);
            },
          );
    } catch (error, stackTrace) {
      _reportError('Firebase initialization', error, stackTrace);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _reportError(String source, Object error, StackTrace stackTrace) {
    if (_disposed) return;

    final detail = error is FirebaseException
        ? error.message ?? error.code
        : error.toString();
    _errorMessage = '$source: $detail';
    debugPrint('$_errorMessage\n$stackTrace');
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_authSubscription?.cancel());
    unawaited(_profilesSubscription?.cancel());
    unawaited(_postsSubscription?.cancel());
    super.dispose();
  }
}
