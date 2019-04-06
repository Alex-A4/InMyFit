import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
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
          padding: EdgeInsets.only(top: 8.0),
          children: <Widget>[
            getCalendar(),
            getWaterTip(),
          ],
        ),
      ),
    );
  }

  //Get calendar that display at the top of list
  Widget getCalendar() {
    return Container(
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

  //Return the tip about water
  Widget getWaterTip() {
    return Container(
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

  final Color _tipColor = Color(0xFF4EEBE4);

  final dayTextStyle = TextStyle(color: Colors.grey[500], fontSize: 24.0);
}
