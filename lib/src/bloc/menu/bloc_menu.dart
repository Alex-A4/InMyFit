import 'package:bloc/bloc.dart';
import 'package:inmyfit/src/controller/current_activity_controller.dart';
import 'package:inmyfit/src/controller/day_activity_controller.dart';
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
      //TODO: load info
      //TODO: there must be initialized repositories for all menu elements

      ///Initialize controllers for ActivityRedux
      var currentController =
          await CurrentActivityController.restoreFromCache();

      activityStore = Store<ActivityState>(
        activityReducer,
        initialState: ActivityState(
          dayActivityController: DayActivityController(DateTime.now()),
          currentActivityController: currentController,
        ),
        middleware: [fetchActionMiddleware],
      );

      yield StateActivityLog(activityStore);
    }

    if (event is EventActivityLog) yield StateActivityLog(activityStore);

    if (event is EventGuides) yield StateGuides();

    if (event is EventMyFit) yield StateMyFit();

    if (event is EventProfile) yield StateProfile();

    if (event is EventShop) yield StateShop();
  }
}
