import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../redux/activity_redux.dart';
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
                  onTap: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          StoreConnector<ActivityState, VoidCallback>(
            converter: (store) {
              _store = store;
              return () {};
            },
            builder: (context, callback) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    getExpandableItem('утро', [1, 2, 3]),
                    getExpandableItem('полдень', [1]),
                    getExpandableItem('вечер', []),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getExpandableItem(String header, List expanded) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white),
      child: ExpandablePanel(
        header: Container(
          margin: EdgeInsets.only(top: 16.0),
          child: Text(
            header,
            style: TextStyle(color: theme.accentColor, fontSize: 15.0),
          ),
        ),
        tapHeaderToExpand: true,
        collapsed: getCollapsedTabletsWidget(),
        expanded: getExpandedTabletsWidget(expanded),
      ),
    );
  }

  /// Create widget for expanded information about tablets
  Widget getExpandedTabletsWidget(List tablets) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
            tablets.map((tablet) => getExtendedTabletInfo(tablet)).toList(),
      ),
    );
  }

  /// Get extended information about one tablet
  Widget getExtendedTabletInfo(var tablet) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Марганец-DC',
            style: TextStyle(fontSize: 21.0),
          ),
          Text('x 1'),
          SizedBox(width: 20.0),
          SizedBox(
            width: 50.0,
            height: 25.0,
            child: RaisedButton(
              padding: const EdgeInsets.all(0.0),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(5.0)),
              onPressed: () {},
              color: theme.primaryColor,
              textColor: Colors.white,
              child: Text('ok'),
            ),
          ),
        ],
      ),
      subtitle: Text(
        'Pill 10mg',
        softWrap: true,
      ),
    );
  }

  Widget getCollapsedTabletsWidget() {
    return Container(
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[],
        // ),
        );
  }

  var textStyleRed = TextStyle(color: Colors.red[300], fontSize: 25.0);
}
