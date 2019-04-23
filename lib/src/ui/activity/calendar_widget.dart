import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/redux/activity_redux.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  DateTime _selectedDate;

  CalendarWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<ActivityState, Function(DateTime)>(
      converter: (store) {
        return (date) => store.dispatch(FetchDataAction(date));
      },
      builder: (BuildContext context, callback) {
        return Container(
          child: TableCalendar(
            selectedDay: _selectedDate,
            onDaySelected: (date, list) {
              _selectedDate = date;
              callback(date);
            },
            calendarStyle: CalendarStyle(
              weekendStyle: dayTextStyle,
              selectedColor: theme.primaryColor,
              todayStyle: dayTextStyle.copyWith(color: theme.primaryColor),
              todayColor: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              weekdayStyle: dayTextStyle,
              outsideDaysVisible: false,
              selectedStyle: dayTextStyle.copyWith(color: Colors.white),
            ),
            headerStyle: HeaderStyle(
              formatButtonColor: greyColor,
              formatButtonSize: 35.0,
              titleTextStyle: dayTextStyle,
              titleTextBuilder: (date, locale) {
                String dateStr = DateFormat.yMMMM(locale).format(date).trim();
                dateStr = dateStr.replaceRange(dateStr.length-3, dateStr.length, '');
                var first= dateStr.substring(0, 1);
                dateStr = dateStr.replaceFirst(first, first.toUpperCase());
                return dateStr;
              },
              leftChevronIcon: Icon(
                Icons.keyboard_arrow_left,
                size: 30.0,
                color: greyColor,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                size: 30.0,
                color: greyColor,
              ),
              leftChevronPadding: EdgeInsets.all(0.0),
              rightChevronPadding: EdgeInsets.all(0.0),
            ),
            availableCalendarFormats: {
              CalendarFormat.month: Icons.arrow_drop_down,
              CalendarFormat.week: Icons.arrow_drop_up,
            },
            daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: dayTextStyle.copyWith(fontSize: 15.0),
                weekendStyle: dayTextStyle.copyWith(fontSize: 15.0)),
            availableGestures: AvailableGestures.horizontalSwipe,
            startingDayOfWeek: StartingDayOfWeek.monday,
            initialCalendarFormat: CalendarFormat.week,
            locale: "ru_RU",
          ),
        );
      },
    );
  }

  static final greyColor = Colors.grey[500];
  final dayTextStyle = TextStyle(color: greyColor, fontSize: 21.0, fontFamily: 'ProstoSans');
}
