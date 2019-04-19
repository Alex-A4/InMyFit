import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/water_intake.dart';
import '../models/tablet_intake.dart';

/// Singleton instance of DB provider to read info about water/tablets intake
///
/// This provider contains methods to add, update, and get information
/// also contains methods to delete whole DB
class IntakeDBProvider {
  IntakeDBProvider._();

  //Singleton instance
  static final IntakeDBProvider db = IntakeDBProvider._();

  /// Database to store information about [WaterIntake] objects
  Database _waterDatabase;

  /// Database to store information about [TabletsIntake] objects
  Database _tabletsDatabase;

  Future<Database> get waterDb async {
    if (_waterDatabase == null) _waterDatabase = await getWaterDBInstance();

    return _waterDatabase;
  }

  Future<Database> get tabletsDb async {
    if (_tabletsDatabase == null)
      _tabletsDatabase = await getTabletsDBInstance();

    return _tabletsDatabase;
  }

  ///
  /// Water DB section
  ///

  ///Get the instance of DB where [WaterIntake] stores by date
  /// date stores in [millisecondsSinceEpoch] to restore [DateTime] object
  Future<Database> getWaterDBInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    String path = join(directory.path, 'data.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int vers) async {
      await db.execute(
        "CREATE TABLE Water ("
            "date INTEGER PRIMARY KEY,"
            "type INTEGER,"
            "goalToIntake INTEGER,"
            "completed INTEGER"
            ")",
      );
    });
  }

  /// Add new instance of [WaterIntake] to DB. [time] variable must be primitive
  Future addWaterIntakeToDB(WaterIntake water, DateTime time) async {
    final db = await waterDb;
    Map<String, dynamic> data = water.toJSON();
    data['date'] = time.millisecondsSinceEpoch;

    var raw = await db.insert(
      'Water',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  /// Update the instance of [WaterIntake] into DB. [time] variable must be primitive
  Future updateWaterIntake(WaterIntake water, DateTime time) async {
    final db = await waterDb;
    Map<String, dynamic> data = water.toJSON();
    data['date'] = time.millisecondsSinceEpoch;

    var response = await db.update('Water', data,
        where: 'date = ?',
        whereArgs: [data['date']],
        conflictAlgorithm: ConflictAlgorithm.replace);

    //If record is absent in DB
    if (response == 0) await addWaterIntakeToDB(water, time);

    return response;
  }

  /// Get the instance of [WaterIntake] from DB by specified [time], which must
  /// be primitive.
  /// If [response] is empty then return default instance else return first object
  /// in DB.
  Future<WaterIntake> getWaterByDate(DateTime time) async {
    final db = await waterDb;
    var response = await db.query(
      'Water',
      where: 'date = ?',
      whereArgs: [time.millisecondsSinceEpoch],
    );

    /// If there is no data about water by [time] then return null
    /// Reducer must handle that and init instance based on basic
    return response.isEmpty ? null : WaterIntake.fromJSON(response.first);
  }

  /// Delete whole [WaterIntake] database. Be careful using it!
  Future deleteWaterDB() async {
    final db = await waterDb;
    db.delete('Water');
  }

  ///
  /// Tablets DB section
  ///

  ///Get the instance of DB where [TabletsIntake] sorts by date
  /// date stores in [millisecondsSinceEpoch] to restore [DateTime] object
  ///
  /// completed values stores like String objects,
  /// for more information see [TabletsIntake.completed]
  Future<Database> getTabletsDBInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'data.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int vers) async {
      await db.execute(
        "CREATE TABLE Tablets ("
            "date INTEGER NOT NULL,"
            "name TEXT NOT NULL,"
            "dosage INTEGER,"
            "countOfIntakes INTEGER,"
            "completed TEXT,"
            "PRIMARY KEY(date, name)"
            ")",
      );
    });
  }

  /// Add new instance of [TabletsIntake] to DB. [time] variable must be primitive
  Future addTabletsIntakeToDB(TabletsIntake tablets, DateTime time) async {
    final db = await tabletsDb;
    Map<String, dynamic> data = tablets.toJSON();
    data['date'] = time.millisecondsSinceEpoch;

    var raw = await db.insert(
      'Tablets',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  /// Update the instance of [TabletsIntake] into DB. [date] variable must be primitive
  /// Updating occurs with [date] and [tablet.name] parameters
  Future updateTabletsIntake(TabletsIntake tablet, DateTime date) async {
    final db = await tabletsDb;
    Map<String, dynamic> data = tablet.toJSON();
    data['date'] = date.millisecondsSinceEpoch;

    var response = await db.update(
      'Tablets',
      data,
      where: 'date = ?, name = ?',
      whereArgs: [data['date'], data['name']],
    );

    //If record is absent in DB
    if (response == 0) addTabletsIntakeToDB(tablet, date);
    return response;
  }

  /// Get the list of [TabletsIntake] from DB by specified [time], which must
  /// be primitive.
  /// If [response] is empty then return empty list else return list of tablets
  Future<List<TabletsIntake>> getTabletsByDate(DateTime time) async {
    final db = await tabletsDb;

    var response = await db.query(
      'Tablets',
      where: 'date = ?',
      whereArgs: [time.millisecondsSinceEpoch],
    );

    List<TabletsIntake> list =
        response.map((data) => TabletsIntake.fromJSON(data)).toList();
    return list;
  }

  /// Delete whole [TabletsIntake] database. Be careful using it!
  Future deleteTabletsDB() async {
    final db = await tabletsDb;
    db.delete('Tablets');
  }
}
