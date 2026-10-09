import 'package:flutter/material.dart';
import 'package:scribbles/objects/palette.dart';

class ScribbleCanvas {
  final ColorPalette palette;
  final List<int> drawing;
  final int width;
  final int height;

  ScribbleCanvas({
    required this.palette,
    required this.width,
    required this.height,
  }) : drawing = List<int>.filled((width * height + 7) ~/ 8, 0);

  Color getPixel(int x, int y) {
    int index = this.index(x, y);
    int value = drawing[(index >> 3)]; // this is / 8
    int shift =
        (index & 7) <<
        2; // this is a mask that we shift over * 4 for the size of each color

    return palette.colors[(value >> shift) & 0xF];
  }

  // index in palette
  void setPixel(int x, int y, int colorIndex) {
    int index = this.index(x, y);
    int posIndex = index >> 3;
    int shift = (index & 7) << 2;
    int mask = 0xF << shift;

    drawing[posIndex] =
        (drawing[index] & ~mask) | ((colorIndex & 0xF) << shift);
  }

  int index(int x, int y) {
    return (y * width) + x;
  }

  Map toMap() {
    return {'width': width, 'height': height, 'drawing': drawing};
  }
}
