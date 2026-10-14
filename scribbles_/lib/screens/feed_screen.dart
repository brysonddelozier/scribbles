import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbles/app_state.dart';
import 'package:scribbles/main.dart';
import 'package:scribbles/objects/canvas.dart';
import 'package:scribbles/objects/palette.dart';
import 'package:scribbles/screens/canvas_screen.dart';
import 'package:scribbles/storage.dart';
import 'package:scribbles/widgets/post_widget.dart';

import 'dart:math';

class FeedScreen extends StatefulWidget {
  FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Future<void> _futurePosts = Future.value();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _futurePosts = Provider.of<ApplicationState>(context, listen: false).future;
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = Storage.data.currentButtonColor() ?? 0xFFEB585A;
    Provider.of<ApplicationState>(context, listen: false).callback = () {
      setState(() {});
    };
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Text('Scribbles', style: GoogleFonts.nanumPenScript(fontSize: 50)),
            Image.asset(
              'assets/Scribbles_Logo.png',
              height: 100,
            ),
            Text('Feed', style: GoogleFonts.nanumPenScript(fontSize: 50)),
          ],
        ),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          return FutureBuilder(
            future: _futurePosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (Storage.data.posts.isEmpty) {
                  return const Center(
                    child: Text('No posts yet', style: TextStyle(fontSize: 18)),
                  );
                }

                return const FeedScrollableWidget();
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        },
        //appBar: AppBar(title: const Text('Feed')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(buttonColor),
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
              ScribbleCanvas canvas = ScribbleCanvas(palette, 256, 256);

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
                        onPressed: () => {
                          _onPost(context, canvas),
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text('Post'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Color(buttonColor),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Back'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(buttonColor),
                            foregroundColor: Colors.white,
                          ),
                        ),
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
    appState.createPost(canvas, 'original');
    navigator.pop();
  }
}

enum PostFilter { all, liked, parentID }

class FeedScrollableWidget extends StatefulWidget {
  const FeedScrollableWidget({
    super.key,
    this.filter = PostFilter.all,
    this.parentID,
  });

  final PostFilter filter;
  final String? parentID;

  @override
  State<StatefulWidget> createState() {
    return _FeedScrollableWidgetState();
  }
}

class _FeedScrollableWidgetState extends State<FeedScrollableWidget> {
  @override
  Widget build(BuildContext context) {
    final posts = Storage.data.sortedPosts;
    final appState = context.read<ApplicationState>();
    final localPosts = switch (widget.filter) {
      PostFilter.all => posts,
      PostFilter.liked =>
        posts.where((post) => appState.liked(post.id) ?? false).toList(),
      PostFilter.parentID =>
        posts.where((post) => post.parentID == widget.parentID).toList(),
    };

    return CustomScrollView(
      scrollCacheExtent: ScrollCacheExtent.pixels(5000),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            final post = localPosts[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: PostWidget(post: post),
            );
          }, childCount: localPosts.length),
        ),
      ],
    );
  }
}
