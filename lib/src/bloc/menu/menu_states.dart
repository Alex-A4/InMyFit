import 'package:equatable/equatable.dart';

abstract class MenuState extends Equatable {}

//MenuStarted state, download helpful info
class StateMenuStarted extends MenuState {
  @override
  String toString() => 'StateMenuStarted';
}

//ActivityLog state
class StateActivityLog extends MenuState {
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
