import 'package:flutter/material.dart';
import 'package:inmyfit/main.dart';

/// This widget contains mineral name on gradient asset
class MineralIcon extends StatelessWidget {
  final String mineralText;
  final double size;
  final EdgeInsets margin;
  const MineralIcon(
      {Key key, @required this.mineralText, this.size = 60.0, this.margin})
      : assert(mineralText.length < 3,
            'Name of minerals must contain until 2 symbols'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
        borderRadius: BorderRadius.circular(5.0),
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColorLight],
          begin: FractionalOffset(0.4, 0.1),
          end: FractionalOffset(0.95, 0.25),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
    );
  }
}
