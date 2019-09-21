import 'dart:async';
import 'dart:io';

import 'package:briefing/model/article.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:briefing/model/save_news.dart';
import 'package:briefing/model/news.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService db = DatabaseService._();

  Database _database;

  init() async {
    await database;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    print('DBProvider.initDB() start');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "briefing.db");
    var db = await openDatabase(path, version: 1, onCreate: populateDb);
    return db;
  }

  populateDb(Database db, int version) async {
    await Future(() async {
      var newsTable = "CREATE TABLE news"
              "(newsId INTEGER PRIMARY KEY, "
              "timeRead LONG,"
              "newsJson TEXT);";

      await db.transaction((txn) async {
        await txn.execute('$newsTable');
      });
    });
  }

  Future<int> insertNews(News news) async {
    final db = await database;
    var res;
    res = await db.insert('news', SaveNews(news).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<News>> getReadNews() async {
    final db = await database;
    List<Map> res = await db.query("news", orderBy: "timeRead DESC");
    return res.isNotEmpty ? await compute(prepareNews, res) : [];
  }

  Future close() async => db.close();

}

List<Article> prepareArticles(List<Map> list) {
  return list.map((a) => Article.fromMap(a)).toList();
}

List<News> prepareNews(List<Map> list) {
  return list.map((a) => SaveNews.fromMap(a).news).toList();
}
