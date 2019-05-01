import 'package:inmyfit/src/controller/notification_controller.dart';
import 'package:inmyfit/src/database/intake_db_provider.dart';
import 'package:inmyfit/src/models/date_interval.dart';
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

/// Action to update old or add new [TabletsIntake] to [CurrentActivityController]
/// It will try to update instance into DB and if there is no data then add new
class AddOrUpdateTabletsDataAction {
  /// Instance that send from middleware to reducer
  final TabletsIntake tablet;

  // If need to add new instance then [interval] must not be null
  final DateInterval interval;

  // This controller will be send to reducer from middleware
  final DayActivityController dayController;

  AddOrUpdateTabletsDataAction(
      {this.tablet, this.interval, this.dayController});
}

/// Action to delete [TabletsIntake] from [CurrentActivityController]
class DeleteTabletsAction {
  /// Tablet that need to delete
  final TabletsIntake tablet;

  /// Controller that will be send from middleware to reducer after converting
  final CurrentActivityController controller;

  DeleteTabletsAction({this.tablet, this.controller});
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
  ///Start fetching data and show some indicator
  if (action is FetchDataAction)
    return ActivityState(
      currentActivityController: state.currentActivityController,
      dayActivityController: state.dayActivityController,
      //Start fetching to show spinner
      isFetching: true,
    );

  ///Stop fetching and show data
  if (action is FetchDataSuccessAction)
    return ActivityState(
      currentActivityController: state.currentActivityController,
      dayActivityController: action.controller,
      //Stop fetching and hide spinner
      isFetching: false,
    );

  /// Update [DayActivityController] depends on new instance of [action.water]
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

  /// Update instance of tablet in list by provided [action.index]
  /// This index indicate previous instance of tablet in list that need update
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

  /// This action must provide [DayActivityController] to update state with
  /// updated data
  if (action is AddOrUpdateTabletsDataAction) {
    if (action.dayController != null)
      return ActivityState(
        currentActivityController: state.currentActivityController,
        dayActivityController: action.dayController,
      );
  }

  /// This action must provide [CurrentActivityController] to update state with
  /// deleted tablets
  if (action is DeleteTabletsAction) {
    if (action.controller != null) {
      var dayController = checkAndMergeDayAndCurrentActivities(
          state.dayActivityController, action.controller);
      return ActivityState(
        currentActivityController: action.controller,
        dayActivityController: dayController,
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
      var tablets = list[0];
      if (tablets.isEmpty) {
        store.state.currentActivityController.tablets
            .forEach((interval, tablet) {
          if (interval.isContainsDate(DateTime.now()))
            tablets.add(TabletsIntake.initOnBasic(tablet));
        });
      }
      var controller = DayActivityController(
        date,
        tablets: tablets,
        water: water,
      );
      controller = checkAndMergeDayAndCurrentActivities(
          controller, store.state.currentActivityController);
      store.dispatch(FetchDataSuccessAction(controller));
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

    /// Update notifications with new and old water instance
    NotificationController.getInstance().scheduleWaterNotification(water);

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
  /// Firstly check data for existing and then add new or update old
  if (action is AddOrUpdateTabletsDataAction) {
    var newTablet = action.tablet;
    var tablets = store.state.currentActivityController.tablets;
    DateInterval interval;
    bool changed = false;
    var today;
    // If tablets are equals then update data
    // Two tablets are equals if their names are equals
    tablets.forEach((date, tablet) {
      if (tablet == newTablet) {
        tablets[date] = newTablet;
        changed = true;
        interval = date;
        today = DateTime.now();
      }
    });

    // If this is not update action then add new tablet
    if (!changed) {
      tablets[action.interval] = newTablet;
      interval = action.interval;
    }

    /// Set up notification for that tablet
    NotificationController.getInstance()
        .scheduleTabletsNotification(interval, newTablet, today);

    /// If date of [DayActivityController] inside of interval then
    /// update it's tablets data and action
    if (interval.isContainsDate(store.state.dayActivityController.todaysDate)) {
      var dayController = checkAndMergeDayAndCurrentActivities(
        store.state.dayActivityController,
        store.state.currentActivityController,
      );
      action = AddOrUpdateTabletsDataAction(dayController: dayController);
    }
    // Save data to local
    store.state.currentActivityController.saveToLocal();
  }

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

  if (action is DeleteTabletsAction) {
    /// Delete specified tablets
    var tablets = store.state.currentActivityController.tablets;
    tablets.removeWhere((interval, tablet) {
      if (tablet == action.tablet) {
        /// Cancel notification of that tablet
        NotificationController.getInstance()
            .cancelTabletNotification(interval, tablet);
        return true;
      }
      return false;
    });

    /// Update controller and send it to reducer
    var controller = CurrentActivityController(
        store.state.currentActivityController.water, tablets);
    action = DeleteTabletsAction(controller: controller);

    /// Save updated data
    controller.saveToLocal();
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

/// Check is [currentController] contains some information about tablets
/// by specified date that [dayController] don't
/// And if it's true then copy some [TabletsIntake] instances to [DayActivityController]
DayActivityController checkAndMergeDayAndCurrentActivities(
    DayActivityController dayController,
    CurrentActivityController currentController) {
  List<TabletsIntake> newTablets = [];

  currentController.tablets.forEach((date, tablet) {
    /// Variable to check is tablet exist in dayController
    bool isExist = false;
    if (date.isContainsDate(dayController.todaysDate))
      dayController.tabletsIntake.forEach((dayTablet) {
        // If names of tablets is equals and data not equals then update data
        // else if names equals then copy old data else create new instance
        if (tablet == dayTablet && !isTabletsEquals(tablet, dayTablet)) {
          newTablets.add(TabletsIntake(
            dosage: tablet.dosage,
            countOfIntakes: tablet.countOfIntakes,
            name: tablet.name,
            //Completed will be fixed in constructor
            completed: dayTablet.completed,
          ));
          isExist = true;
        }
        //Copy data
        else if (tablet == dayTablet) {
          newTablets.add(dayTablet);
          isExist = true;
        }
      });
    //Create new instance if tablets was not exist and it is inside interval
    if (!isExist && date.isContainsDate(dayController.todaysDate)) {
      newTablets.add(TabletsIntake.initOnBasic(tablet));
      isExist = true;
    }
  });

  return DayActivityController(
    dayController.todaysDate,
    water: dayController.waterIntake,
    tablets: newTablets,
  );
}

/// Check whether data of [tablet1] equals to data of [tablet2]
bool isTabletsEquals(TabletsIntake tablet1, TabletsIntake tablet2) {
  return tablet1.dosage == tablet2.dosage &&
      tablet1.countOfIntakes == tablet2.countOfIntakes;
}

// Close the DB
void closeDB() {
  IntakeDBProvider.db.closeDB().catchError((error) => print(error));
}
