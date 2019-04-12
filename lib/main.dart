import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inmyfit/src/app.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  initializeDateFormatting().then((_) => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'inmyfit',
        theme: theme,
        home: App(),
      )));
}

final theme = ThemeData(
  primaryColor: Color(0xFF34EBE9),
  primaryColorLight: Color(0xFFD0FFAE),
  brightness: Brightness.light,
  textTheme: TextTheme(title: TextStyle(fontSize: 22.0, color: Colors.white)),
);
