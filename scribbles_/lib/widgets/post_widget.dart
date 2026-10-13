import 'package:scribbles/objects/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatelessWidget {
  String image = 'assets/duck.png';
  Post post;

  PostWidget({super.key, required this.post});

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      border: Border.all(
        width: 1,
        color: Colors.grey.shade200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      child: Column(
        children: [
          Container(
            decoration: boxDecoration(),
            child: Image.asset(image),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.thumb_up),
              Text(post.likeCount.toString()),
            ],
          ),
        ],
      ),
    );
  }
}