import 'package:daily_helper/models/task.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // if _database is null then await for _initDatabase, otherwise do nothing
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'task.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE task(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        subtasks TEXT
      )
      ''',
    );
  }

  Future<List<Task>> getAllTasks() async {
    final Database db = await instance.database;
    final tasks = await db.query('task');
    final List<Task> tasksList =
        tasks.isNotEmpty ? tasks.map((e) => Task.fromMap(e)).toList() : [];
    return tasksList;
  }

  Future<int> add(Task task) async {
    final Database db = await instance.database;
    return db.insert('task', task.toMap());
  }

  Future<int> remove(int id) async {
    final Database db = await instance.database;
    return db.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async {
    final Database db = await instance.database;
    return db
        .update('task', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }
}
