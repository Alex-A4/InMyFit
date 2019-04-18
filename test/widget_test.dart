import 'package:inmyfit/src/controller/current_activity_controller.dart';
import 'package:inmyfit/src/models/date_interval.dart';
import 'package:inmyfit/src/models/tablet_intake.dart';
import 'package:inmyfit/src/models/water_intake.dart';

void main() {
  testWaterAndTabletIntakesConverting();
  testCurrentControllerTabletsConverting();
}

void testWaterAndTabletIntakesConverting() {
  //Test water
  WaterIntake water = waterInt;
  var json = water.toJSON();
  print(json);
  water = WaterIntake.fromJSON(json);

  //Test tablets
  TabletsIntake tablets = tabletsInt;
  json = tablets.toJSON();
  print(json);
  json['completed'] = 'TFT';
  tablets = TabletsIntake.fromJSON(json);
  print(tablets);

  print('\n--------------------\n');
}

void testCurrentControllerTabletsConverting() {
  WaterIntake water = waterInt;
  DateInterval dates = DateInterval(
    startDate: DateTime(2018, 11, 12, 5),
    endDate: DateTime(2019, 1, 12, 16),
  );
  Map<DateInterval, TabletsIntake> tablets = {dates: tabletsInt};

  CurrentActivityController controller =
      CurrentActivityController(water, tablets);
  Map jsonTabl = controller.convertTabletsToJSON();
  print(jsonTabl);

  print(CurrentActivityController.tabletsFromJSON(jsonTabl));

  print('\n--------------------\n');
}

WaterIntake get waterInt =>
    WaterIntake(goalToIntake: 10, type: WaterIntakeType.Glasses, completed: 5);

TabletsIntake get tabletsInt =>
    TabletsIntake(countOfIntakes: 3, name: 'Penicilin', dosage: 1);
