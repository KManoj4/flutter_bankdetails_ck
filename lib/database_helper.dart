import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "BankDetailsDB.db";
  static const _databaseVersion = 2;

  // Bank Details table
  static const bankDetailsTable = 'bank_details_table';

  static const columnId = '_id';
  // Bank Details table column
  static const columnBankName = '_bankName';
  static const columnBranch = '_branch';
  static const columnAccountType = '_accountType';
  static const columnAccountNo = '_accountNo';
  static const columnIFSCcode = '_IFSCcode';

  late Database _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database database, int version) async {

    await database.execute('''
          CREATE TABLE $bankDetailsTable (
            $columnId INTEGER PRIMARY KEY,
            $columnBankName TEXT,
            $columnBranch TEXT,
            $columnAccountType TEXT,
            $columnAccountNo TEXT,
            $columnIFSCcode TEXT
          )
          ''');
  }

  _onUpgrade(Database database, int oldVersion, int newVersion) async{
    await database.execute('drop table $bankDetailsTable');
    _onCreate(database, newVersion);
  }

  Future<int> insert(Map<String, dynamic> row, String tableName) async {
    return await _db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    return await _db.query(tableName);
  }

  Future<int> queryRowCount(String tableName) async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> update(Map<String, dynamic> row, String tableName) async {
    int id = row[columnId];
    return await _db.update(
      tableName,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id, String tableName) async {
    return await _db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Row
  readDataById(table, itemId) async{
    return await _db.query(table, where: "_id =? ",whereArgs: [itemId]);
  }

  // Column
  // Read data from table by column name
  readDataByColumnName(table, columnName, columnValue) async{
    return await _db?.query(table, where: '$columnName =? ', whereArgs: [columnValue]);
  }
}