import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  // static String host = 'localhost';
  // static int port = 27017;
  // static String dbName = 'AIM';

  MongoDB();

  Future<Db> getConnection() async {
    Db db = Db('mongodb://localhost:27017/aim');
    try {
      await db.open();
      print("connected to DB as $Db");
      return db;
    } catch (e) {
      print('Error connecting to MongoDB: $e');
      return Future.error(e);
    }
  }

  Future<void> closeConnection([Db? db]) async {
    try {
      if (db != null) {
        await db.close();
      }
      print('Connection closed successfully');
    } catch (e) {
      print('Error closing connection: $e');
    }
  }
}
