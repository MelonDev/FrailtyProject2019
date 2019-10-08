import 'dart:convert';

import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/Question.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';
import 'package:frailty_project_2019/Model/Version.dart';
import 'package:frailty_project_2019/home.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class OnDeviceQuestion {
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

  final String choiceTable = "CHOICE";
  final String choiceId = "id";
  final String choiceQuestionId = "questionnaireId";
  final String choiceMessage = "message";
  final String choicePosition = "position";
  final String choiceDestinationId = "destinationId";

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
      await db.execute(
          'CREATE TABLE IF NOT EXISTS  $choiceTable ($choiceId text primary key,$choiceQuestionId text not null,$choiceMessage text not null,$choicePosition integer not null,$choiceDestinationId text not null)');
    });
    return db;
  }

  Future<QuestionWithChoice> nextQuesion(
      String questionnaire, String currentKey, String choiceYouChoose) async {
    //List<Map> maps = await database.rawQuery("SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${questionnaire.toUpperCase()}') AND ($questionCategory = '-') ORDER BY $questionId ASC");

    Database database = await initDatabase();

    if (currentKey == null) {
      if (questionnaire != null) {
        if (questionnaire.length > 0) {
          List<Map> maps = await database.rawQuery(
              "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${questionnaire.toUpperCase()}') AND ($questionCategory = '-') ORDER BY $questionPosition ASC");
          Map map = maps.first;

          var q = Question.fromMap(map);
          return QuestionWithChoice(q, null);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      List<Map> mapsA1 = await database.rawQuery(
          "SELECT * FROM $questionTable  WHERE ($questionId = '${currentKey.toUpperCase()}')");

      if (mapsA1 != null) {
        Map mapA1 = mapsA1.first;
        var qA1 = Question.fromMap(mapA1);

        if (qA1.type.contains("title")) {
          List<Map> mapsA2 = await database.rawQuery(
              "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${questionnaire.toUpperCase()}') AND ($questionCategory = '${qA1.category.toUpperCase()}') AND ($questionPosition = 1) ORDER BY $questionPosition ASC");
          if (mapsA2 != null) {
            Map mapA2 = mapsA2.first;
            var qA2 = Question.fromMap(mapA2);

            List<Map> mapsA3 = await database.rawQuery(
                "SELECT * FROM $choiceTable  WHERE ($choiceQuestionId = '${qA2.id.toUpperCase()}') ORDER BY $choicePosition ASC");
            if (mapsA3 != null) {
              var qA3 = mapsA3.map((model) {
                var q = Choice.fromMap(model);
                return q;
              }).toList();

              return QuestionWithChoice(qA2, qA3);
            } else {
              return null;
            }
          } else {
            //<-
          }
        } else {
          //<-
        }
      } else {
        //<-
      }
    }

    //print(maps.length);
  }
}
