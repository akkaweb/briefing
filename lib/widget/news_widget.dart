import 'package:flutter/material.dart';

class TextBackgroundRadius extends StatelessWidget {
  final double radius;
  final Color color;
  final Text _text;

  TextBackgroundRadius(this._text, {this.radius = 10, this.color = Colors.white, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
      decoration: BoxDecoration(
          border: Border.all(color: color), color: color, borderRadius: BorderRadius.all(Radius.circular(radius))),
      child: _text,
    );
  }
}
