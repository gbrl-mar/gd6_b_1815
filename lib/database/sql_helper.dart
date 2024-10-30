import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  static Future<void> createTables(sql.Database database) async{
    await database.execute("""
      CREATE TABLE employee(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      email TEXT
      )
    """);
  }
static Future<sql.Database> db() async {
  return sql.openDatabase(
    'employee.db',
    version: 1,
    onCreate: (sql.Database database, int version) async {
      await createTables(database);
    },
  );
}

  static Future<int> addEmployee(String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    return await db.insert('employee', data);
  }

  static Future<List<Map<String, dynamic>>> getEmployee() async {
    final db = await SQLHelper.db();
    return db.query('employee');
  }
  // Update Employee
  static Future<int> editEmployee(int id, String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    return await db.update(
      'employee',
      data,
      where: "id = $id",
    );
  }

  // Delete Employee
  static Future<int> deleteEmployee(int id) async {
    final db = await SQLHelper.db();
    return await db.delete(
      'employee',
      where: "id = $id",
    );
  }

}