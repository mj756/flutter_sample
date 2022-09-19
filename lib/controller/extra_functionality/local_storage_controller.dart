import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class StorageController extends ChangeNotifier
{
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
    const userId = 'Id';
    const userName = 'Name';
    const userEmail = 'Email';
    const userImage = 'ProfileImage';
    const token = 'Token';

    return '''
          CREATE TABLE $tableUser (
            $userId INTEGER PRIMARY KEY,
            $userName TEXT,
            $userEmail TEXT,
            $userImage TEXT,
            $token TEXT
          )
          ''';
  }

  static Future<int> insertData(String tableName, Map<String, dynamic> data) async {
    return await database!
        .insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateUser(String tableName, Map<String, dynamic> data, String id) async {
    return await database!.rawUpdate(
        'UPDATE $tableName SET Name = ?, Email = ? WHERE Id = ?',
        [data['Name'], data['Email'], id]);
  }

  static Future<int> deleteData(String tableName,int id) async {
    return await database!.delete( tableName,where: "Id = ?",whereArgs: [id]);
  }
  static Future<List<Map>> getData(String tableName, int id) async {
    return await database!.rawQuery('SELECT * FROM $tableName');
  }
}
