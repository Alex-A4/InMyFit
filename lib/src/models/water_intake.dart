///PDO that describes water intake per one day
class WaterIntake {
  ///Type of vessel for water intake
  final WaterIntakeType type;

  ///The number of water intake which need to do
  final int goalToIntake;

  ///The number of water intake that completed
  ///
  /// To describes current user activity, i.e. schedule that user follows
  /// this variable must be null
  final int completed;

  WaterIntake({this.type, this.goalToIntake, this.completed});

  ///Set up initial intake with default parameters
  factory WaterIntake.init() {
    return WaterIntake(
        completed: 0, type: WaterIntakeType.Glasses, goalToIntake: 10);
  }

  ///Restore object from JSON
  factory WaterIntake.fromJSON(Map<String, dynamic> data) {
    WaterIntakeType type;
    switch (data['type']) {
      case 1:
        type = WaterIntakeType.Bottles;
        break;

      //i.e. glasses
      default:
        type = WaterIntakeType.Glasses;
        break;
    }

    return WaterIntake(
      completed: data['completed'],
      type: type,
      goalToIntake: data['goalToIntake'],
    );
  }

  ///Convert object to JSON
  Map<String, dynamic> toJSON() => {
        'type': type.index,
        'goalToIntake': goalToIntake,
        'completed': completed,
      };
}

///Enum that describes type of vessels for water intake
enum WaterIntakeType { Glasses, Bottles }
