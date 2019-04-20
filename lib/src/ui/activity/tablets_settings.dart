import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/models/tablet_intake.dart';
import 'package:inmyfit/src/redux/activity_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';

class TabletsSettings extends StatefulWidget {
  final Store<ActivityState> store;

  TabletsSettings({Key key, this.store}) : super(key: key);

  @override
  _TabletsSettingsState createState() => _TabletsSettingsState();
}

class _TabletsSettingsState extends State<TabletsSettings> {
  Store<ActivityState> get store => widget.store;
  final _formKey = GlobalKey<FormState>();

  /// Step of tablet settings, this variable helps to show specified info
  /// on each step.
  /// For example, on first step here must be:
  /// 1) Form to input name of new medicine
  /// 2) Active courses
  /// 3) All medicine
  /// On second step here must be:
  /// 1) Form to input name of new medicine (filled)
  /// 2) Forms to input dosage and count of units
  /// 3) If there is editing mode, then button to remove medicine
  /// e.t.c
  int settingsStep = 1;

  /// Controller to enter name of new medicine
  TextEditingController nameController = TextEditingController();

  /// How many pills per one intake
  int dosage;

  /// How many times per day need to intake tablet
  int countOfIntakes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: GradientAppBar(
        automaticallyImplyLeading: false,
        leading: FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Отмена', style: appBarStyle),
        ),
        title: Text('Настройки таблеток', style: appBarStyle),
        actions: <Widget>[
          FlatButton(
            onPressed: () => setState(() {
                  if (_formKey.currentState.validate()) ++settingsStep;
                }),
            child: Text('Дальше', style: appBarStyle),
          ),
        ],
        backgroundColorStart: theme.primaryColor,
        backgroundColorEnd: theme.primaryColorLight,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  getNameEditor(),
                ],
              ),
            ),
            getActiveCourses(),
          ],
        ),
      ),
    );
  }

  /// Widget that contains text form to input name of medicine
  /// This filed will have access only on when [settingsStep] == 1
  /// This widget must be inside Form
  Widget getNameEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Название препарата', style: subtitleStyle)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.white,
          child: TextFormField(
            validator: (text) {
              if (text.isEmpty) return 'Введите название';
            },
            style: mainTextStyle,
            decoration: InputDecoration(
                hintText: 'Введите название',
                hintStyle: hintStyle,
                // Allow to modify name only on first step
                enabled: settingsStep == 1,
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0)),
                disabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 0.0, color: Colors.transparent))),
            controller: nameController,
          ),
        ),
      ],
    );
  }

  /// Get list of active courses of user
  Widget getActiveCourses() {
    List<TabletsIntake> tablets = [];
    if (store.state.currentActivityController.tablets.isNotEmpty)
      tablets = store.state.currentActivityController.tablets.values;

    // If there is no courses then return empty container
    return tablets.isEmpty
        ? Container()
        : Container(
            child: Column(
              children: <Widget>[
                Text('Активные курсы', style: subtitleStyle),
                Column(
                  children:
                      tablets.map((tablet) => getActiveTablet(tablet)).toList(),
                ),
              ],
            ),
          );
  }

  /// Get dismissed widget with one tablet representation
  Widget getActiveTablet(TabletsIntake tablet) {
    return Slidable(
      delegate: SlidableScrollDelegate(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(tablet.name, style: coursesStyle),
          Icon(Icons.chevron_right, color: coursesStyle.color),
        ],
      ),
      direction: Axis.horizontal,
      secondaryActions: <Widget>[
        IconSlideAction(
          icon: null,
          color: Colors.white,
          foregroundColor: Colors.red[400],
          caption: 'Удалить',
          onTap: () {},
        ),
      ],
    );
  }

  var coursesStyle = TextStyle(
      fontSize: 17.0, color: Colors.grey[350], fontFamily: 'ProstoSans');
  var appBarStyle = TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontFamily: 'Neue',
      fontWeight: FontWeight.w700);
  var mainTextStyle = TextStyle(fontSize: 18.0, color: Colors.black87, fontFamily: 'Neue', fontWeight: FontWeight.w700);
  var hintStyle = TextStyle(fontSize: 18.0, color: Colors.red[400]);
  var subtitleStyle = TextStyle(
      fontSize: 14.0, color: Colors.grey[500], fontFamily: 'ProstoSans');
}
