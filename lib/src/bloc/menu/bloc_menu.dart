import 'package:bloc/bloc.dart';
import 'package:inmyfit/src/activity/controller/current_activity_controller.dart';
import 'package:inmyfit/src/activity/controller/day_activity_controller.dart';
import 'package:inmyfit/src/activity/controller/notification_controller.dart';
import 'package:inmyfit/src/activity/redux/activity_redux.dart';
import 'menu.dart';
import 'package:redux/redux.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  Store<ActivityState> activityStore;

  @override
  MenuState get initialState => StateMenuStarted();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is EventMenuStarted) {
      await initializeActivity();
      yield StateActivityLog();
    }

    if (event is EventActivityLog) yield StateActivityLog();

    if (event is EventGuides) yield StateGuides();

    if (event is EventMyFit) yield StateMyFit();

    if (event is EventProfile) yield StateProfile();

    if (event is EventShop) yield StateShop();
  }

  /// Initialize activity store by reading all from DB and cache
  Future<void> initializeActivity() async {
    var date = DayActivityController.getPrimitiveDate(DateTime.now());

    ///Initialize controllers for ActivityRedux
    var currentController = await CurrentActivityController.restoreFromCache();
    var dayController = await readDayIntakes(date, currentController);

    /// Check is notifications bounded
    /// If not, then bind them
    NotificationController notifications =
        await NotificationController.getInstance();
    if (!await notifications.isNotificationsBounded()) {
      currentController.tablets.forEach((interval, tablet) =>
          notifications.scheduleTabletsNotification(interval, tablet));
      notifications.scheduleWaterNotification(currentController.water);
    }

    activityStore = Store<ActivityState>(
      activityReducer,
      initialState: ActivityState(
        dayActivityController: dayController,
        currentActivityController: currentController,
      ),
      middleware: [waterActionMiddleware, tabletsActionMiddleware],
    );
  }

  @override
  void dispose() {
    closeDB();
    super.dispose();
  }
}
