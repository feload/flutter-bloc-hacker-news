import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:news/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';

class NewsDbProvider implements Source, Cache {
  late Database db;

  NewsDbProvider() {
    init();
  }

  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
      CREATE TABLE Items (
        id INTEGER PRIMARY KEY,
        type TEXT,
        by TEXT,
        time INTEGER,
        text TEXT,
        parent INTEGER,
        kids BLOB,
        dead INTEGER,
        deleted INTEGER,
        url TEXT,
        score INTEGER,
        title TEXT,
        descendants INTEGER
      )
      """);
    });
  }

  @override
  Future<List<int>> fetchTopIds() async {
    return [];
  }

  @override
  FutureOr<ItemModel?> fetchItem(int id) async {
    final itemsMap = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (itemsMap.isNotEmpty) {
      return ItemModel.fromDb(itemsMap.first);
    }

    return null;
  }

  @override
  Future<int> addItem(ItemModel item) {
    final itemMap = item.toMapForDb();
    return db.insert("Items", itemMap,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<int> clearCache() {
    return db.delete("Items");
  }
}
