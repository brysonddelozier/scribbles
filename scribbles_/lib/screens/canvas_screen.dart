import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scribbles/objects/canvas.dart';
import 'package:scribbles/objects/palette.dart';

import 'dart:ui' as ui;

// https://github.com/serverpod/pixels/blob/main/lib/src/pixel_image.dart

class CanvasScreen extends StatefulWidget {
  final ScribbleCanvas canvas;
  final ColorPalette palette;

  CanvasScreen({required this.canvas, required this.palette});

  @override
  State<StatefulWidget> createState() {
    return _CanvasScreenState();
  }
}

class _CanvasScreenState extends State<CanvasScreen> {
  ui.Image? _uiImage;

  @override
  void initState() {
    super.initState();
    _updateImage();
  }

  Future<void> _updateImage() async {
    _uiImage = await widget.canvas.toImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: _uiImage == null
          ? null
          : RawImage(
              image: _uiImage,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.none,
            ),
    );
  }
}
