import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

///This class Contains all Functionality which is used to handle database
///And Contains all table name database field name
///
class DbHelper {
  ///Database [Database] Variable which is used for create table, insert, update
  /// and delete data into database
  static late Database database;

  ///Database Version
  ///if we Update the app  version then must need to update db vesrion if we
  ///were chnaged in local db
  static int dbVersion = 1;

  static Future<Database> initDatabase() async {
    // Get a location using getDatabasesPath
    String path = "";
    if (Platform.isIOS) {
      Directory directory = await getApplicationDocumentsDirectory();
      path = p.join(directory.toString(), ' parsel_exchange_app_db.db');
    } else {
      var databasesPath = await getDatabasesPath();
      path = databasesPath + 'parsel_exchange_app_db.db';
    }

    /// open the database
    database = await openDatabase(path, version: dbVersion,
        onCreate: (Database db, int version) async {
      /// When DB Created, Favorite table Will Create If Not Exists
    });

    return database;
  }

  ///Clean All Database
  Future cleanDatabase() async {
    await database.delete('favoriteTable');
  }
}
