import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/models/water_intake.dart';
import 'package:inmyfit/src/redux/activity_redux.dart';
import 'package:inmyfit/src/ui/activity/water_settings.dart';
import 'package:redux/redux.dart';

class WaterReminder extends StatelessWidget {
  Store<ActivityState> _store;
  final _peopleHeight = 120.0;
  final _peopleWidth = 100.0;

  ///For UI filled vessels will displays like bool list and for controller
  /// it's count of filled vessels
  List<bool> filledVessels;

  WaterReminder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<ActivityState, ValueChanged<bool>>(
      converter: (store) {
        _store = store;

        int filledCount =
            store.state.dayActivityController.waterIntake.completed;
        int goal = store.state.dayActivityController.waterIntake.goalToIntake;

        /// Generate list of fill/empty vessels.
        /// Example: [filledCount] = 3 and [goal] = 5, then it generates
        /// list [true, true, true, false, false]
        filledVessels =
            List.generate(goal, (index) => index < filledCount ? true : false);

        /// If [isFilled] true then increase count else decrease
        return (isFilled) =>
            store.dispatch(ChangeCompletedWaterAction(isFilled: isFilled));
      },
      builder: (context, changer) {
        WaterIntake water = _store.state.dayActivityController.waterIntake;
        WaterIntakeType type = water.type;

        //If it's glasses then 200ml else 500ml
        int mlInOneIntake = type == WaterIntakeType.Glasses ? 200 : 500;
        int goal = mlInOneIntake * water.goalToIntake;
        int completed = mlInOneIntake * water.completed;
        int percent = (completed / goal.toDouble() * 100).toInt();

        double peopleColorHeight = percent.toDouble() / 100 * _peopleHeight;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          key: Key('WaterReminderKey'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 4.0),
                    alignment: AlignmentDirectional.center,
                    child: Text('Приём воды', style: textStyleTurq),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 4.0),
                    alignment: AlignmentDirectional.centerEnd,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        child: Image.asset(
                          'assets/activity_water/settings.png',
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(WaterSettingsRoute());
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('заполнено', style: textStyle1),
                      Row(
                        children: <Widget>[
                          Text('$percent', style: textStyleTurq),
                          Text('%',
                              style: textStyleTurq.copyWith(fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('$completed', style: textStyle2),
                          Text(
                            ' мл',
                            style: textStyle2.copyWith(fontSize: 15.0),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: _peopleWidth,
                    height: _peopleHeight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: peopleColorHeight,
                              color: peopleFillColor,
                            )),
                        Image.asset(
                          'assets/activity_water/people.png',
                          height: _peopleHeight,
                          width: _peopleWidth,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('цель', style: textStyle1),
                      Row(
                        children: <Widget>[
                          Text('$goal', style: textStyleTurq),
                          Text(
                            ' мл',
                            style: textStyleTurq.copyWith(fontSize: 18.0),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('${water.goalToIntake} ', style: textStyle2),
                          Text(
                            type == WaterIntakeType.Glasses
                                ? 'стаканов'
                                : 'бутылок',
                            style: textStyle2.copyWith(fontSize: 15.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                alignment: AlignmentDirectional.center,
                child: Text(
                    'посмотрите выпитые ${type == WaterIntakeType.Glasses ? 'стаканы' : 'бутылки'} ниже',
                    style: textStyleFilled),
              ),
              SizedBox(height: 20.0),
              GridView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shrinkWrap: true,
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 25.0,
                ),
                children: filledVessels
                    .asMap()
                    .keys
                    .map((index) => getGlassImage(changer, index, type))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  ///Get the image with glass (filled or not based on [filled])
  Widget getGlassImage(
      ValueChanged<bool> changer, int index, WaterIntakeType type) {
    bool filled = filledVessels[index];
    return GestureDetector(
      onTap: () {
        //Inverse bottle
        filledVessels[index] = !filledVessels[index];
        changer(filledVessels[index]);
      },
      child: Image.asset(type == WaterIntakeType.Glasses
          ? 'assets/activity_water/${filled ? 'glass_full' : 'glass_empty'}.png'
          : 'assets/activity_water/${filled ? 'bottle_full' : 'bottle_empty'}.png'),
    );
  }

  var peopleFillColor = Color(0xFFA5F4F1);
  var textStyleTurq =
      TextStyle(fontSize: 30.0, color: theme.primaryColor, fontFamily: 'Neue');
  var textStyle1 =
      TextStyle(fontSize: 18.0, color: Colors.black54, fontFamily: 'Neue');
  var textStyle2 =
      TextStyle(fontSize: 16.0, color: Colors.grey[400], fontFamily: 'Neue');
  var textStyleFilled = TextStyle(
      fontSize: 15.0, color: Colors.black45, fontFamily: 'ProstoSans');
}
