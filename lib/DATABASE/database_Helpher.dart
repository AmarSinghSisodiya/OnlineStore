import 'dart:async';
import 'package:productmaster/DATABASE/databaseFunction.dart';
import 'package:productmaster/ModelClass/productMasterModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String databaseName = 'business_guru.db';
  static const String tableName = 'product_master';

  static DatabaseHelper? _instance;
  DatabaseHelper._();
  late List<ProductMasterModel> productList = [];

////////////////////////////////////////update product////////////////////
  Future<void> updateProduct(
    int productId,
    String picture,
    String picturetwo,
    String picturethree,
    String picturefour,
    String picturefive,
    String message,
    String costPrice,
    String productName,
  ) async {
    try {
      await initDatabase();
      final Database? database = _database;

      if (database != null) {
        await database.update(
          tableName,
          {
            'picture': picture,
            'costPrice': costPrice,
            'message': message,
            'productName': productName,
            'picturetwo': picturetwo,
            'picturethree': picturethree,
            'picturefour': picturefour,
            'picturefive': picturefive,
          },
          where: 'id = ?',
          whereArgs: [productId],
        );
        print('Product updated successfully with ID: $productId');
        print(productName);
      } else {
        print('Error updating product: Database is null');
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> updateProductWithoutImage(
    int productId,
    String message,
    String costPrice,
    String productName,
  ) async {
    try {
      await initDatabase();
      final Database? database = _database;

      if (database != null) {
        // Your implementation to update other details without changing images
        // For example:
        await database.update(
          tableName, // Use the correct table name here (tableName) instead of 'products'
          {
            'message': message,
            'costPrice': costPrice,
            'productName': productName,
          },
          where: 'id = ?',
          whereArgs: [productId],
        );
      } else {
        print('Error updating product without image: Database is null');
      }
    } catch (e) {
      print('Error updating product without image: $e');
      rethrow; // Rethrow the exception to indicate the error
    }
  }

//////////////////////////////////////Function to update Image in LocalDatabase//////////////////////
  Future<void> updateProductImage(
    int productId,
    List<String> pictures,
  ) async {
    await initDatabase();
    final Database database = _database!;
    try {
      // Assuming you have columns 'picture', 'picturetwo', 'picturethree', 'picturefour', 'pictureFive'
      await database.update(
        tableName,
        {
          'picture': pictures.length > 0 ? pictures[0] : null,
          'picturetwo': pictures.length > 1 ? pictures[1] : null,
          'picturethree': pictures.length > 2 ? pictures[2] : null,
          'picturefour': pictures.length > 3 ? pictures[3] : null,
          'pictureFive': pictures.length > 4 ? pictures[4] : null,
        },
        where: 'id = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      print('Error updating product pictures: $e');
    }
  }

  /////////////////////////////////////////////add timer/////////////////////////
  Future<void> sendPendingDataToApi(BuildContext context) async {
    try {
      await initDatabase();
      final Database database = _database!;
      List<ProductMasterModel> newProducts =
          await database.transaction((txn) async {
        return await getNewProductList(txn);
      });

      if (newProducts.isNotEmpty) {
        final success = await updateProductsSentToApi(newProducts, context);
        if (success) {
          print('Data sent successfully to API for pending products.');
        } else {
          print('Failed to send data to API for some products.');
        }
      } else {
        print('No pending products to send.');
      }
    } catch (e) {
      print('Error sending data to API: $e');
    }
  }

////////////////////////////////Fuction Help to Get Whole database Path and table to user/////////////////////////
  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }
  Database? _database;
  Database? get database => _database;
  Future<void> initDatabase() async {
    if (_database == null || !_database!.isOpen) {
      String path = join(await getDatabasesPath(), databaseName);
      _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    }
  }

//////////////////////////////Fuction to Received Product Code and Update ProductCode in Latest Items////////////////////////////////////////
  Future<void> updateProductCodes(List<String> productCodes) async {
    await initDatabase();
    final Database database = _database!;
    try {
      if (productCodes.isNotEmpty) {
        // Get the latest products from the database
        List<Map<String, dynamic>> productList = await database.query(
          tableName,
          orderBy:
              'createdAt DESC', // Order by createdAt in descending order to get the latest products
          limit: productCodes
              .length, // Retrieve the number of latest products equal to the length of productCodes
        );
        int productIndex = 0;
        for (int i = productList.length - 1; i >= 0; i--) {
          String productCode = productCodes[productIndex % productCodes.length];
          await database.update(
            tableName,
            {'productCode': productCode},
            where: 'id = ?',
            whereArgs: [
              productList[i]['id']
            ], // Use the id of the corresponding latest product
          );
          print('Product code updated in the latest product: $productCode');
          productIndex++;
        }
      }
    } catch (e) {
      print('Error updating product codes in the latest products: $e');
    }
  }

///////////////////////////////////Fuction to insert data to api and update Local Database//////////////////
  Future<bool> updateProductsSentToApi(
      List<ProductMasterModel> productList, BuildContext context) async {
    await initDatabase();
    final Database database = _database!;
    try {
      for (final product in productList) {
        await database.update(
          tableName,
          {
            'sentToApi': 1,
          },
          where: 'groupCode = ?',
          whereArgs: [product.groupCode],
        );
      }

      List<Map<String, dynamic>> productMaps =
          productList.map((product) => product.toMap()).toList();
    final success = await insertProductMasterModel(productMaps, context); // Pass productMaps instead of productList
      if (success) {
        print('Data sent successfully to API for updated products.');
        return true;
      } else {
        print('Failed to send data to API for updated products.');
        return false;
      }
    } catch (e) {
      print('Error updating products and sending to API: $e');
      return false;
    }
  }
////////////////////////////////////Fuction to get all Products from LocalDatabase//////////////////
  Future<List<ProductMasterModel>> getAllProducts([Transaction? txn]) async {
    List<Map<String, dynamic>> productList;
    if (txn != null) {
      productList = await txn.query(tableName);
    } else {
      await initDatabase();
      productList = await _database!.query(tableName);
    }
    return productList
        .map((productMap) => ProductMasterModel.fromJson(productMap))
        .toList();
  }

  ///////////////////Fuction to check database created or not, if not then function help to create local database//////////////
  Future<Database> initializeDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, databaseName);
    return openDatabase(databasePath, version: 1, onCreate: _onCreate);
  }

  /////////////////////////////////////////////////////Database Table and Items////////////////////////////////////
  Future<void> _onCreate(Database database, int version) async {
    await database.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
      productCode INTEGER,
      groupCode TEXT,
      productName TEXT,
      printName TEXT,
      taxAtPurchase INTEGER,
      taxAtSale INTEGER,
      unit TEXT,
      askQty INTEGER,
      askRate INTEGER,
      useFIFO INTEGER,
      message TEXT,
      wholeSalePrice INTEGER,
      salePrice INTEGER,
      costPrice INTEGER,
      discount INTEGER,
      picture TEXT,
      picturetwo TEXT,
      picturethree TEXT,
      picturefour TEXT,
      picturefive TEXT,
      brandCode TEXT,
      productMarathi TEXT,
      firmCodeKey INTEGER,
      appKeyCodeKey INTEGER,
      productType TEXT,
      dpRate INTEGER,
      spRate2 INTEGER,
      spRate3 INTEGER,
      minimumQty INTEGER,
      maximumQty INTEGER,
      minimumRate INTEGER,
      maximumRate INTEGER,
      taxApplicable INTEGER,
      emiApplicable INTEGER,
      stockManage INTEGER,
      option1 TEXT,
      option2 TEXT,
      Option3 TEXT,
      taxAtMandi INTEGER,
      productCol1 TEXT,
      productCol2 TEXT,
      productCol3 TEXT,
      productCol4 TEXT,
      productCol5 TEXT,
      productCol6 TEXT,
      alternateUnit TEXT,
      convertFactor INTEGER,
      convertType TEXT,
      userId TEXT,
      userName TEXT,
      productInsertionType TEXT,
      pendingFlag INTEGER,
      hsnCode TEXT,
      sentToApi INTEGER,
      createdAt INTEGER,
      gst TEXT,
      openingStock INTEGER
        )
      ''');
  }
////////////////////////Fuction which help to store data in LocalDatabase in table////////////////
  Future<int> insertProduct(ProductMasterModel productList) async {
    await initDatabase();
    int result = await _database!.insert(tableName, productList.toMap());
    return result;
  }
  ///////////////////////Function to check product Exist or note condition Group == productName////////////////////////////
  Future<bool> doesProductExist(String group, String productName) async {
    await initDatabase();
    final Database database = _database!;
    List<Map<String, dynamic>> productList = await database.query(
      tableName,
      where: 'groupCode = ? AND productName = ?',
      whereArgs: [group, productName],
    );
    return productList.isNotEmpty;
  }
  Future<List<ProductMasterModel>> getNewProductList(Transaction txn) async {
    List<Map<String, dynamic>> newProductList = await txn.query(
      tableName,
      where: 'sentToApi = ?',
      whereArgs: [0],
    );
    return newProductList
        .map((productListMap) => ProductMasterModel.fromJson(productListMap))
        .toList();
  }

  ///////////////////////////////In help to show new data, when inserting in database////////////////////////////////////////////////
  Future<void> setNewProductsPendingFlag(int flagValue) async {
    await initDatabase();
    final Database database = _database!;
    try {
      await database.transaction((txn) async {
        try {
          await txn.update(
            tableName,
            {'pendingFlag': flagValue},
            where: 'createdAt > ?',
            whereArgs: [
              DateTime.now()
                  .subtract(const Duration(hours: 2))
                  .millisecondsSinceEpoch,
            ],
          );
          List<ProductMasterModel> newProductList =
              await getNewProductList(txn);
          List<ProductMasterModel> unsentNewProducts = newProductList
              .where((productList) => productList.sentToApi == 0)
              .toList();
          for (final product in unsentNewProducts) {
            await txn.update(
              tableName,
              {'sentToApi': 0},
              where: 'id = ?',
              whereArgs: [product.id],
            );
            print('Product sent to API: ${product.groupCode}');
          }
          unsentNewProducts.forEach((product) {});
        } catch (error) {
          print('Error in transaction: $error');
        }
      });
      ///////////////////////////////////////////////////////////////////////
      Future<List<ProductMasterModel>> getNewProducts(Transaction txn) async {
        DateTime thirtySecondsAgo =
            DateTime.now().subtract(const Duration(hours: 2));
        List<Map<String, dynamic>> newProducts = await txn.query(
          tableName,
          where: 'createdAt > ? AND sentToApi = ?',
          whereArgs: [thirtySecondsAgo.toUtc().millisecondsSinceEpoch, 0],
        );
        return newProducts
            .map((productListMap) => ProductMasterModel.fromJson(productListMap))
            .toList();
      }
    } catch (error) {}
  }

  ///////////////////////////////////////////Function set all pending flag value 0 to all products///////////////////////////
  Future<void> setAllProductsPendingFlag(int flagValue) async {
    await initDatabase();
    final Database database = _database!;
    await database.update(
      tableName,
      {'pendingFlag': flagValue},
    );
  }

/////////////////////////////////Generate a list of a products//////////////////////////
  Future<List<ProductMasterModel>> setAllProducts() async {
    final Database database = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await database.query(tableName);
    return List.generate(maps.length, (i) {
      return ProductMasterModel.fromJson(maps[i]);
    });
  }
}
