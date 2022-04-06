import 'package:mceasy_submission/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/cuti.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example_user.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, nomorInduk TEXT NOT NULL, nama TEXT NOT NULL, alamat TEXT NOT NULL, tanggalLahir TEXT NOT NULL, tanggalBergabung TEXT NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE cuti(id INTEGER PRIMARY KEY AUTOINCREMENT, nomorInduk TEXT NOT NULL, tanggalCuti TEXT NOT NULL, lamaCuti TEXT NOT NULL, keterangan TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertUser(List<User> users) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var user in users){
      result = await db.insert('users', user.toMap());
    }
    return result;
  }

  Future<int> insertCuti(List<Cuti> cuti) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var cutis in cuti){
      result = await db.insert('cuti', cutis.toMap());
    }
    return result;
  }

  Future<List<Cuti>> retrieveCuti() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('cuti');
    return queryResult.map((e) => Cuti.fromMap(e)).toList();
  }

  Future<void> updateUser(User user) async {
    // Get a reference to the database.
    final Database db = await initializeDB();

    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> updateCuti(Cuti cuti) async {
    // Get a reference to the database.
    final Database db = await initializeDB();

    await db.update(
      'cuti',
      cuti.toMap(),
      where: 'id = ?',
      whereArgs: [cuti.id],
    );
  }

  Future<List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<List<Map>> getSisaCutiKaryawan() async {
    final Database db = await initializeDB();
    //sisa cuti
    final List<Map> result = await db.rawQuery('SELECT users.nomorInduk, users.nama, ifnull(sum(cuti.lamaCuti), 0) as lamacuti  FROM users left join cuti on cuti.nomorInduk = users.nomorInduk group by users.nomorInduk');
    return result;
  }

  Future<List<Map>> getKaryawanPalingBanyakCuti() async {
    final Database db = await initializeDB();
    //cuti > 1
    // final List<Map> result = await db.rawQuery('SELECT cuti.nomorInduk, users.nama, sum(cuti.lamaCuti) as lamacuti FROM cuti join users on cuti.nomorInduk = users.nomorInduk  where lamacuti > 1 group by users.nomorInduk');
    final List<Map> result = await db.rawQuery('SELECT users.nomorInduk, users.nama, cuti.tanggalcuti, cuti.keterangan FROM cuti join users on cuti.nomorInduk = users.nomorInduk  where cuti.nomorInduk in (select nomorInduk from cuti group by nomorInduk having sum(lamaCuti) > 1)');

    return result;
  }

  Future<List<User>>  getTop3() async {
    final Database db = await initializeDB();
    //cuti > 1
    // final List<Map> result = await db.rawQuery('SELECT cuti.nomorInduk, users.nama, sum(cuti.lamaCuti) as lamacuti FROM cuti join users on cuti.nomorInduk = users.nomorInduk  where lamacuti > 1 group by users.nomorInduk');
    final List<Map<String, Object?>> queryResult = await db.rawQuery('SELECT * FROM users order by tanggalBergabung DESC LIMIT 3');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteCuti(int id) async {
    final db = await initializeDB();
    await db.delete(
      'cuti',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
