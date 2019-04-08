import 'package:inmyfit/src/models/tablet_intake.dart';
import 'package:inmyfit/src/models/water_intake.dart';

void main() {
  testWaterAndTabletIntakesConverting();
}

void testWaterAndTabletIntakesConverting() {
  //Test water
  WaterIntake water = WaterIntake(
      goalToIntake: 10, type: WaterIntakeType.Glasses, completed: 5);
  var json = water.toJSON();
  print(json);
  water = WaterIntake.fromJSON(json);

  //Test tablets
  TabletsIntake tablets = TabletsIntake(
      completed: 1, countOfIntakes: 3, name: 'Penicilin', dosage: 1);
  json = tablets.toJSON();
  print(json);
  tablets = TabletsIntake.fromJSON(json);
}
