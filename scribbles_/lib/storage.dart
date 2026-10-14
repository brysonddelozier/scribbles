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
  List<Post> _sortedPosts;
  List<Post> get sortedPosts{
    return _sortedPosts;
  }
  set sortedPosts(Map<String, Post> map){
    List<Post> tempList = map.values.toList();
    tempList.sort((a, b) => (b.timeStamp.compareTo(a.timeStamp)),);
    _sortedPosts = tempList;
  }

  String? currentUserID;
  bool loggedIn;

  String? currentUsername(){
    return profiles[currentUserID]?.username;
  }

  int? currentButtonColor(){
    return profiles[currentUserID]?.buttonColor;
  }
  

  DataHolder():profiles = Map(), posts = Map(), loggedIn = false, _sortedPosts = [];
}