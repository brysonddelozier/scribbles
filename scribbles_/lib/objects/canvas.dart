import 'package:flutter/material.dart';
import 'package:scribbles/objects/palette.dart';

class ScribbleLayer {
  final ColorPalette palette;
  final List<int> drawing;
  final int width;
  final int height;

  ScribbleLayer({
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
  // DO NOT CHANGE ANY OF THIS
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

class MergedLayer {
  final int width;
  final int height;
  final List<Color> colors;

  MergedLayer({required this.width, required this.height})
    : colors = List.filled(width * height, Colors.white);

  void setPixel(int x, int y, Color color) {
    colors[(y * width) + x];
  }

  Color getPixel(int x, int y) {
    return colors[(y * width) + x];
  }
}

class ScribbleCanvas {
  final MergedLayer cache;
  final ScribbleLayer layer;
  final ColorPalette palette;
  final List<ScribbleLayer> layers;

  ScribbleCanvas(ColorPalette palette, int width, int height)
    : layers = List.empty(growable: true),
      palette = palette,
      layer = ScribbleLayer(palette: palette, width: width, height: height),
      cache = MergedLayer(width: width, height: height) {
    layers.add(layer);
  }
  ScribbleCanvas.withLayers({
    required this.layers,
    required this.palette,
    int width = 1024,
    int height = 1024,
  }) : layer = ScribbleLayer(palette: palette, width: width, height: height),
       cache = MergedLayer(width: width, height: height) {
    layers.add(layer);
  }

  Color getColor(int x, int y) {
    ScribbleLayer bottom = layers[0];
    Color color = bottom.getPixel(x, y);
    double r = color.r, g = color.g, b = color.b;

    for (int i = 1; i < layers.length; i++) {
      Color col = layers[i].getPixel(x, y);

      r = (col.r + r) * 0.5;
      g = (col.g + g) * 0.5;
      b = (col.b + b) * 0.5;
    }

    return Color.from(alpha: 1.0, red: r, green: g, blue: b);
  }

  void addLayer(ScribbleLayer layer) {
    layers.add(layer);
  }

  void redraw() {
    for (int x = 0; x < layer.width; x++) {
      for (int y = 0; y < layer.width; y++) {
        cache.setPixel(x, y, getColor(x, y));
      }
    }
  }
}
