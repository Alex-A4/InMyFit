import 'package:equatable/equatable.dart';

//Basic class that describes event of menu
abstract class MenuEvent extends Equatable {}

//MenuStarted event. This must be dispatched to initialize menu variables
class EventMenuStarted extends MenuEvent {
  @override
  String toString() => 'EventMenuStarted';
}

//ActivityLog event
class EventActivityLog extends MenuEvent {
  @override
  String toString() => 'EventActivityLog';
}

//Guides event
class EventGuides extends MenuEvent {
  @override
  String toString() => 'EventGuides';
}

//MyFit event
class EventMyFit extends MenuEvent {
  @override
  String toString() => 'EventMyFit';
}

//Shop event
class EventShop extends MenuEvent {
  @override
  String toString() => 'EventShop';
}

//Profile event
class EventProfile extends MenuEvent {
  @override
  String toString() => 'EventProfile';
}
