import 'package:postgres/postgres.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static PostgreSQLConnection? _connection;

  DatabaseHelper._init();

  Future<PostgreSQLConnection> get connection async {
    if (_connection != null) return _connection!;
    _connection = await _initDB();
    return _connection!;
  }

  Future<PostgreSQLConnection> _initDB() async {
    final connection = PostgreSQLConnection(
      'your_host', // e.g. 'localhost'
      5432,
      'your_database', // e.g. 'mydb'
      username: 'your_username', // e.g. 'postgres'
      password: 'your_password',
    );
    await connection.open();
    return connection;
  }

  Future<Map<String, dynamic>> getUserHealthRecord(int userId) async {
    final conn = await instance.connection;
    final results = await conn.query('SELECT * FROM user_health_records WHERE user_id = @userId', substitutionValues: {
      'userId': userId,
    });

    if (results.isNotEmpty) {
      final row = results.first;
      return {
        'user_id': row[0],
        'age': row[1],
        'blood_group': row[2],
        'haemoglobin': row[3],
        'wbc': row[4],
        'platelets': row[5],
        'mcv': row[6],
        'pcv': row[7],
        'rbc': row[8],
        'mch': row[9],
        'mchc': row[10],
        'neutrophils': row[11],
        'lymphocytes': row[12],
        'monocytes': row[13],
        'eosinophils': row[14],
        'basophils': row[15],
      };
    } else {
      throw Exception('Record not found');
    }
  }
}
