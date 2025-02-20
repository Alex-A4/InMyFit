import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inmyfit/src/activity/models/tablet_intake.dart';
import 'package:inmyfit/src/activity/redux/activity_redux.dart';
import 'package:inmyfit/src/activity/ui/tablets_settings.dart';
import 'package:redux/redux.dart';
import 'package:expandable/expandable.dart';
import '../../../main.dart';

class TabletsReminder extends StatelessWidget {
  TabletsReminder({Key key}) : super(key: key);

  Store<ActivityState> _store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
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
                  onTap: () {
                    var store = StoreProvider.of<ActivityState>(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TabletsSettings(store: store)));
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          StoreConnector<ActivityState, Function(TabletsIntake, String)>(
            converter: (store) {
              /// Method to push ned action to reducer to update data about [tablet]
              return (tablet, dayTime) =>
                  store.dispatch(ChangeCompletedTabletsAction(
                    dayTime: dayTime,
                    tablet: tablet,
                  ));
            },
            builder: (context, callback) {
              _store = StoreProvider.of<ActivityState>(context);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    getExpandableItem('утро', 'morning', callback),
                    getExpandableItem('полдень', 'afternoon', callback),
                    getExpandableItem('вечер', 'evening', callback),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Get item that can be extended
  /// Item is a separated info about morning/afternoon/evening intakes
  /// [dayTime] variable describes the time of day morning/afternoon/evening
  /// [callback] function needs to toggle reducer
  Widget getExpandableItem(String header, String dayTime, Function callback) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white),
      child: ExpandablePanel(
        header: Container(
          margin: EdgeInsets.only(top: 16.0, left: 10.0),
          child: Text(
            header,
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 17.0,
              fontFamily: 'ProstoSans',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        tapHeaderToExpand: true,
        collapsed: getCollapsedTabletsWidget(dayTime),
        expanded: getExpandedTabletsWidget(dayTime, callback),
      ),
    );
  }

  /// Create widget for expanded information about tablets
  /// [dayTime] variable describes the day of time, see [getExpandableItem]
  Widget getExpandedTabletsWidget(String dayTime, Function callback) {
    var tablets = _store.state.dayActivityController.tabletsIntake;

    return Container(
      child: Column(
        children: <Widget>[
          Divider(height: 1.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: tablets
                // Build column of tablets that contains [dayTime]
                .where((tablet) => tablet.completed.containsKey(dayTime))
                .map((tablet) =>
                    getExtendedTabletInfo(tablet, dayTime, callback))
                .toList(),
          ),
        ],
      ),
    );
  }

  /// Get extended information about one tablet
  /// For info about [dayTime], see [getExpandableItem], this needs to
  /// call redux method
  /// [callback] needs to toggle reducer
  Widget getExtendedTabletInfo(
      TabletsIntake tablet, String dayTime, Function callback) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              tablet.name,
              style: TextStyle(fontSize: 21.0, color: Colors.grey[400]),
            ),
          ),
          Text('x ${tablet.dosage}', style: TextStyle(color: Colors.grey[300])),
          SizedBox(width: 20.0),
          SizedBox(
            width: 65.0,
            height: 25.0,
            child: RaisedButton(
              padding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              onPressed: tablet.completed[dayTime]
                  ? null
                  : () => callback(tablet, dayTime),
              color: theme.primaryColor,
              textColor: Colors.white,
              child: Text('ok'),
            ),
          ),
        ],
      ),
      subtitle: Text('Pill 10mg', style: TextStyle(color: Colors.grey[300])),
    );
  }

  /// Get the collapsed widget that contains short info about tablets
  /// For info about [datTime], see [getExpandableItem]
  Widget getCollapsedTabletsWidget(String dayTime) {
    // Find tablets that contains [dayTime]
    var tablets = _store.state.dayActivityController.tabletsIntake
        .where((tablet) => tablet.completed.containsKey(dayTime));

    return Builder(
      builder: (context) {
        var collapsedWidgetWidth = 65.0;
        var screenWidth = MediaQuery.of(context).size.width;

        // Amount of widget that can put in a row
        var capacity = screenWidth ~/ collapsedWidgetWidth;

        // If there enough of place to put all tablets in a row, then do it
        // else create expandable widget
        if (capacity >= tablets.length) {
          return Container(
            child: Column(
              children: <Widget>[
                Divider(height: 1.0),
                tablets.length > 0 ? SizedBox(height: 8.0) : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: tablets
                      .map((tablet) => getCollapsedTabletInfo(tablet, dayTime))
                      .toList(),
                ),
              ],
            ),
          );
        } else {
          return ExpandablePanel(
            hasIcon: false,
            tapHeaderToExpand: true,
            tapBodyToCollapse: true,
            collapsed: Column(
              children: <Widget>[
                Divider(height: 1.0),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ...tablets
                        .take(capacity - 1)
                        .map(
                            (tablet) => getCollapsedTabletInfo(tablet, dayTime))
                        .toList(),
                    Icon(Icons.more_horiz, size: 30.0),
                  ],
                ),
              ],
            ),
            expanded: Column(
              children: <Widget>[
                Divider(height: 1.0),
                SizedBox(height: 8.0),
                GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: capacity),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: tablets.length,
                  itemBuilder: (context, index) =>
                      getCollapsedTabletInfo(tablets.elementAt(index), dayTime),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget getCollapsedTabletInfo(TabletsIntake tablet, String dayTime) {
    return Container(
      width: 55.0,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Image.asset(
        'assets/tabletsReminder/${tablet.completed[dayTime] ? 'completed' : 'notCompleted'}.png',
        width: 45.0,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  var textStyleRed = TextStyle(color: Colors.red[300], fontSize: 25.0);
}
