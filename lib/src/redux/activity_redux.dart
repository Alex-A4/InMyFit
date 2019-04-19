import 'package:inmyfit/src/database/intake_db_provider.dart';
import 'package:inmyfit/src/models/water_intake.dart';
import 'package:inmyfit/src/models/tablet_intake.dart';

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

/// Action that needs to change completed value of [tablet]
/// [dayTime] variable contains info about the time of date, i.e. morning/afternoon/evening
class ChangeCompletedTabletsAction {
  /// This variable needs to identify object in list and update data
  final TabletsIntake tablet;
  final String dayTime;

  /// Index of [tablet] in list in [DayActivityController.tabletsIntake]
  final int index;

  ChangeCompletedTabletsAction({this.tablet, this.dayTime, this.index});
}

/// Action to update data of [CurrentActivityController]
/// This action also must update WaterIntake of today's [DayActivityController]
class UpdateCurrentControllerWater {
  // This two variables needs to create [CurrentActivityController] with new [WaterIntakes]
  final WaterIntakeType type;
  final int goalToIntake;

  /// This variable creates in middlewater and needs to update state in reducer
  /// [controller] is instance where updates water data
  final CurrentActivityController controller;
  final DayActivityController dayController;

  UpdateCurrentControllerWater(
      {this.type, this.goalToIntake, this.controller, this.dayController});
}

///
///
///
/// MAIN REDUCER
///
///
///

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
        currentActivityController: state.currentActivityController,
        dayActivityController: DayActivityController(
          state.dayActivityController.todaysDate,
          water: action.water,
          tablets: state.dayActivityController.tabletsIntake,
        ),
      );
  }

  if (action is ChangeCompletedTabletsAction) {
    if (action.tablet != null) {
      var list = state.dayActivityController.tabletsIntake;
      list[action.index] = action.tablet;
      return ActivityState(
        currentActivityController: state.currentActivityController,
        dayActivityController: DayActivityController(
          state.dayActivityController.todaysDate,
          water: state.dayActivityController.waterIntake,
          tablets: list,
        ),
      );
    }
  }

  /// This action must provide [CurrentActivityController] to update state
  if (action is UpdateCurrentControllerWater) {
    if (action.controller != null) {
      return ActivityState(
        currentActivityController: action.controller,
        dayActivityController: action.dayController,
      );
    }
  }

  //Return previous state if unknown action
  return state;
}

///
///
///
/// WATER MIDDLEWARE
///
///

/// Redux middleware function to communicate with DB
/// and handle actions depends on [WaterIntake]
void waterActionMiddleware(
    Store<ActivityState> store, action, NextDispatcher next) async {
  ///Read DB and get data by specified date, after that create new controller based on data
  if (action is FetchDataAction) {
    var date = DayActivityController.getPrimitiveDate(action.date);

    //Read info from db
    readDayIntakes(date).then((list) {
      //If instance of water does not exist then create new based on basic
      var water = list[1] ??
          WaterIntake.initOnBasic(store.state.currentActivityController.water);

      /// If [date] is today's then check water data for correctness with [CurrentActivityController.water]
      /// If data is not correct then update it
      water =
          fixWaterByDate(date, water, store.state.currentActivityController);

      // If list of tablets from DB is empty then try to create new based on basic
      var tablets = list[0].isNotEmpty
          ? list[0]
          : List.generate(
              store.state.currentActivityController.tablets.length,
              (index) => TabletsIntake.initOnBasic(
                  store.state.currentActivityController.tablets[index]),
            );

      store.dispatch(FetchDataSuccessAction(
        DayActivityController(
          date,
          tablets: tablets,
          water: water,
        ),
      ));
    });
  }

  /// Update DB instance and update UI
  if (action is ChangeCompletedWaterAction) {
    DayActivityController prev = store.state.dayActivityController;

    ///If 'prev' date before or after current then do not change
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

  /// Update [CurrentActivityController] with new [WaterIntakes] based on incoming data
  if (action is UpdateCurrentControllerWater) {
    CurrentActivityController controller =
        store.state.currentActivityController;
    DayActivityController dayController = store.state.dayActivityController;

    // Updated water of CurrentActivityController
    var water = WaterIntake(
      completed: null,
      goalToIntake: action.goalToIntake,
      type: action.type,
    );
    controller = CurrentActivityController(water, controller.tablets);

    //Update water of DayActivityController if there is today's date
    var waterDay = fixWaterByDate(
        dayController.todaysDate, dayController.waterIntake, controller);

    // Update action to send it next in reducer
    action = UpdateCurrentControllerWater(
      controller: controller,
      dayController: DayActivityController(dayController.todaysDate,
          water: waterDay, tablets: dayController.tabletsIntake),
    );

    // Update data in SharedPrefs and in DB
    controller.saveToLocal();
    IntakeDBProvider.db.updateWaterIntake(waterDay, dayController.todaysDate);
  }

  //Call next reducers
  next(action);
}

///
///
///
/// TABLETS MIDDLEWARE
///
///
///

/// Redux middleware to function to communicate with DB and
/// handle actions of [TabletsIntake]
void tabletsActionMiddleware(
    Store<ActivityState> store, action, NextDispatcher next) async {
  /// Update DB data and UI
  if (action is ChangeCompletedTabletsAction) {
    DayActivityController prev = store.state.dayActivityController;
    var tablet, index;

    ///If 'prev' date before or after current then do not change
    /// else change data, update DB and send it to UI
    if (prev.compareDate(DateTime.now()) == 0) {
      /// Index of tablet in list
      index = prev.tabletsIntake.indexOf(action.tablet);
      var prevTablet = prev.tabletsIntake[index];

      /// Reverse value by specified [action.dayTime]
      /// For good working this method [completed] must contain [action.dayTime]
      /// or it will lead to unexpected behaviour
      var completed = prev.tabletsIntake[index].completed;
      completed[action.dayTime] = !completed[action.dayTime];

      tablet = TabletsIntake(
        countOfIntakes: prevTablet.countOfIntakes,
        name: prevTablet.name,
        dosage: prevTablet.dosage,
        completed: completed,
      );

      // Update data in DB
      IntakeDBProvider.db
          .updateTabletsIntake(tablet, prev.todaysDate)
          .catchError((error) => print(error));
    } else
      //Put null to not update UI
      tablet = null;

    // Update tablet in action to change UI
    action = ChangeCompletedTabletsAction(
        dayTime: null, tablet: tablet, index: index);
  }

  /// Required call of next middleware or reducer
  next(action);
}

///
///
///
/// SUPPORT'S FUNCTIONS
///
///
///

/// If [date] is today's then check water data for correctness with [CurrentActivityController.water]
/// If data is not correct then update it
WaterIntake fixWaterByDate(
    DateTime date, WaterIntake water, CurrentActivityController controller) {
  var todaysDate = DayActivityController.getPrimitiveDate(DateTime.now());

  if (date == todaysDate && water != controller.water) {
    WaterIntake currentWater = controller.water;
    // Whether completed more then new goal
    var completed = water.completed > currentWater.goalToIntake
        ? currentWater.goalToIntake
        : water.completed;

    water = WaterIntake(
      completed: completed,
      goalToIntake: currentWater.goalToIntake,
      type: currentWater.type,
    );
  }

  return water;
}

/// Read data about intakes from DB by specified [date], that must be primitive
Future readDayIntakes(DateTime date) async {
  IntakeDBProvider db = IntakeDBProvider.db;
  List list =
      await Future.wait([db.getTabletsByDate(date), db.getWaterByDate(date)])
          .catchError((error) => print(error));
  return list;
}
