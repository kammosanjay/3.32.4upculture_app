import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:upculture/model/artist/chatmodal.dart';

class ChatDatabase {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'chat.db');

    return await openDatabase(
      path,
      version: 2, // ⬅️ Increment version to trigger onUpgrade if needed
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id TEXT PRIMARY KEY,
            sender TEXT,
            receiver TEXT,
            message TEXT,
            type TEXT,
            filePath TEXT,
            timestamp TEXT
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // This ensures backward compatibility if user upgrades
          await db.execute('ALTER TABLE messages ADD COLUMN filePath TEXT');
        }
      },
    );
  }

  static Future<void> deleteMessageById(String id) async {
    final dbClient = await db;
    await dbClient.delete(
      'messages', // ✅ Correct table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> insertMessage(ChatMessage msg) async {
    final dbClient = await db;
    await dbClient.insert('messages', msg.toMap());
  }

  static Future<List<ChatMessage>> getMessagesForUsers(
      String sender, String receiver) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'messages',
      where: '(sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)',
      whereArgs: [sender, receiver, receiver, sender],
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }
}
