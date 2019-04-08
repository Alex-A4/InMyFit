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

  ChangeCompletedWaterAction(this.isFilled);
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
    DayActivityController prev = state.dayActivityController;

    //If 'prev' date before current then do not change
    if (prev.compareDate(DateTime.now()) >= 0)
      return ActivityState(
        currentActivityController: state.currentActivityController,
        dayActivityController: DayActivityController(
          //Copy date and tablets
          prev.todaysDate,
          tablets: prev.tabletsIntake,

          /// Update WaterIntake: if isFilled then increase else decrease
          water: WaterIntake(
            goalToIntake: prev.waterIntake.goalToIntake,
            type: prev.waterIntake.type,
            completed: action.isFilled
                ? prev.waterIntake.completed + 1
                : prev.waterIntake.completed - 1,
          ),
        ),
      );
  }
  //Return previous state if unknown action
  return state;
}

/// Redux middleware function to read data by specified date
void fetchActionMiddleware(
    Store<ActivityState> store, action, NextDispatcher next) {
  ///Read DB and get data by specified date, after create new controller based on data
  if (action is FetchDataAction) {
    var date = DayActivityController.getPrimitiveDate(action.date);

    ///TODO: read DB and create new DayActivityController

    store.dispatch(FetchDataSuccessAction(
      DayActivityController(DayActivityController.dateFromPrimitive(date)),
    ));
  }

  //Call next reducers
  next(action);
}
