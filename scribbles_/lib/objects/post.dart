import 'package:scribbles/objects/canvas.dart';

class Post{
  String id;
  String parentID;
  int timeStamp;
  ScribbleCanvas canvas;
  String user;


  Post({required this.id, required this.parentID, required this.timeStamp, required this.canvas, required this.user});
}