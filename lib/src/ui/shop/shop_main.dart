import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:inmyfit/main.dart';

class Shop extends StatefulWidget {
  Shop({Key key}) : super(key: key);
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Shop', style: theme.textTheme.title,),
        backgroundColorStart: theme.primaryColor,
        backgroundColorEnd: theme.primaryColorLight,
        centerTitle: true,
      ),
    );
  }
}
