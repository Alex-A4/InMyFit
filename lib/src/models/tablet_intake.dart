///PDO that describes water intake per one day
class TabletsIntake {
  ///The name of tablets
  final String name;

  ///The number of tablets which need to take for one time
  final int dosage;

  /// How many times per day need to intake tablets
  /// It must be one of [1, 2, 3]
  final int countOfIntakes;

  ///The number of tablets intake that completed
  ///
  /// To describes current user activity, i.e. schedule that user follows
  /// this variable must be null
  final int completed;

  TabletsIntake({this.dosage, this.countOfIntakes, this.completed, this.name});

  ///Factory to restore object from JSON
  factory TabletsIntake.fromJSON(Map<String, dynamic> data) {
    return TabletsIntake(
        dosage: data['dosage'],
        completed: data['completed'],
        name: data['name'],
        countOfIntakes: data['countOfIntakes']);
  }

  
  ///Covert object to JSON
  Map<String, dynamic> toJSON() => {
        'dosage': dosage,
        'completed': completed,
        'name': name,
        'countOfIntakes': countOfIntakes,
      };
}
