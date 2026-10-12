import 'package:flutter/material.dart';
import 'package:scribbles/objects/palette.dart';

class PaletteWidget extends StatefulWidget {
  final ColorPalette palette;
  final ValueChanged<int> callback;

  const PaletteWidget({required this.palette, required this.callback});

  @override
  State<StatefulWidget> createState() {
    return _PaletteWidgetState();
  }
}

class _PaletteWidgetState extends State<PaletteWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.palette.colors.asMap().entries.map((color) {
            return InkWell(
              onTap: () {
                _onTap(color.key);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.value,
                  shape: BoxShape.circle,
                  border: Border.all(color: color.value, width: 3),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _onTap(int value) {
    widget.callback(value);
  }
}
