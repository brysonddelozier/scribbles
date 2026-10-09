import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scribbles/objects/canvas.dart';
import 'package:scribbles/objects/palette.dart';

import 'dart:math' as math;

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
  int width = 0;
  int height = 0;

  // last draw point
  int? _lastX;
  int? _lastY;

  bool rendering = false;

  @override
  void initState() {
    width = widget.canvas.width();
    height = widget.canvas.height();

    super.initState();
    _update();
  }

  Offset toCanvasPosition(
    Offset position,
    double widgetWidth,
    double widgetHeight,
  ) {
    final side = math.min(widgetWidth, widgetHeight);
    final paddingX = (widgetWidth - side) / 2;
    final paddingY = (widgetHeight - side) / 2;

    final x = ((position.dx - paddingX) / side) * widget.canvas.width();
    final y = ((position.dy - paddingY) / side) * widget.canvas.height();

    return Offset(x.floor().toDouble(), y.floor().toDouble());
  }

  bool _isInside(Offset position) {
    return position.dx >= 0 &&
        position.dx < width &&
        position.dy >= 0 &&
        position.dy < height;
  }

  Future<void> _update() async {
    if (rendering) return;
    rendering = true;

    Future.microtask(() async {
      _uiImage = await widget.canvas.toImage();
      setState(() {
        rendering = false;
      });
    });
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
          onPanUpdate: (details) => _continueDrawing(
            details.localPosition,
            widgetWidth,
            widgetHeight,
          ),
          onPanStart: (details) =>
              _startDrawing(details.localPosition, widgetWidth, widgetHeight),
          onPanEnd: (details) =>
              _endDrawing(details.localPosition, widgetWidth, widgetHeight),
        );
      },
    );
  }

  void _invalidate() {
    _lastX = null;
    _lastY = null;
  }

  void _endDrawing(Offset position, double width, double height) {
    _invalidate();
  }

  void _startDrawing(Offset position, double width, double height) {
    final point = toCanvasPosition(position, width, height);

    if (!_isInside(point)) {
      _invalidate();
      return;
    }

    _lastX = point.dx.toInt();
    _lastY = point.dy.toInt();

    drawPixelCircle(_lastX!, _lastY!);
  }

  void _continueDrawing(Offset position, double width, double height) {
    final point = toCanvasPosition(position, width, height);
    final x = point.dx.toInt();
    final y = point.dy.toInt();

    if (!_isInside(point)) {
      _invalidate();
      return;
    }

    if (_lastX == null || _lastY == null) {
      _lastX = x;
      _lastY = y;
      drawPixelCircle(x, y);
      return;
    }

    _drawLine(_lastX!, _lastY!, x, y);

    _lastX = x;
    _lastY = y;
  }

  // bressenham! I watch a youtube video about minecraft line rendering calculation for this... :(
  void _drawLine(int x0, int y0, int x1, int y1) {
    int dx = (x1 - x0).abs();
    int dy = (y1 - y0).abs();

    int sx = x0 < x1 ? 1 : -1;
    int sy = y0 < y1 ? 1 : -1;

    int error = dx - dy;

    while (true) {
      drawPixelCircle(x0, y0);

      if (x0 == x1 && y0 == y1) break;

      int error2 = error * 2;

      if (error2 > -dy) {
        error -= dy;
        x0 += sx;
      }

      if (error2 < dx) {
        error += dx;
        y0 += sy;
      }
    }
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

    _update();
  }
}
