import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

abstract class MenuState extends Equatable {}

//MenuStarted state, download helpful info
class StateMenuStarted extends MenuState {
  @override
  String toString() => 'StateMenuStarted';
}

/// ActivityLog state
/// Contains store from for fast access to that
class StateActivityLog extends MenuState {
  final Store store;

  StateActivityLog(this.store);

  @override
  String toString() => 'StateActivityLog';
}

//Guides state
class StateGuides extends MenuState {
  @override
  String toString() => 'StateGuides';
}

//MyFit state
class StateMyFit extends MenuState {
  @override
  String toString() => 'StateMyFit';
}

//Shop state
class StateShop extends MenuState {
  @override
  String toString() => 'StateShop';
}

//Profile state
class StateProfile extends MenuState {
  @override
  String toString() => 'StateProfile';
}
