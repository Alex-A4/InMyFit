import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:inmyfit/main.dart';

import 'widgets/conditions_image.dart';
import 'widgets/mineral_icon.dart';
import 'widgets/percent_scale.dart';
import 'widgets/search_bar.dart';
import 'widgets/top_clipped_info.dart';

class Guides extends StatelessWidget {
  const Guides({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          'Guides',
          style: theme.textTheme.title,
        ),
        backgroundColorStart: theme.primaryColor,
        backgroundColorEnd: theme.primaryColorLight,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SearchBar(textChanger: (text) => null),
              SizedBox(height: 20.0),
              ClippedTopInfo(
                image: 'assets/watertips/watertip1.png',
                title: 'Water',
                isGrey: true,
                subtitle: 'Watertip',
              ),
              SizedBox(height: 20.0),
              ConditionImage(
                  image: 'assets/watertips/watertip1.png', title: 'acne'),
              SizedBox(height: 20.0),
              PersentScale(
                percent: 30,
              ),
              SizedBox(height: 20.0),
              MineralIcon(mineralText: 'Na'),
              MineralIcon(mineralText: 'Cr'),
              MineralIcon(mineralText: 'K'),
              MineralIcon(mineralText: 'Mg'),
            ],
          ),
        ),
      ),
    );
  }
}
