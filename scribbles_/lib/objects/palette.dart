import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

class ColorPalette {
  final String key;
  final List<Color> colors;

  ColorPalette({required this.key}) : colors = getHashColors(key);
}

List<Color> getHashColors(String key) {
  List<Color> colors = List.filled(8, Colors.white, growable: false);

  var bytes = utf8.encode(key);
  var digest = sha256.convert(bytes);

  colors[0] = Colors.white;
  colors[1] = Colors.black;

  for (int i = 2; i < 8; i++) {
    int value =
        (255 << 24) |
        (digest.bytes[i + 2] << 16) |
        (digest.bytes[i + 1] << 8) |
        (digest.bytes[i]);

    colors[i] = Color(value);
  }

  return colors;
}
