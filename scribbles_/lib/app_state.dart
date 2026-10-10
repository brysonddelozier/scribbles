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
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });

    FirebaseFirestore.instance
    .collection('profiles')
    .snapshots()
    .listen((snapshot){
      // operate on profile data when updated
      Map<String, Map<String, Object>> tempData = {};
      for (final document in snapshot.docs) {
        Map<String, Object> tempProfile = {};
        tempProfile['Username'] = document.data()['Username'] as String;
        tempProfile['pfp'] = document.data()['pfp'] as String;
        tempData[document.id] = tempProfile;
      }
      Storage.data.profiles = tempData;
    });

    FirebaseFirestore.instance
    .collection('posts')
    .snapshots()
    .listen((snapshot){
      //operate on post data when updated
      Map<String, Post> tempData = {};
      for(final document in snapshot.docs){
        Post tempPost = Post(
          id: document.id,
          parentID: document.data()['parentID'],
          timeStamp: document.data()['timeStamp'],
          canvas: ScribbleCanvas.withLayers(
            layers: [
              for (var (index, layer) in document.data()['layers'])
              ScribbleLayer.withDrawing(
                palette:ColorPalette(key: layer['palette']),
                width: layer['width'] as int,
                height: layer['height'] as int,
                drawing: layer['drawing'] as List<int>,
              )
              ],
            palette: ColorPalette(key: document.data()['user']),
          ),
        );
        tempData[document.id] = tempPost;
      }
      Storage.data.posts = tempData;
    });

  }
}
