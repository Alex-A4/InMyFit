import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/bloc/menu/menu.dart';
import 'package:inmyfit/src/custom_bottom_bar.dart';
import 'package:inmyfit/src/guides/ui/guides_main.dart';
import 'package:inmyfit/src/myfit/ui/myfit_main.dart';
import 'package:inmyfit/src/profile/ui/profile_main.dart';
import 'package:inmyfit/src/shop/ui/shop_main.dart';

import 'activity/ui/activity_log.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  MenuBloc bloc;

  //List of events which will be send to bloc when bottom bar tapped
  final List<MenuEvent> _events = [
    EventActivityLog(),
    EventGuides(),
    EventMyFit(),
    EventShop(),
    EventProfile()
  ];

  int barIndex = 0;

  //List of bottom bar items
  final List<MyFitAppBarItem> _items = [
    const MyFitAppBarItem(
      icon: 'assets/bottomBar/activity.png',
      title: 'ActivityLog',
    ),
    const MyFitAppBarItem(
      icon: 'assets/bottomBar/guide.png',
      title: 'Guides',
    ),
    const MyFitAppBarItem(
      icon: 'assets/bottomBar/myfit.png',
      title: 'MyFit',
    ),
    const MyFitAppBarItem(
      icon: 'assets/bottomBar/shop.png',
      title: 'Shop',
    ),
    const MyFitAppBarItem(
      icon: 'assets/bottomBar/profile.png',
      title: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    bloc = MenuBloc();
    bloc.dispatch(EventMenuStarted());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenuBloc>(
      bloc: bloc,
      child: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          Widget body = getBodyBasedOnState(state);

          return Scaffold(
            body: body,
            bottomNavigationBar: getBottomBar(),
          );
        },
      ),
    );
  }

  //Get the BottomBar widget
  Widget getBottomBar() {
    return MyFitAppBar(
      items: _items,
      iconSize: 25.0,
      height: 60.0,
      backgroundColor: Colors.grey[600],
      inactiveIconColor: Colors.white,
      activeIconColor: theme.primaryColor,
      onTabSelected: (index) {
        barIndex = index;
        bloc.dispatch(_events[index]);
      },
    );
  }

  //Get the body of scaffold that based on MenuState
  Widget getBodyBasedOnState(MenuState state) {
    Widget body = Container();

    if (state is StateMenuStarted)
      body = Center(child: const CircularProgressIndicator());
    if (state is StateActivityLog) body = const ActivityLog();
    if (state is StateMyFit) body = const MyFit();
    if (state is StateGuides) body = const Guides();
    if (state is StateProfile) body = const Profile();
    if (state is StateShop) body = const Shop();

    return body;
  }
}
