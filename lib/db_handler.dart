import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:todo_app/mode.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Todo.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    await db.execute(
      "CREATE TABLE my_todo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,"
      " desc TEXT NOT NULL , date_and_time TEXT NOT NULL)",
    );
  }

  Future<TodoModel> insert(TodoModel todoModel) async {
    var dbClient = await db;
    await dbClient?.insert('my_todo', todoModel.toMap());
    return todoModel;
  }

  Future<List<TodoModel>> getDataList() async {
    await db;
    final List<Map<String, Object?>> queryResult =
        await _db!.rawQuery('SELECT * FROM my_todo');
    return queryResult.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<TodoModel> getTodo(int id) async {
    var dbClient = await db;

    var todoMaps = await dbClient!.query('my_todo', where: 'id = ?', whereArgs: [id]);

    return TodoModel.fromMap(todoMaps.first);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;

    return await dbClient!.delete('my_todo', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(TodoModel todoModel) async {
    var dbClient = await db;
    return await dbClient!.update('my_todo', todoModel.toMap(),
        where: 'id = ?', whereArgs: [todoModel.id]);
  }
}
