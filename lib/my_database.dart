import 'dart:io';

import 'package:database/model/city_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class MyDatabase {
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'api_db2.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "api_db2.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load(
          join('assets/database', 'api_db2.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }

  Future<List<Map<String,Object?>>> getUserListFromUserTable()async {
    Database db = await initDatabase();
    List<Map<String,Object?>> data= await db.rawQuery('select * from TBL_User');
    return data;
  }

  Future<List<CityModel>> getCityList() async {

    Database db = await initDatabase();
    List<Map<String,Object?>> data = await db.rawQuery('select * from TBL_User');
    List<CityModel> cityList =[];
    for(int i=0;i<data.length;i++){
      CityModel model=CityModel();
      model.UserId=int.parse(data[i]['UserId'].toString());
      model.City=data[i]['City'].toString();
      cityList.add(model);
    }
    return cityList;
  }

  Future<int> insertUserDetails(map) async {
    Database db =await initDatabase();
    int userId = await db.insert('TBL_User', map);
    return userId;
  }

  Future<int> updateUserDetails(map,id) async {
    Database db =await initDatabase();
    int userId = await db.update('TBL_User', map,where: 'UserId = ?',whereArgs: [id]);
    return userId;
  }

  Future<int> deleteUser(id) async {
    Database db=await initDatabase();
    int  userId= await db.delete('TBL_User',where:'UserId =?',whereArgs: [id]);
   return userId;
  }
}