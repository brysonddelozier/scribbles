import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:scribbles/screens/main_screen.dart';
import 'package:scribbles/widgets/post_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed')
      ),
      body: CustomScrollView(
        slivers: <Widget> [
          SliverFixedExtentList(
            itemExtent: 400.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  child: PostWidget(id: index, image: 'assets/duck.png'),
                );
              },
            ), 
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Icon(Icons.add),
      ),
    );
  }
}