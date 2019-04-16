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

  /// Set up initial intake with default parameters from [basic] instance
  /// that got from CurrentActivityController
  factory WaterIntake.initOnBasic(WaterIntake basic) {
    return WaterIntake(
        completed: 0, type: basic.type, goalToIntake: basic.goalToIntake);
  }

  /// Initialize WaterIntake when app launched first
  factory WaterIntake.initDefault() {
    return WaterIntake(
      completed: 0,
      goalToIntake: 10,
      type: WaterIntakeType.Glasses,
    );
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

  /// Return is [other] equals to 'this'
  @override
  bool operator ==(other) {
    if (other is! WaterIntake) return false;
    if (other.type == this.type && other.goalToIntake == this.goalToIntake)
      return true;

    return false;
  }
}

///Enum that describes type of vessels for water intake
enum WaterIntakeType { Glasses, Bottles }
