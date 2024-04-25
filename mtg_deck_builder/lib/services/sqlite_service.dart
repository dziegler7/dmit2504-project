import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mtg_deck_builder/models/deck.dart';
import 'dart:convert';

class SQLiteService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'decks.db');
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE Decks(id TEXT PRIMARY KEY, name TEXT, cards TEXT)",
      );
    });
  }

  Future<List<Deck>> getDecks() async {
    final db = await database;
    var res = await db.query("Decks");
    List<Deck> list = res.isNotEmpty ? res.map((c) => Deck.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> addDeck(Deck deck) async {
  try {
    final db = await database;
    final cardsJson = json.encode(deck.cards);
    await db.insert('Decks', {
      'id': deck.id,
      'name': deck.name,
      'cards': cardsJson,
    });
  } catch (e) {
    print('Failed to add deck: $e');
    throw Exception('Failed to add deck: $e');
  }
}


  Future<void> updateDeck(Deck deck) async {
    final db = await database;
    await db.update('Decks', deck.toMap(), where: "id = ?", whereArgs: [deck.id]);
  }

  Future<void> deleteDeck(int id) async {
    final db = await database;
    await db.delete('Decks', where: "id = ?", whereArgs: [id]);
  }
}
