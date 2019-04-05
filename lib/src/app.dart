import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inmyfit/main.dart';
import 'package:inmyfit/src/bloc/menu/menu.dart';
import 'package:inmyfit/src/ui/activity/activity_log.dart';
import 'package:inmyfit/src/ui/guides/guides_main.dart';
import 'package:inmyfit/src/ui/myfit/myfit_main.dart';
import 'package:inmyfit/src/ui/profile/profile_main.dart';
import 'package:inmyfit/src/ui/shop/shop_main.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  MenuBloc bloc;

  //List of events which will be send to bloc when bottom bar tapped
  List<MenuEvent> _events = [
    EventActivityLog(),
    EventGuides(),
    EventMyFit(),
    EventShop(),
    EventProfile()
  ];

  int barIndex = 0;

  //List of bottom bar items
  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/bottomBar/activity.png')),
      title: Text('ActivityLog'),
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/bottomBar/guide.png')),
      title: Text('Guides'),
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/bottomBar/myfit.png')),
      title: Text('MyFit'),
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/bottomBar/shop.png')),
      title: Text('Shop'),
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/bottomBar/profile.png')),
      title: Text('Profile'),
    ),
  ];


  @override
  void initState() {
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
    return Theme(
      data: ThemeData(
        canvasColor: Colors.grey[600],
        primaryColor: theme.primaryColor,
        textTheme: TextTheme(caption: TextStyle(color: Colors.white)),
      ),
      child: BottomNavigationBar(
        items: _items,
        iconSize: 25.0,
        currentIndex: barIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          barIndex = index;
          bloc.dispatch(_events[index]);
        },
      ),
    );
  }

  //Get the body of scaffold that based on MenuState
  Widget getBodyBasedOnState(MenuState state) {
    Widget body = Container();

    if (state is StateMenuStarted)
      body = Center(child: CircularProgressIndicator());
    if (state is StateActivityLog)
      body = ActivityLog();
    if (state is StateMyFit)
      body = MyFit();
    if (state is StateGuides)
      body = Guides();
    if (state is StateProfile)
      body = Profile();
    if (state is StateShop)
      body = Shop();

    return body;
  }
}
