import 'package:inmyfit/src/models/date_interval.dart';

import '../models/tablet_intake.dart';
import '../models/water_intake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show JsonCodec;

/// This controller contains information about intakes that user set up in settings
/// There are only rules for [DayActivityController] and no real data
class CurrentActivityController {
  ///Codec to convert to/from json string
  static JsonCodec _codec = JsonCodec();

  ///Info about water, [WaterIntake.completed] parameter must be null
  /// If the app launched first and user have no activity then create default
  final WaterIntake water;

  ///Info about tablets, [TabletsIntake.completed] parameter must be null
  /// If the app launched first and user have no activity then it's null
  ///
  /// Because count of tablets can be more than 1, then [_tablets] is a list of
  /// [TabletsIntake]
  final Map<DateInterval, TabletsIntake> tablets;

  CurrentActivityController(this.water, this.tablets);

  /// Restore data from [SharedPreferences]
  static Future<CurrentActivityController> restoreFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('currentActivity');
    WaterIntake water;
    Map<DateInterval, TabletsIntake> tablets;

    if (data != null) {
      Map<String, dynamic> json = _codec.decode(data);
      water = WaterIntake.fromJSON(json['water']);
      tablets = tabletsFromJSON(json['tablets']);
    } else {
      water = WaterIntake.initDefault();
      tablets = {};
    }

    return CurrentActivityController(water, tablets);
  }

  /// Save data to local cache used [SharedPreferences]
  Future<void> saveToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var map = convertTabletsToJSON();

    String data = _codec.encode({
      'water': water.toJSON(),
      'tablets': map,
    });

    await prefs.setString('currentActivity', data);
  }

  /// Fill map of '[DateInterval] : [TabletsIntake]' pairs from JSON object
  static Map<DateInterval, TabletsIntake> tabletsFromJSON(Map tabl) {
    Map<DateInterval, TabletsIntake> tablets = {};
    if (tabl.isNotEmpty)
      tabl.forEach((date, tablet) => tablets[DateInterval.fromJSON(date)] =
          TabletsIntake.fromJSON(tablet));

    return tablets;
  }

  /// Convert tablets to map with pairs:
  /// '[DateInterval.toJSON()] : [TabletsIntake.toJSON()]'
  Map<Map, Map> convertTabletsToJSON() {
    Map<Map, Map> map = {};
    tablets.forEach((date, tablet) => map[date.toJSON()] = tablet.toJSON());
    return map;
  }
}
