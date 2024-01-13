import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '192.168.56.1', user = 'root', password = '', db = 'aim';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    try {
      return await MySqlConnection.connect(settings);
    } catch (e) {
      print('Error connecting to MySQL: $e');
      return Future.error(e);
    }
  }

  Future<void> closeConnection() async {
    try {
      var connectionSettings = ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db,
      );
      var connection = await MySqlConnection.connect(connectionSettings);
      await connection.close();
      print('Connection closed successfully');
    } catch (e) {
      print('Error closing connection: $e');
    }
  }
}
