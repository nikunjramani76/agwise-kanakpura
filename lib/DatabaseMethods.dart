import 'dart:io';

import 'package:chatbot/Chat.dart';
import 'package:chatbot/Constant.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseMethod{
  DatabaseMethod._();
  static final DatabaseMethod db = DatabaseMethod._();
  static Database _database;

  static Future<Database> get database async {
    if (_database != null)
      return _database;
    _database = await initDB();
    getAllProducts();
    return _database;
  }

  static initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ChatDB.db");
    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE Chat ("
                  "id INTEGER PRIMARY KEY UNIQUE,"
                  "msg TEXT,"
                  "issendbyme TEXT,"
                  "type TEXT"
                  ")"
          );
        }
    );
  }
  static getAllProducts() async {
    final db = await database;
    List<Map> results = await db.query("Chat", columns: Chat.columns, orderBy: "id ASC");

    Constant.chatlist=[];
    results.forEach((result) {
      Chat product = Chat.fromMap(result);
      Constant.chatlist.add(product);
    });
  }

 static insert(Chat chat) async {
    final db = await database;
    var maxIdResult = await db.rawQuery(
        "SELECT MAX(id)+1 as last_inserted_id FROM Chat");

    var id = maxIdResult.first["last_inserted_id"];
    print(id);
    var result = await db.rawInsert(
        "INSERT Into Chat (id, msg, issendbyme, type)"
            " VALUES (?, ?, ?, ?)",
        [id, chat.msg, chat.issendbyme, chat.type]
    );
    return result;
  }

  static deleteAll() async {
    final db = await database;
    db.delete("Chat");
  }
}