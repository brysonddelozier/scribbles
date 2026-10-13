import 'package:flutter/material.dart';
import 'package:scribbles/objects/palette.dart';

class PaletteWidget extends StatefulWidget {
  final ColorPalette palette;
  final ValueChanged<int> callback;
  int selected = 0;

  PaletteWidget(
    int selectedColor, {
    required this.palette,
    required this.callback,
  }) : selected = selectedColor;

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
      color: widget.palette.colors[widget.selected],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
        child: Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 4; i++) ...[
                      _ColorWidget(
                        callback: (a) {
                          _onTap(i);
                        },
                        color: widget.palette.colors[i],
                      ),
                      if (i < 3) const SizedBox(width: 10),
                    ],
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 4; i < 8; i++) ...[
                      _ColorWidget(
                        callback: (a) {
                          _onTap(i);
                        },
                        color: widget.palette.colors[i],
                      ),
                      if (i < 7) const SizedBox(width: 10),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int value) {
    widget.callback(value);
    setState(() {
      widget.selected = value;
    });
  }
}

class _ColorWidget extends StatelessWidget {
  final ValueChanged<void> callback;
  final Color color;

  const _ColorWidget({required this.callback, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback(null);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
      ),
    );
  }
}
