import 'package:scribbles/objects/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribbles/screens/canvas_screen.dart';

class PostWidget extends StatelessWidget {
  String image = 'assets/duck.png';
  Post post;

  PostWidget({super.key, required this.post});

  BoxDecoration widgetDecoration() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1, color: Colors.grey.shade200),
      ),
    );
  }

  BoxDecoration imageDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1, color: Colors.grey.shade200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widgetDecoration(),
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            decoration: imageDecoration(),
            child: CanvasWidget(canvas: post.canvas),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chat_outlined),
                onPressed: () {
                  numReplies += 1;
                }
              ),
              SizedBox(width: 10),
              Text(numReplies.toString()),
              SizedBox(width: 200),
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  numLikes += 1;
                }
              ),
              SizedBox(width: 10),
              Text(numLikes.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
