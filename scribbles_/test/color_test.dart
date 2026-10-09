// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scribbles/main.dart';
import 'package:scribbles/objects/canvas.dart';
import 'package:scribbles/objects/palette.dart';

void main() {
  test("Test colors from palette", () {
    ColorPalette palette = ColorPalette(key: "jacksnell1");

    for (int i = 0; i < 8; i++) {
      assert(palette.colors[i].a == 1);
    }

    for (int i = 0; i < 8; i++) {
      print(palette.colors[i]);
    }
  });
  test("Test canvas storing color data", () {
    ColorPalette palette = ColorPalette(key: "lukespeer");
    ScribbleLayer canvas = ScribbleLayer(
      palette: palette,
      width: 1024,
      height: 1024,
    );

    assert(canvas.getPixel(0, 0) == palette.colors[0]);

    canvas.setPixel(10, 10, 3);

    assert(canvas.getPixel(10, 10) == palette.colors[3]);
  });

  test("Performance Test Canvas Cache", () {
    ColorPalette palette = ColorPalette(key: "lukespeer");

    ScribbleLayer layer1 = ScribbleLayer(
      palette: palette,
      width: 1024,
      height: 1024,
    );
    ScribbleLayer layer2 = ScribbleLayer(
      palette: palette,
      width: 1024,
      height: 1024,
    );
    ScribbleLayer layer3 = ScribbleLayer(
      palette: palette,
      width: 1024,
      height: 1024,
    );

    ScribbleCanvas canvas = ScribbleCanvas(palette, 1024, 1024);
    canvas.addLayer(layer1);
    canvas.addLayer(layer2);
    canvas.addLayer(layer3);

    final stopwatch = Stopwatch();
    stopwatch.start();
    canvas.redraw();
    stopwatch.stop();

    print('Elapsed milliseconds: ${stopwatch.elapsedMilliseconds}');
  });
}
