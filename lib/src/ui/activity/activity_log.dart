import 'package:flutter/material.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/redux/activity_redux.dart';
import 'package:inmyfit/src/ui/activity/calendar_widget.dart';
import 'package:inmyfit/src/ui/activity/water_reminder.dart';
import 'package:inmyfit/src/ui/activity/water_tip.dart';
import 'package:redux/src/store.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ActivityLog extends StatelessWidget {
  final Store<ActivityState> store;

  ActivityLog({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: StoreProvider<ActivityState>(
        store: store,
        child: ListView(
          cacheExtent: 10.0,
          key: Key('ActivityLogListView'),
          padding: EdgeInsets.only(top: 28.0),
          children: <Widget>[
            CalendarWidget(),
            WaterTipWidget(),
            WaterReminder(),
            getSpacer(),
            getTabletsSchedule(),
            getMotivatorAndCourse(),
          ],
        ),
      ),
    );
  }

  Widget getSpacer() {
    return Container(
      padding: const EdgeInsets.only(top: 32.0),
      height: 75.0,
      child: Image.asset(
        'assets/activity_water/spacer.png',
        height: 65.0,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }

  //Get the widget with with tablets schedule
  Widget getTabletsSchedule() {
    var textStyleRed = TextStyle(color: Colors.red[300], fontSize: 25.0);

    return Container(
      key: Key('TabletsSchedule'),
      padding: const EdgeInsets.only(top: 8.0),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 4.0),
                alignment: AlignmentDirectional.center,
                child: Text('Приём таблеток', style: textStyleRed),
              ),
              Container(
                padding: const EdgeInsets.only(top: 4.0, right: 16.0),
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
                  onTap: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),

          //TODO: use expandable widgets for tablets
        ],
      ),
    );
  }

  //Return the widget with motivator and button to buy course
  Widget getMotivatorAndCourse() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getMotivatorTip(),
          SizedBox(
            height: 10.0,
          ),
          getBuyCourseButton(),
        ],
      ),
    );
  }

  Widget getBuyCourseButton() {
    return RaisedButton(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: theme.primaryColor,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.shopping_cart, color: Colors.white, size: 25.0),
          Text('купить курс',
              style: TextStyle(fontSize: 19.0, color: Colors.white)),
        ],
      ),
    );
  }

  Widget getMotivatorTip() {
    return Container(
      width: double.infinity,
      height: 120.0,
      padding: const EdgeInsets.all(16.0),
      decoration: ShapeDecoration(
          color: Colors.red[300],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      child: Container(
        child: Text(
          'motivator',
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}
