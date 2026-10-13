import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribbles/objects/canvas.dart';
import 'package:scribbles/objects/palette.dart';
import 'package:scribbles/screens/canvas_screen.dart';

import 'package:scribbles/screens/main_screen.dart';
import 'package:scribbles/storage.dart';
import 'package:scribbles/widgets/post_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFixedExtentList(
            itemExtent: 400.0,
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return Container(
                alignment: Alignment.center,
                child: PostWidget(post: Storage.data.posts,),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) {
              ColorPalette palette = ColorPalette(
                key:
                    Storage.data.profiles[Storage
                            .data
                            .currentUserID]!["username"]
                        as String,
              );
              ScribbleCanvas canvas = ScribbleCanvas(palette, 1024, 1024);

              return Center(
                child: Column(
                  children: [
                    CanvasScreen(canvas: canvas, palette: palette),
                    FilledButton.icon(
                      onPressed: () {
                        _onPost(canvas);
                      },
                      icon: Icon(Icons.plus_one),
                      label: const Text("Post"),
                    ),
                  ],
                ),
              );
            },
          );
        },
        label: const Icon(Icons.add),
      ),
    );
  }

  void _onPost(ScribbleCanvas canvas) {}
}
