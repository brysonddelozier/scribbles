import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:scribbles/objects/canvas.dart';

class Layer {
  final Canvas canvas;

  Layer({required this.canvas});

  void setPixel(int x, int y) {
    canvas.setPixel(x, y);
  }

  int getPixel(int x, int y) {
    return canvas.getPixel(x, y);
  }
}
