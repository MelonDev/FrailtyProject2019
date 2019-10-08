import 'dart:convert';

import 'package:frailty_project_2019/Model/Version.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class OfflineStaticDatabase {
  final String versionTable = "VERSION";
  final String versionId = "id";
  final String versionQuestionnaireId = "questionnaireId";
  final String versionVersion = "version";
  final String versionCreateAt = "createAt";
  final String versionUpdateAt = "updateAt";

  final String questionTable = "QUESTION";
  final String questionId = "id";
  final String questionMessage = "message";
  final String questionType = "type";
  final String questionPosition = "position";
  final String questionQuestionnaireId = "questionnaireId";
  final String questionCategory = "category";

  final String questionnaireTable = "QUESTIONNAIRE";
  final String questionnaireId = "id";
  final String questionnaireName = "name";
  final String questionnaireDescription = "description";

  Future<Database> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mydatabases.db');
    Database db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS  $versionTable ($versionId text primary key,$versionQuestionnaireId text not null,$versionVersion integer not null,$versionCreateAt text not null,$versionUpdateAt text not null)');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS  $questionnaireTable ($questionnaireId text primary key,$questionnaireName text not null,$questionnaireDescription text not null)');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS  $questionTable ($questionId text primary key,$questionMessage text not null,$questionType text not null,$questionPosition integer not null,$questionQuestionnaireId text not null,$questionCategory text not null)');
    });
    return db;
  }

  Future<bool> insertVersionDatabase(List<Version> list) async {
    Database database = await initDatabase();
    /*await database.transaction((table) async {

      var batch = database.batch();
      for(var slot in list){
        batch.insert(versionTable, slot.toMap());

        //await table.rawInsert(
        //    'INSERT INTO $versionTable($versionId, $versionQuestionnaireId, $versionVersion, $versionCreateAt, $versionUpdateAt) VALUES(${slot.id}, ${slot.questionnaireId}, ${slot.version}, ${slot.createAt}, ${slot.updateAt})');
      }
      await batch.commit();

      return true;
    });*/

    var batch = database.batch();
    for (var slot in list) {
      batch.insert(versionTable, slot.toMap());

      //await table.rawInsert(
      //    'INSERT INTO $versionTable($versionId, $versionQuestionnaireId, $versionVersion, $versionCreateAt, $versionUpdateAt) VALUES(${slot.id}, ${slot.questionnaireId}, ${slot.version}, ${slot.createAt}, ${slot.updateAt})');
    }
    await batch.commit();
    return true;
  }

  Future<bool> downloadVersionDatabase() async {
    String url =
        'https://melondev-frailty-project.herokuapp.com/api/download/downloadAllVersion';
    var response = await http.get(url);
    var versions = new List<Version>();

    Iterable list = json.decode(response.body);
    versions = list.map((model) => Version.fromJson(model)).toList();

    Database database = await initDatabase();
    await database.rawDelete('DELETE FROM $versionTable');
    await insertVersionDatabase(versions);

    return false;
  }

  Future<List<Version>> downloadVersionFromHeroku() async {
    String url =
        'https://melondev-frailty-project.herokuapp.com/api/download/downloadAllVersion';
    var response = await http.get(url);
    var listOfVersion = new List<Version>();

    Iterable list = json.decode(response.body);
    listOfVersion = list.map((model) => Version.fromJson(model)).toList();

    return listOfVersion;
  }

  Future<List<Version>> getVersionDatabase() async {
    Database database = await initDatabase();
    List<Map> maps = await database.rawQuery('SELECT * FROM $versionTable');
    if (maps.isNotEmpty) {
      return maps.map((model) => Version.fromMap(model)).toList();
    }
    return null;
  }

  Future<bool> isVersionLowerThenHeroku(Version _version) async {
    Database database = await initDatabase();
    //List<Map> maps = await database.rawQuery(
    //    'SELECT * FROM $versionTable WHERE $versionId = ${_version.id}');
    List<Map> maps = await database.query(versionTable,where: 'id = ?',whereArgs: [_version.id]);
    var onDeviceMap = maps.first;
    var onDevice = Version.fromMap(onDeviceMap);

    if(onDevice.version < _version.version){
      return true;
    }else {
      return false;
    }

  }

  Future onVersionProcess() async {
    Database database = await initDatabase();
    List<Version> listOfVersion = await downloadVersionFromHeroku();



    var batch = database.batch();
    for (var slot in listOfVersion) {
      var check = await isVersionLowerThenHeroku(slot);
      if (check){
        print("FOUND");
        batch.delete(versionTable, where: 'id = ?', whereArgs: [slot.id]);
        batch.insert(versionTable, slot.toMap());
      }
    }
    await batch.commit();
  }
}
