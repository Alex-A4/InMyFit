import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:inmyfit/main.dart';

class ActivityLog extends StatefulWidget {
  ActivityLog({Key key}) : super(key: key);
  @override
  _ActivityLogState createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('ActivityLog', style: theme.textTheme.title,),
        backgroundColorStart: theme.primaryColor,
        backgroundColorEnd: theme.primaryColorLight,
        centerTitle: true,
      ),
    );
  }
}
