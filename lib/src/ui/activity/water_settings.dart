import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../../models/water_intake.dart';
import '../../redux/activity_redux.dart';

class WaterSettingsRoute<T> extends PopupRoute<T> {
  final Store<ActivityState> store;

  WaterSettingsRoute(this.store);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  @override
  Color get barrierColor => Color(0xEF7E7E7E);

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => 'WaterSettings';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return WaterSettings(
      store: store,
    );
  }
}

class WaterSettings extends StatefulWidget {
  final Store<ActivityState> store;

  WaterSettings({Key key, this.store}) : super(key: key);

  @override
  _WaterSettingsState createState() => _WaterSettingsState();
}

class _WaterSettingsState extends State<WaterSettings> {
  Store<ActivityState> get store => widget.store;

  int currentGoal;
  WaterIntakeType currentType;

  Function updater;

  /// 0 value is start page
  /// 1 value is goalIntake picker
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    currentGoal = store.state.currentActivityController.water.goalToIntake;
    currentType = store.state.currentActivityController.water.type;

    updater = (WaterIntakeType type, int goal) =>
        store.dispatch(UpdateCurrentControllerWater(
          goalToIntake: goal,
          type: type,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return currentPage == 0
        ? getFirstPage(context, updater)
        : getSecondPage(context, updater);
  }

  /// Widget for displaying items of route
  Widget getSettingsItem(Function onTap, String text) {
    return ListTile(
      title: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
      onTap: onTap,
    );
  }

  ///Widget for first initialize of settings
  Widget getFirstPage(BuildContext context, Function updater) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Настройки воды',
                            textAlign: TextAlign.center,
                            style: textStyle.copyWith(fontSize: 16.0)),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Измените способы отслеживания и суточную цель',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Neue',
                              fontSize: 14.0,
                              color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  getSettingsItem(() {
                    //Set up default values and close settings
                    updater(WaterIntakeType.Glasses, 10);
                    Navigator.of(context).pop();
                  }, 'Рекомендованные приёмы'),
                  Divider(),
                  getSettingsItem(() {
                    //Go to page to pick goal
                    setState(() => currentPage = 1);
                  }, 'Выбрать цель'),
                  Divider(),
                  getSettingsItem(() {
                    //Inverse current type
                    setState(() {
                      if (currentType == WaterIntakeType.Glasses)
                        currentType = WaterIntakeType.Bottles;
                      else
                        currentType = WaterIntakeType.Glasses;
                    });
                  },
                      currentType == WaterIntakeType.Glasses
                          ? 'Стаканы (200мл)'
                          : 'Бутылки (500мл)'),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            //Close button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child:
                  getSettingsItem(() => Navigator.of(context).pop(), 'Закрыть'),
            ),
          ],
        ),
      ),
    );
  }

  /// Page to pick intake goal
  Widget getSecondPage(BuildContext context, Function updater) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Отменить',
                    style:
                        page1TS.copyWith(decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    setState(() => currentPage = 0);
                  },
                ),
                Text('Приём воды', style: page1TS),
                FlatButton(
                  child: Text(
                    'Применить',
                    style:
                        page1TS.copyWith(decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    updater(currentType, currentGoal);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Column(
              /// Generate list of vessels based on [currentType]
              /// Count of glasses starts with 5, of bottles with 1
              children: List.generate(7, (index) {
                int count =
                    (currentType == WaterIntakeType.Glasses ? 5 : 1) + index;
                return getVesselItem(count);
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Get item of vessels based on [currentType]
  Widget getVesselItem(int count) {
    var style = page1TS;
    if (currentGoal == count)
      style = style.copyWith(fontSize: 18.0, fontWeight: FontWeight.w600);
    return Container(
      height: 30.0,
      child: ListTile(
        title: Text(
          '$count ${currentType == WaterIntakeType.Glasses ? 'стаканов' : 'бутылок'}',
          textAlign: TextAlign.center,
          style: style,
        ),
        onTap: () {
          setState(() => currentGoal = count);
        },
      ),
    );
  }

  var page1TS = TextStyle(
    fontSize: 16.0,
    fontFamily: 'ProstoSans',
    color: Colors.grey[600],
  );
  var textStyle = TextStyle(
      fontSize: 20.0,
      color: Colors.grey[700],
      fontFamily: 'ProstoSans',
      fontWeight: FontWeight.w600);
}
