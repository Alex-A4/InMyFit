import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inmyfit/src/app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  runApp(MaterialApp(
    title: 'inmyfit',
    theme: theme,
    home: App(),
  ));
}

final theme = ThemeData(
  primaryColor: Color(0xFF34EBE9),
  primaryColorLight: Color(0xFFD0FFAE),
  brightness: Brightness.light,
  textTheme: TextTheme(title: TextStyle(fontSize: 22.0, color: Colors.white)),
);
