import 'package:nowapps_round2/models/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  List<Product> cartProducts = [];

  final database = openDatabase(
    join(getDatabasesPath().toString(), 'products_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE products(prodId INTEGER PRIMARY KEY, prodCode VARCHAR UNIQUE, prodName VARCHAR, prodPrice INTEGER, prodImage VARCHAR)',
      );
    },
    version: 1,
  );

  insert() async {
    final db = await database;
    for (Product p in Product.productsList) {
      await db.insert(
        'products',
        p.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Product>> getCartProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product(
        prodId: maps[i]['prodId'],
        prodCode: maps[i]['prodCode'],
        prodName: maps[i]['prodName'],
        prodPrice: maps[i]['prodPrice'],
        prodImage: maps[i]['prodImage'],
      );
    });
  }
}
