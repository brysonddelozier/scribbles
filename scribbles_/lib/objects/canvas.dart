import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scribbles/objects/palette.dart';

import 'dart:ui' as ui;

class ScribbleLayer {
  final ColorPalette palette;
  final List<int> drawing;
  final int width;
  final int height;

  ScribbleLayer({
    required this.palette,
    required this.width,
    required this.height,
  }) : drawing = List<int>.filled((width * height) ~/ 16, 0);
  ScribbleLayer.withDrawing({
    required this.palette,
    required this.width,
    required this.height,
    required this.drawing,
  });

  Color getPixel(int x, int y) {
    return palette.colors[getPixelIndex(x, y)];
  }

  int getPixelIndex(int x, int y) {
    int index = this.index(x, y);
    int value = drawing[index >> 4]; // divide by 16
    int shift = (index & 15) << 2; // 4 bits per pixel

    return ((value >> shift) & 0xF);
  }

  // index in palette
  // DO NOT CHANGE ANY OF THIS
  void setPixel(int x, int y, int colorIndex) {
    int index = this.index(x, y);
    int posIndex = index >> 4;
    int shift = (index & 15) << 2;
    int mask = 0xF << shift;

    drawing[posIndex] =
        (drawing[posIndex] & ~mask) | ((colorIndex & 0xF) << shift);
  }

  int index(int x, int y) {
    return (y * width) + x;
  }

  Map toMap() {
    return {
      'palette': palette.key,
      'width': width,
      'height': height,
      'drawing': drawing,
    };
  }
}

class MergedLayer {
  final int width;
  final int height;
  final Uint8List colors;

  MergedLayer({required this.width, required this.height})
    : colors = Uint8List(width * height * 4);

  void setPixel(int x, int y, Color color) {
    int pos = ((y * width) + x) * 4;
    colors[pos] = (color.r * 255.0).round().clamp(0, 255);
    colors[pos + 1] = (color.g * 255.0).round().clamp(0, 255);
    colors[pos + 2] = (color.b * 255.0).round().clamp(0, 255);
    colors[pos + 3] = (color.a * 255.0).round().clamp(0, 255);
  }

  Color getPixel(int x, int y) {
    int pos = (y * width) + x;
    return Color.fromARGB(
      colors[pos + 3],
      colors[pos],
      colors[pos + 1],
      colors[pos + 2],
    );
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
    int width = 256,
    int height = 256,
  }) : layer = ScribbleLayer(palette: palette, width: width, height: height),
       cache = MergedLayer(width: width, height: height) {
    layers.add(layer);
  }

  ScribbleCanvas.fromLayers({
    required this.layers,
    required this.palette,
    int width = 256,
    int height = 256,
  }) : layer = ScribbleLayer(palette: palette, width: width, height: height),
       cache = MergedLayer(width: width, height: height);

  Color getColor(int x, int y) {
    double r = 1;
    double g = 1;
    double b = 1;

    bool first = true;
    int layerCount = layers.length;

    for (int i = 0; i < layers.length; i++) {
      int palleteIdx = layers[i].getPixelIndex(x, y);

      // treat white as transparent.
      if (palleteIdx == 0) continue;
      Color col = layers[i].palette.colors[palleteIdx];

      if (first) {
        r = col.r;
        g = col.g;
        b = col.b;
      } else {
        r = (r + col.r) * (i / layerCount);
        g = (g + col.g) * (i / layerCount);
        b = (b + col.b) * (i / layerCount);
      }

      first = false;
    }

    return Color.from(alpha: 1.0, red: r.clamp(0, 1), green: g.clamp(0, 1), blue: b.clamp(0, 1));
  }

  void addLayer(ScribbleLayer layer) {
    layers.add(layer);
  }

  void redraw() {
    for (int x = 0; x < layer.width; x++) {
      for (int y = 0; y < layer.height; y++) {
        cache.setPixel(x, y, getColor(x, y));
      }
    }
  }

  int width() {
    return cache.width;
  }

  int height() {
    return cache.height;
  }

  Future<ui.Image> toImage({bool redrawCanvas = false}) async {
    if (redrawCanvas) {
      redraw();
    }

    final w = width();
    final h = height();

    final completer = Completer<ui.Image>();

    ui.decodeImageFromPixels(cache.colors, w, h, ui.PixelFormat.rgba8888, (
      ui.Image image,
    ) {
      completer.complete(image);
    });

    return completer.future;
  }
}
