import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:inmyfit/main.dart';

class Guides extends StatefulWidget {
  Guides({Key key}) : super(key: key);
  @override
  _GuidesState createState() => _GuidesState();
}

class _GuidesState extends State<Guides> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Guides', style: theme.textTheme.title,),
        backgroundColorStart: theme.primaryColor,
        backgroundColorEnd: theme.primaryColorLight,
        centerTitle: true,
      ),
    );
  }
}
