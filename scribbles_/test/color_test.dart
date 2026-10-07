// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scribbles/main.dart';
import 'package:scribbles/objects/palette.dart';

void main() {
  test("Test colors from palette", () {
    ColorPalette palette = ColorPalette(key: "lukespeer");

    for (int i = 0; i < 8; i++) {
      assert(palette.colors[i].a == 1);
    }
  });
}
