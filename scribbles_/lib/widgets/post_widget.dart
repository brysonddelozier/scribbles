import 'package:scribbles/app_state.dart';
import 'package:scribbles/objects/canvas.dart';
import 'package:scribbles/objects/palette.dart';
import 'package:scribbles/objects/post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:scribbles/screens/canvas_screen.dart';
import 'package:scribbles/storage.dart';

import 'dart:math';

class PostWidget extends StatelessWidget {
  String image = 'assets/duck.png';
  Post post;

  PostWidget({super.key, required this.post});

  BoxDecoration widgetDecoration() {
    return BoxDecoration(
      border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade200)),
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
                icon: const Icon(Icons.refresh_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    useSafeArea: true,
                    builder: (context) {
                      ColorPalette palette = ColorPalette(
                        key: (Storage.data.currentUsername() ?? 'John Doe'),
                      );
                      ScribbleCanvas canvas = ScribbleCanvas.withLayers(
                        layers: post.canvas.layers,
                        palette: palette,
                      );

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
                                onPressed: () =>
                                    _onPost(context, canvas, post.id),
                                icon: const Icon(Icons.upload),
                                label: const Text('Post'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(width: 10),
              //Text(/*numReplies.toString()*/ "0"),
              SizedBox(width: 200),
              IconButton(
                icon: Icon(Icons.thumb_up, color: context.read<ApplicationState>().liked(post.id)??false ? Colors.red : Colors.white),
                onPressed: () async {
                  try {
                    await context.read<ApplicationState>().addLike(post.id);
                  } on FirebaseException catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.message ?? error.code)),
                    );
                  } on StateError catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error.message)));
                  }
                },
              ),
              //Text(/* like count */)
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onPost(
    BuildContext context,
    ScribbleCanvas canvas,
    String parentID,
  ) async {
    final appState = context.read<ApplicationState>();
    final NavigatorState navigator = Navigator.of(context);
    appState.createPost(canvas, parentID);
    navigator.pop();
  }
}
