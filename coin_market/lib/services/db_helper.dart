

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBhelper{

static const dbName = "TodoDatabase.db";
static const dbVersion = 1;
static const dbTable = "MyTodo";
static const ColumnId = "Id";
static const ColumnCoinId = "CoinId";
static const ColumnQty = "CoinQty";

static final DBhelper instance = DBhelper();

static Database? _database;

Future<Database?> get database async{

  _database ??= await initDB();
  return _database;
}

initDB() async{
Directory directory = await getApplicationDocumentsDirectory();
String path = join(directory.path, dbName);
return openDatabase(path, version: dbVersion, onCreate: onCreate);
}

Future onCreate(Database database, int version) async{
await database.execute(''' 
CREATE TABLE $dbTable(
$ColumnId Integer PRIMARY KEY,
$ColumnCoinId TEXT NOT NULL, 
$ColumnQty Integer NOT NULL 
)
''');
}

insertRecord(Map<String, dynamic> row) async{
Database? db = await instance.database;
return await db!.insert(dbTable, row);
}

Future<List<Map<String, dynamic>>> queryDatabase() async{
  Database? db = await instance.database;
  return await db!.query(dbTable,);
}

Future<int> updateRecord(Map<String,dynamic> row) async{
  Database? db = await instance.database;
  int id = row[ColumnId];
  return await db!.update(dbTable, row, where: '$ColumnId = ?', whereArgs: [id]);
  
}

Future<int> deleteRecord(int id) async{
  Database? db = await instance.database;
 return await db!.delete(dbTable, where: '$ColumnId = ?', whereArgs: [id]);

}

}