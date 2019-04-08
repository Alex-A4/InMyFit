import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/redux/activity_redux.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreConnector<ActivityState, Function(DateTime, List<dynamic>)>(
      converter: (store) {
        return (date, list) => store.dispatch(FetchDataAction(date));
      },
      builder: (BuildContext context, callback) {
        return Container(
          key: Key('CalendarKey'),
          height: 120.0,
          child: CalendarCarousel(
            weekFormat: true,
            isPrimary: false,
            locale: "ru",
            childAspectRatio: 1.5,
            isScrollable: false,
            weekdayTextStyle:
                TextStyle(color: Colors.grey[500], fontSize: 12.0),
            weekDayMargin: EdgeInsets.all(0.0),
            headerMargin: EdgeInsets.only(top: 16.0),
            todayButtonColor: Colors.transparent,
            iconColor: Colors.grey[500],
            selectedDayButtonColor: theme.primaryColorLight,
            showWeekDays: true,
            headerTextStyle: TextStyle(color: Colors.grey[500], fontSize: 24.0),
            prevDaysTextStyle: dayTextStyle,
            nextDaysTextStyle: dayTextStyle,
            daysTextStyle: dayTextStyle,
            weekendTextStyle: dayTextStyle,
            selectedDayTextStyle: dayTextStyle,
            todayTextStyle: dayTextStyle.copyWith(color: theme.primaryColor),
            onDayPressed: callback,
          ),
        );
      },
    );
  }

  final dayTextStyle = TextStyle(color: Colors.grey[500], fontSize: 24.0);
}
