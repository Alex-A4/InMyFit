import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/controller/watertip_controller.dart';

class ActivityLog extends StatefulWidget {
  ActivityLog({Key key}) : super(key: key);

  @override
  _ActivityLogState createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  WaterTipController _waterTipController = WaterTipController();
  WaterTip _currentTip;

  @override
  void initState() {
    super.initState();
    _currentTip = _waterTipController.getFirstTip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          cacheExtent: 10.0,
          key: Key('ActivityLogListView'),
          padding: EdgeInsets.only(top: 8.0),
          children: <Widget>[
            getCalendar(),
            getWaterTip(),
            getWaterReminder(),
            getSpacer(),
            getTabletsSchedule(),
            getMotivatorAndCourse(),
          ],
        ),
      ),
    );
  }

  //Get calendar that display at the top of list
  Widget getCalendar() {
    return Container(
      key: Key('CalendarKey'),
      height: 120.0,
      child: CalendarCarousel(
        weekFormat: true,
        locale: "ru",
        childAspectRatio: 1.5,
        isScrollable: false,
        weekdayTextStyle: TextStyle(color: Colors.grey[500], fontSize: 12.0),
        weekDayMargin: EdgeInsets.all(0.0),
        headerMargin: EdgeInsets.only(top: 16.0),
        todayButtonColor: Colors.transparent,
        iconColor: Colors.grey[500],
        selectedDayButtonColor: Colors.transparent,
        showWeekDays: true,
        headerTextStyle: TextStyle(color: Colors.grey[500], fontSize: 24.0),
        prevDaysTextStyle: dayTextStyle,
        nextDaysTextStyle: dayTextStyle,
        daysTextStyle: dayTextStyle,
        weekendTextStyle: dayTextStyle,
        selectedDayTextStyle: dayTextStyle,
        todayTextStyle: dayTextStyle,
      ),
    );
  }

  //Get the tip about water
  Widget getWaterTip() {
    return Container(
      key: Key('WaterTipKey'),
      height: 175.0,
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: ShapeDecoration(
                  color: _tipColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            Image.asset(
              'assets/watertips/watertip${_currentTip.index}.png',
              alignment: AlignmentDirectional.bottomStart,
            ),
            Container(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'watertip #${_currentTip.index}',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(_currentTip.tipText,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                        softWrap: true),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () =>
            setState(() => _currentTip = _waterTipController.getNextTip()),
      ),
    );
  }

  //Get the reminder about filled water
  Widget getWaterReminder() {
    var textStyleTurq = TextStyle(fontSize: 25.0, color: theme.primaryColor);
    var textStyle1 = TextStyle(fontSize: 18.0, color: Colors.black54);
    var textStyle2 = TextStyle(fontSize: 16.0, color: Colors.grey[400]);
    var textStyleFilled = TextStyle(fontSize: 16.0, color: Colors.black45);

    return Container(
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
                      Text('40', style: textStyleTurq),
                      Text('%', style: textStyleTurq.copyWith(fontSize: 18)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('800', style: textStyle2),
                      Text(
                        ' мл',
                        style: textStyle2.copyWith(fontSize: 15.0),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                child: Image.asset('assets/activity_water/people.png'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('цель', style: textStyle1),
                  Row(
                    children: <Widget>[
                      Text('2000', style: textStyleTurq),
                      Text(
                        ' мл',
                        style: textStyleTurq.copyWith(fontSize: 18.0),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('10', style: textStyle2),
                      Text(
                        ' стаканов',
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
            child:
                Text('посмотрите выпитые стаканы ниже', style: textStyleFilled),
          ),
          SizedBox(height: 20.0),
          GridView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 25.0),
              children: [
                true,
                true,
                true,
                true,
                false,
                false,
                false,
                false,
                false,
                false
              ].map((filled) => getGlassImage(filled)).toList()),
        ],
      ),
    );
  }

  Widget getSpacer() {
    return Container(
      height: 65.0,
      child: Image.asset(
        'assets/watertips/watertip1.png',
        height: 65.0,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }

  ///Get the image with glass (filled or not based on [filled])
  Widget getGlassImage(bool filled) {
    return GestureDetector(
      onTap: () {},
      child: Image.asset(
          'assets/activity_water/${filled ? 'glass_full' : 'glass_empty'}.png'),
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
          SizedBox(height: 10.0,),
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

  final Color _tipColor = Color(0xFF4EEBE4);

  final dayTextStyle = TextStyle(color: Colors.grey[500], fontSize: 24.0);
}
