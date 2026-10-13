import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribbles/app_state.dart';
import 'package:scribbles/main.dart';
import 'package:scribbles/objects/canvas.dart';
import 'package:scribbles/objects/palette.dart';
import 'package:scribbles/screens/canvas_screen.dart';
import 'package:scribbles/storage.dart';
import 'package:scribbles/widgets/post_widget.dart';

import 'dart:math';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          return FutureBuilder(
            future: appState.future,
            builder: (context, snapshot) {
              final posts = Storage.data.sortedPosts;

              if (posts.isEmpty) {
                return const Center(
                  child: Text('No posts yet', style: TextStyle(fontSize: 18)),
                );
              }

              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      final post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        child: PostWidget(post: post),
                      );
                    }, childCount: posts.length),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          /*showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) {
              ColorPalette palette = ColorPalette(
                key: (Storage.data.currentUsername() ?? 'John Doe'),
              );
              ScribbleCanvas canvas = ScribbleCanvas(palette, 1024, 1024);

              return Center(
                child: Column(
                  children: [
                    CanvasScreen(canvas: canvas, palette: palette),
                    FilledButton.icon(
                      onPressed: () => _onPost(context, canvas),
                      icon: const Icon(Icons.plus_one),
                      label: const Text('Post'),
                    ),
                  ],
                ),
              );
            },
          );*/

          showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) {
              ColorPalette palette = ColorPalette(
                key: (Storage.data.currentUsername() ?? 'John Doe'),
              );
              ScribbleCanvas canvas = ScribbleCanvas(palette, 1000, 1000);

              // Get the device screen size to make the dialog responsive
              final screenSize = MediaQuery.of(context).size;
              final dialogSize = min(
                screenSize.width * 0.85,
                screenSize.height * 0.85,
              );

              return Dialog(
                // Prevents the background alert container from expanding infinitely
                child: SizedBox(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: Stack(
                    children: [
                      CanvasScreen(canvas: canvas, palette: palette),
                      FilledButton.icon(
                        onPressed: () => _onPost(context, canvas),
                        icon: const Icon(Icons.plus_one),
                        label: const Text('Post'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          /*ColorPalette palette = ColorPalette(
            key: (Storage.data.currentUsername() ?? 'John Doe'),
          );
          ScribbleCanvas canvas = ScribbleCanvas(palette, 1024, 1024);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CanvasScreen(canvas: canvas, palette: palette),
            ),
          );*/
        },
        label: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onPost(BuildContext context, ScribbleCanvas canvas) async {
    final appState = context.read<ApplicationState>();
    final NavigatorState navigator = Navigator.of(context);
    appState.createPost(canvas);
    navigator.pop();
  }
}
