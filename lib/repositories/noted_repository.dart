import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotedRepository {
  Future<Database> openDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'noted.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY, note TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertNote(String note) async {
    final db = await openDb();
    await db.insert(
      'notes',
      {'note': note},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await openDb();
    return db.query('notes');
  }
}
