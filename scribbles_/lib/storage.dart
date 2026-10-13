import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:scribbles/objects/post.dart';
import 'package:scribbles/objects/user.dart';

import 'firebase_options.dart';




class Storage {
  static DataHolder data = DataHolder();

  Storage(){}
}

class DataHolder{
  Map<String, ScribbleUser> profiles;
  Map<String, Post> posts;
  String? currentUserID;
  bool loggedIn;
  

  DataHolder():profiles = Map(), posts = Map(), loggedIn = false;
}