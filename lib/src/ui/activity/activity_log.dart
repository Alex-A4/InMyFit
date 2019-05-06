import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/bloc/menu/menu.dart';
import 'package:inmyfit/src/redux/activity_redux.dart';
import 'package:inmyfit/src/ui/activity/calendar_widget.dart';
import 'package:inmyfit/src/ui/activity/edge_clipper.dart';
import 'package:inmyfit/src/ui/activity/tablets_reminder.dart';
import 'package:inmyfit/src/ui/activity/water_reminder.dart';
import 'package:inmyfit/src/ui/activity/water_tip.dart';
import 'package:redux/src/store.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ActivityLog extends StatelessWidget {
  const ActivityLog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Store<ActivityState> store =
        BlocProvider.of<MenuBloc>(context).activityStore;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Builder(
        builder: (context) => StoreProvider<ActivityState>(
              store: store,
              child: SingleChildScrollView(
                key: Key('ActivityLogListView'),
                padding: EdgeInsets.only(top: 28.0),
                child: Column(
                  children: <Widget>[
                    CalendarWidget(key: Key('Calendar')),
                    WaterTipWidget(key: Key('WaterTip')),
                    WaterReminder(key: Key('WaterReminder')),
                    getSpacer(context),
                    TabletsReminder(key: Key('TabletsReminder')),
                    getMotivatorAndCourse(context),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget getSpacer(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ClipPath(
        clipper: EdgeClipper(isTopEdge: false),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.only(top: 32.0),
          height: 75.0,
          width: double.infinity,
          child: Image.asset(
            'assets/activity_water/spacer.png',
            height: 65.0,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  //Return the widget with motivator and button to buy course
  Widget getMotivatorAndCourse(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ClipPath(
        clipper: EdgeClipper(isTopEdge: true),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getMotivatorTip(),
              SizedBox(height: 10.0),
              getBuyCourseButton(),
            ],
          ),
        ),
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
