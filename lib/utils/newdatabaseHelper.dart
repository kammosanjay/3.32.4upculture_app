import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:upculture/model/artist/newchatmodal.dart';

// Update with the actual path

// class ChatDatabaseTwo {
//   static final ChatDatabaseTwo instance = ChatDatabaseTwo._init();
//   static Database? _database;

//   ChatDatabaseTwo._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('chat.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String fileName) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, fileName);

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE messages (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         sender TEXT,
//         text TEXT,
//         type INTEGER,
//         filePath TEXT,
//         timestamp TEXT
//         )
//     ''');
//   }

//   Future<void> insertMessage(ChatMessageTest message) async {
//     final db = await instance.database;
//     await db.insert('messages', message.toMap());
//   }

//   Future<List<ChatMessageTest>> fetchAllMessages() async {
//     final db = await instance.database;
//     final result = await db.query('messages', orderBy: 'id DESC');
//     return result.map((map) => ChatMessageTest.fromMap(map)).toList();
//   }

//   Future<void> deleteMessage(int id) async {
//     final db = await instance.database;
//     await db.delete(
//       'messages',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<void> deleteAllMessages() async {
//     final db = await instance.database;
//     await db.delete('messages');
//   }

//   Future<void> close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }
class ChatDatabaseTwo {
  static final ChatDatabaseTwo instance = ChatDatabaseTwo._init();
  static Database? _database;

  ChatDatabaseTwo._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2, // 🔼 Increase version to trigger migration
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender TEXT,
        text TEXT,
        type INTEGER,
        filePath TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE messages ADD COLUMN timestamp TEXT');
    }
  }

  Future<void> insertMessage(ChatMessageTest message) async {
    final db = await instance.database;
    await db.insert('messages', message.toMap());
  }

  Future<List<ChatMessageTest>> fetchAllMessages() async {
    final db = await instance.database;
    final result = await db.query('messages', orderBy: 'id DESC');
    return result.map((map) => ChatMessageTest.fromMap(map)).toList();
  }

  Future<void> deleteMessage(int id) async {
    final db = await instance.database;
    await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllMessages() async {
    final db = await instance.database;
    await db.delete('messages');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
