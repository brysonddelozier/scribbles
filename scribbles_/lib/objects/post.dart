import 'package:scribbles/objects/canvas.dart';

class Post{
  String id;
  String parentID;
  int timeStamp;
  ScribbleCanvas canvas;


  Post({required this.id, required this.parentID, required this.timeStamp, required this.canvas});
}