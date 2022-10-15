import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class StorageController extends ChangeNotifier {
  static const _databaseName = "flutter.db";
  static const _databaseVersion = 1;
  static Database? database;

  static initDatabase() async {
    if (database == null) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      database = await openDatabase(path,
          version: _databaseVersion, onCreate: onCreate);
    }
  }

  static Future onCreate(Database db, int version) async {
    await db.execute(createUserTable());
  }

  static Future onUpgrade(Database db, int version) async {
    await db.execute(createUserTable());
  }

  static String createUserTable() {
    const String tableUser = 'User';
    const userId = 'id';
    const userName = 'name';
    const userEmail = 'email';
    const userImage = 'profileImage';
    const token = 'token';
    const gender = 'gender';
    const dob = 'dob';

    return '''
          CREATE TABLE $tableUser (
            $userId INTEGER PRIMARY KEY,
            $userName TEXT,
            $userEmail TEXT,
            $userImage TEXT,
            $token TEXT,
            $gender TEXT,
            $dob TEXT
          )
          ''';
  }

  static Future<int> insertData(
      String tableName, Map<String, dynamic> data) async {
    return await database!
        .insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateUser(
      String tableName, Map<String, dynamic> data, String id) async {
    String query = "UPDATE $tableName SET ";
    List<dynamic> values = List.empty(growable: true);
    data.forEach((key, value) {
      query = query + '$key=?,';
      values.add(value);
    });
    query = query.substring(0, query.length - 1);
    query = query + " where id=?";
    values.add(data['id']);
    return await database!.rawUpdate(query, values);
  }

  static Future<int> deleteData(String tableName, int id) async {
    return await database!.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> deleteAllData(String tableName) async {
    await database!.rawQuery('delete from $tableName');
  }

  static Future<List<Map>> getData(String tableName) async {
    return await database!.rawQuery('SELECT * FROM $tableName');
  }
}
