///PDO that describes water intake per one day
class TabletsIntake {
  ///The name of tablets
  final String name;

  ///The number of tablets which need to take for one time
  final int dosage;

  /// How many times per day need to intake tablets
  /// It must be one of [1, 2, 3]
  final int countOfIntakes;

  /// Schedule of completed intakes
  /// Describes current user activity, i.e. schedule that user follows
  /// Looks like: {
  ///   'morning' : false,
  ///   'afternoon' : true,
  ///   'evening' : false,
  /// }
  /// In string above map looks: FFT, afternoon on last place
  ///
  /// This map means that user had completed afternoon intake
  /// For more see [getCompletedInString] and [getDefaultCompleted]
  final Map<String, bool> completed;

  /// Private constructor
  TabletsIntake._(
      {this.name, this.countOfIntakes, this.dosage, this.completed});

  /// Factory to create new instance of [TabletsIntake]
  factory TabletsIntake({dosage, countOfIntakes, name, completed}) {
    return TabletsIntake._(
        dosage: dosage,
        name: name,
        countOfIntakes: countOfIntakes,
        completed: fixCompleted(completed, countOfIntakes) ??
            getDefaultCompleted(countOfIntakes));
  }

  /// Factory to create instance based on [basic] that got from CurrentActivityController
  /// This needs to create empty instance based on data
  factory TabletsIntake.initOnBasic(TabletsIntake basic) {
    return TabletsIntake(
      countOfIntakes: basic.countOfIntakes,
      dosage: basic.dosage,
      name: basic.name,
    );
  }

  /// Get default map of completed intakes depends on [count] of intakes
  /// If count == 1 then intake in morning
  /// if count == 2 then intakes in morning and evening
  /// If count == 3 then intakes in all three time of day
  static Map<String, bool> getDefaultCompleted(int count) {
    Map<String, bool> map = {};

    // count == 1 or more
    if (count >= 1) map['morning'] = false;
    // count == 3
    if (count == 3) map['afternoon'] = false;
    // count == 2 or more
    if (count >= 2) map['evening'] = false;

    return map;
  }

  /// Fix [completed] variable if [countOfIntakes] was changed
  static Map<String, bool> fixCompleted(
      Map<String, bool> prevCompleted, int countOfIntakes) {
    if (prevCompleted == null) return null;

    Map<String, bool> newCompleted = {};
    if (countOfIntakes >= 1)
      newCompleted['morning'] = prevCompleted['morning'] ?? false;
    if (countOfIntakes >= 2)
      newCompleted['evening'] = prevCompleted['evening'] ?? false;
    if (countOfIntakes >= 3)
      newCompleted['afternoon'] = prevCompleted['afternoon'] ?? false;

    return newCompleted;
  }

  ///Factory to restore object from JSON
  factory TabletsIntake.fromJSON(Map<String, dynamic> data) {
    return TabletsIntake._(
        dosage: data['dosage'],
        completed: getCompletedFromString(data['completed']),
        name: data['name'],
        countOfIntakes: data['countOfIntakes']);
  }

  ///Covert object to JSON
  Map<String, dynamic> toJSON() => {
        'name': name,
        'dosage': dosage,
        'countOfIntakes': countOfIntakes,
        'completed': getCompletedInString(),
      };

  /// Convert [completed] to string representation to store in DB
  /// If there was
  /// {'morning' : true}, then it will be converted to 'T'
  /// If there was
  /// {
  ///   'morning' : false,
  ///   'afternoon': false
  ///   'evening' : true,
  /// }
  /// then it will be converted to 'FTF', afternoon on last place
  String getCompletedInString() {
    String compl = '';

    // Morning symbol
    compl = compl +
        (completed['morning'] != null
            ? convertBoolToString(completed['morning'])
            : '');
    // Afternoon symbol
    compl = compl +
        (completed['afternoon'] != null
            ? convertBoolToString(completed['afternoon'])
            : '');
    // Evening symbol
    compl = compl +
        (completed['evening'] != null
            ? convertBoolToString(completed['evening'])
            : '');

    return compl;
  }

  /// Return 'T' if [compl] is true and 'F' otherwise
  String convertBoolToString(bool compl) {
    return compl ? 'T' : 'F';
  }

  /// Convert [data] string to [Map] representation of [cpmpleted] variable
  /// This method is reverse to [getCompletedInString]
  static Map getCompletedFromString(String data) {
    Map<String, bool> map = {};

    if (data.length >= 1) map['morning'] = convertStringToBool(data[0]);
    if (data.length >= 2) map['evening'] = convertStringToBool(data[1]);
    if (data.length >= 3) map['afternoon'] = convertStringToBool(data[2]);

    return map;
  }

  /// Return true if [symbol] is 'T' and false otherwise
  static bool convertStringToBool(String symbol) {
    if (symbol.compareTo('T') == 0) return true;
    return false;
  }

  /// Operator == to compare [other] to this
  /// Two tablets are equals if they names are
  /// This needs to check containing tablets after creating or updating
  @override
  bool operator ==(dynamic other) {
    if (other is! TabletsIntake) return false;

    if (other.name == this.name) return true;

    return false;
  }

  @override
  int get hashCode => name.hashCode * dosage;

  @override
  String toString() =>
      'dosage : $dosage, name: $name, countOfIntakes: $countOfIntakes'
      '\ncompleted: ${completed.toString()}';
}
