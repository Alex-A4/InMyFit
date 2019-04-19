import 'package:bloc/bloc.dart';
import 'package:inmyfit/src/controller/current_activity_controller.dart';
import 'package:inmyfit/src/controller/day_activity_controller.dart';
import 'package:inmyfit/src/models/water_intake.dart';
import 'menu.dart';
import 'package:redux/redux.dart';
import '../../redux/activity_redux.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  Store<ActivityState> activityStore;

  @override
  MenuState get initialState => StateMenuStarted();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is EventMenuStarted) {
      var date = DayActivityController.getPrimitiveDate(DateTime.now());

      ///Initialize controllers for ActivityRedux
      var currentController =
          await CurrentActivityController.restoreFromCache();
      var intakes = await readDayIntakes(date);
      if (intakes[1] == null)
        intakes[1] = WaterIntake.initOnBasic(currentController.water);

      var dayController = DayActivityController(
        date,
        tablets: intakes[0],
        water: intakes[1],
      );

      activityStore = Store<ActivityState>(
        activityReducer,
        initialState: ActivityState(
          dayActivityController: dayController,
          currentActivityController: currentController,
        ),
        middleware: [waterActionMiddleware, tabletsActionMiddleware],
      );

      yield StateActivityLog(activityStore);
    }

    if (event is EventActivityLog) yield StateActivityLog(activityStore);

    if (event is EventGuides) yield StateGuides();

    if (event is EventMyFit) yield StateMyFit();

    if (event is EventProfile) yield StateProfile();

    if (event is EventShop) yield StateShop();
  }

  @override
  void dispose() {
    closeDB();
    super.dispose();
  }
}
