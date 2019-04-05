import 'package:bloc/bloc.dart';
import 'menu.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {

  @override
  MenuState get initialState => StateMenuStarted();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async*{
    if (event is EventMenuStarted) {
      //TODO: load info
      //TODO: there must be initialized repositories for all menu elements
      yield StateActivityLog();
    }

    if (event is EventActivityLog)
      yield StateActivityLog();

    if (event is EventGuides)
      yield StateGuides();

    if (event is EventMyFit)
      yield StateMyFit();

    if (event is EventProfile)
      yield StateProfile();

    if (event is EventShop)
      yield StateShop();
  }
}