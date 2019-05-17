import 'package:flutter/material.dart';

class MineralIcon extends StatelessWidget {
  final String mineralText;
  final double size;
  final EdgeInsets margin;
  const MineralIcon({Key key, this.mineralText, this.size = 60.0, this.margin})
      : assert(mineralText.length < 3,
            'Name of minerals must contain until 2 symbols'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      width: size,
      height: size,
      child: Text(
        mineralText,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: size / 2,
            color: Colors.white,
            fontFamily: 'Neue',
            fontWeight: FontWeight.bold),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/guides/mineral_icon.png'),
            fit: BoxFit.contain),
      ),
    );
  }
}
