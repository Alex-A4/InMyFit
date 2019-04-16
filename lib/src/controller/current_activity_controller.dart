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
  final List<TabletsIntake> tablets;

  CurrentActivityController(this.water, this.tablets);

  /// Restore data from [SharedPreferences]
  static Future<CurrentActivityController> restoreFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('currentActivity');
    WaterIntake water;
    List<TabletsIntake> tablets;

    if (data != null) {
      Map<String, dynamic> json = _codec.decode(data);
      water = WaterIntake.fromJSON(json['water']);
      tablets = json['tablets']
          .map((tablet) => TabletsIntake.fromJSON(tablet))
          .toList();
    } else {
      water = WaterIntake.initDefault();
      tablets = [];
    }

    return CurrentActivityController(water, tablets);
  }

  /// Save data to local cache used [SharedPreferences]
  Future<void> saveToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = _codec.encode({
      'water': water.toJSON(),
      'tablets': tablets.map((tablet) => tablet.toJSON()).toList()
    });

    await prefs.setString('currentActivity', data);
  }
}
