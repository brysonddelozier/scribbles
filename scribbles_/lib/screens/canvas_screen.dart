import 'dart:typed_data';

import 'package:flutter/foundation.dart';
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
  int _lastProcessTime = 0;
  ui.Image? _uiImage;
  int selectedColor = 0;
  int radius = 10;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final double widgetWidth = constraints.maxWidth;
        final double widgetHeight = constraints.maxHeight;

        return GestureDetector(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: _uiImage == null ? null : RawImage(image: _uiImage),
            ),
          ),
          onPanUpdate: (details) {
            final double scaleX = widgetWidth / widget.canvas.width();
            final double scaleY = widgetHeight / widget.canvas.height();
            final double scale = scaleX < scaleY ? scaleX : scaleY;
            final double renderedImageWidth = widget.canvas.width() * scale;
            final double renderedImageHeight = widget.canvas.height() * scale;
            final double paddingX = (widgetWidth - renderedImageWidth) / 2;
            final double paddingY = (widgetHeight - renderedImageHeight) / 2;
            final double imageSpaceX = details.localPosition.dx - paddingX;
            final double imageSpaceY = details.localPosition.dy - paddingY;
            final double relativeX = imageSpaceX / renderedImageWidth;
            final double relativeY = imageSpaceY / renderedImageHeight;

            final int imagePixelX = (relativeX * widget.canvas.width())
                .toInt()
                .clamp(0, widget.canvas.width() - 1);
            final int imagePixelY = (relativeY * widget.canvas.height())
                .toInt()
                .clamp(0, widget.canvas.height() - 1);

            drawPixelCircle(imagePixelX, imagePixelY);
          },
        );
      },
    );
  }

  void setPixel(int x, int y, int selectedColor) {
    widget.canvas.layer.setPixel(x, y, selectedColor);
    widget.canvas.cache.setPixel(x, y, widget.palette.colors[selectedColor]);
  }

  void drawPixelCircle(int px, int py) {
    int width = widget.canvas.width();
    int height = widget.canvas.height();
    for (int y = py - radius; y <= py + radius; y++) {
      for (int x = px - radius; x <= px + radius; x++) {
        if (x < 0 || x >= width || y < 0 || y >= height) {
          continue;
        }

        int dx = x - px;
        int dy = y - py;
        if ((dx * dx) + (dy * dy) <= radius * radius) {
          setPixel(x, y, selectedColor);
        }
      }
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - _lastProcessTime < 16) return;
    _lastProcessTime = currentTime;

    Future.microtask(() {
      _updateImage();
    });
  }
}
