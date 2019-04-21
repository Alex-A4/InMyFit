import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/models/tablet_intake.dart';
import 'package:inmyfit/src/redux/activity_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';

class TabletsSettings extends StatelessWidget {
  final Store<ActivityState> store;

  TabletsSettings({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsScreen(store: store),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final Store<ActivityState> store;

  SettingsScreen({Key key, this.store}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
  int dosage = 0;

  /// How many times per day need to intake tablet
  int countOfIntakes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 45.0),
        child: GradientAppBar(
          flexibleSpace: Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Отмена', style: appBarStyle),
                ),
                Text('Настройки таблеток', style: appBarStyle),
                FlatButton(
                  onPressed: () => setState(() {
                        if (_formKey.currentState.validate()) ++settingsStep;
                      }),
                  child: Text('Дальше', style: appBarStyle),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColorStart: theme.primaryColor,
          backgroundColorEnd: theme.primaryColorLight,
          centerTitle: true,
        ),
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
                  settingsStep == 2
                      ? getDosageAndCountInput(context)
                      : Container(),
                ],
              ),
            ),
            settingsStep == 1 ? getActiveCourses() : Container(),
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
          height: 50.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.white,
          child: TextFormField(
            validator: (text) {
              if (text.isEmpty) return 'Введите название';
            },
            style: mainTextStyle,
            // Allow to modify name only on first step
            enabled: settingsStep == 1,
            decoration: InputDecoration(
                hintText: 'Введите название',
                hintStyle: hintStyle,
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

  /// If user input name then show field to input dosage and count of intakes
  Widget getDosageAndCountInput(BuildContext context) {
    var padding = const EdgeInsets.only(left: 16.0);
    return Material(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          Container(
              padding: padding,
              child:
                  Text('Как часто принимать таблетки', style: subtitleStyle)),
          InkWell(
            child: Container(
              height: 50.0,
              width: double.infinity,
              padding: padding,
              color: Colors.white,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  countOfIntakes == 0
                      ? 'Количество приёмов'
                      : '$countOfIntakes раз',
                  style: countOfIntakes == 0 ? hintStyle : mainTextStyle,
                ),
              ),
            ),
            onTap: () => showCountOfIntakesSelecter(context),
          ),
          SizedBox(height: 20.0),
          Container(
              padding: padding,
              child:
                  Text('Сколько таблеток за один приём', style: subtitleStyle)),
          InkWell(
            child: Container(
              height: 50.0,
              width: double.infinity,
              color: Colors.white,
              padding: padding,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  dosage == 0 ? 'Дозировка' : '$dosage штук',
                  style: dosage == 0 ? hintStyle : mainTextStyle,
                ),
              ),
            ),
            onTap: () => showDosageSelecter(context),
          ),
        ],
      ),
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

  /// Show bottom sheet dialog to select [countOfIntakes] variable
  void showCountOfIntakesSelecter(BuildContext context) {
    Scaffold.of(context).showBottomSheet((context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text('Выберите количество приёмов',
                  style: mainTextStyle, textAlign: TextAlign.center),
              subtitle: Text('Сколько раз в день принимать медикамент',
                  style: mainTextStyle.copyWith(fontSize: 15.0),
                  textAlign: TextAlign.center),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(3, (index) {
                return InkWell(
                  child: Container(
                    height: 40.0,
                    width: double.infinity,
                    child: Center(
                      child: Text('${index + 1} раза в день',
                          style: mainTextStyle, textAlign: TextAlign.center),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => countOfIntakes = index + 1);
                  },
                );
              }),
            ),
          ],
        ));
  }

  /// Show bottom sheet dialog to select [dosage] variable
  void showDosageSelecter(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text('Выберите количество',
                      style: mainTextStyle, textAlign: TextAlign.center),
                  subtitle: Text('Сколько количетство таблеток за один приём',
                      style: mainTextStyle.copyWith(fontSize: 15.0),
                      textAlign: TextAlign.center),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return InkWell(
                      child: Container(
                        height: 35.0,
                        width: double.infinity,
                        child: Center(
                          child: Text('${index + 1}',
                              style: mainTextStyle,
                              textAlign: TextAlign.center),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() => dosage = index + 1);
                      },
                    );
                  }),
                ),
              ],
            ));
  }

  var coursesStyle = TextStyle(
      fontSize: 17.0, color: Colors.grey[350], fontFamily: 'ProstoSans');
  var appBarStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontFamily: 'ProstoSans',
      fontWeight: FontWeight.w500);
  var mainTextStyle = TextStyle(
      fontSize: 18.0,
      color: Colors.black87,
      fontFamily: 'Neue',
      fontWeight: FontWeight.w700);
  var hintStyle = TextStyle(fontSize: 18.0, color: Colors.red[400]);
  var subtitleStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      color: Colors.grey[600],
      fontFamily: 'ProstoSans');
}
