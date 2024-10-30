import 'package:sqflite/sqflite.dart' as sql2;

class SQLHelper2 {
  static Future<void> createTables(sql2.Database database) async{
    await database.execute("""
      CREATE TABLE region(
      idRegion INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      kota TEXT,
      gajiUMR TEXT
      )
    """);
  }
  static Future<sql2.Database> db() async{
    return await sql2.openDatabase(
      'region.db',
      version: 1,
      onCreate: (sql2.Database database, int version) async{
        await createTables(database);
      }
    );
  }
  static Future<int> addRegion(String kota, String gajiUMR) async {
    final db = await SQLHelper2.db();
    final data = {'kota': kota, 'gajiUMR': gajiUMR};
    return await db.insert('region', data);
  }

  static Future<List<Map<String, dynamic>>> getRegion() async {
    final db = await SQLHelper2.db();
    return db.query('region');
  }
  // Update Employee
  static Future<int> editRegion(int idRegion, String kota, String gajiUMR) async {
    final db = await SQLHelper2.db();
    final data = {'kota': kota, 'gajiUMR': gajiUMR};
    return await db.update(
      'region',
      data,
      where: "idRegion = $idRegion",
    );
  }


  static Future<int> deleteRegion(int idRegion) async {
    final db = await SQLHelper2.db();
    return await db.delete(
      'region',
      where: "idRegion = $idRegion",
    );
  }
}