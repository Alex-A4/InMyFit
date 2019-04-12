import 'package:inmyfit/src/database/intake_db_provider.dart';
import 'package:inmyfit/src/models/water_intake.dart';

import '../controller/day_activity_controller.dart';
import '../controller/current_activity_controller.dart';
import 'package:redux/redux.dart';

/// Class that describes state for redux
///
/// Contains information about [dayActivityController] that contains info about
/// current selected day. [currentActivityController] contains info about set settings
/// and [isFetching] that describes is some data fetching
///
/// Both controllers must be initialized before using it
class ActivityState {
  final DayActivityController dayActivityController;
  final CurrentActivityController currentActivityController;
  final bool isFetching;

  ActivityState({
    this.dayActivityController,
    this.currentActivityController,
    this.isFetching = false,
  });
}

/// Action that needs to fetch data by specified [date]
class FetchDataAction {
  DateTime date;

  FetchDataAction(this.date);
}

/// Action that needs to updated controller for selected day
class FetchDataSuccessAction {
  final DayActivityController controller;

  FetchDataSuccessAction(this.controller);
}

/// Action that needs to change count of completed vessels
/// If [isFilled] true then increase count else decrease
class ChangeCompletedWaterAction {
  final bool isFilled;
  final WaterIntake water;

  ChangeCompletedWaterAction({this.isFilled, this.water});
}

/// Redux reducer to communicate between UI and store
ActivityState activityReducer(ActivityState state, action) {
  if (action is FetchDataAction)
    return ActivityState(
      currentActivityController: state.currentActivityController,
      dayActivityController: state.dayActivityController,
      //Start fetching to show spinner
      isFetching: true,
    );
  if (action is FetchDataSuccessAction)
    return ActivityState(
      currentActivityController: state.currentActivityController,
      dayActivityController: action.controller,
      //Stop fetching and hide spinner
      isFetching: false,
    );

  if (action is ChangeCompletedWaterAction) {
    //If it's modified water then update state
    if (action.water != null)
      return ActivityState(
        isFetching: false,
        dayActivityController: DayActivityController(
          state.dayActivityController.todaysDate,
          water: action.water,
          tablets: state.dayActivityController.tabletsIntake,
        ),
      );
  }
  //Return previous state if unknown action
  return state;
}

/// Redux middleware function to communicate with DB
void fetchActionMiddleware(
    Store<ActivityState> store, action, NextDispatcher next) async {
  ///Read DB and get data by specified date, after that create new controller based on data
  if (action is FetchDataAction) {
    var date = DayActivityController.getPrimitiveDate(action.date);

    //Read info from db
    readDayIntakes(date).then((list) => store.dispatch(FetchDataSuccessAction(
          DayActivityController(
            date,
            tablets: list[0],
            water: list[1],
          ),
        )));
  }

  /// Update DB instance and update UI
  if (action is ChangeCompletedWaterAction) {
    DayActivityController prev = store.state.dayActivityController;

    ///If 'prev' date before current then do not change
    /// else change data, update DB and send it to UI
    if (prev.compareDate(DateTime.now()) == 0) {
      var water = WaterIntake(
        goalToIntake: prev.waterIntake.goalToIntake,
        type: prev.waterIntake.type,
        completed: action.isFilled
            ? prev.waterIntake.completed + 1
            : prev.waterIntake.completed - 1,
      );

      ///Update action to send [water] to UI
      action = ChangeCompletedWaterAction(
        water: water,
      );

      IntakeDBProvider.db
          .updateWaterIntake(
              water, store.state.dayActivityController.todaysDate)
          .catchError((error) => print(error));
    }
  }

  //Call next reducers
  next(action);
}

/// Read data about intakes from DB by specified [date], that must be primitive
Future readDayIntakes(DateTime date) async {
  print(date.toUtc().toString());
  IntakeDBProvider db = IntakeDBProvider.db;
  List list =
      await Future.wait([db.getTabletsByDate(date), db.getWaterByDate(date)])
          .catchError((error) => print(error));
  return list;
}
