import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:inmyfit/main.dart';

class MyFit extends StatefulWidget {
  MyFit({Key key}) : super(key: key);
  @override
  _MyFitState createState() => _MyFitState();
}

class _MyFitState extends State<MyFit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('MyFit', style: theme.textTheme.title,),
        backgroundColorStart: theme.primaryColor,
        backgroundColorEnd: theme.primaryColorLight,
        centerTitle: true,
      ),
    );
  }
}
