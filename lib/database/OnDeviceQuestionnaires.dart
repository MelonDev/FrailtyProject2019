import 'dart:convert';

import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/Question.dart';
import 'package:frailty_project_2019/Model/Questionnaire.dart';
import 'package:frailty_project_2019/Model/Version.dart';
import 'package:frailty_project_2019/main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class OnDeviceQuestionnaires {
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
  final String choiceQuestionnaireId = "questionnaireId";
  final String choiceMessage = "message";
  final String choicePosition = "position";
  final String choiceDestinationId = "destinationId";

  Batch batch;

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
              'CREATE TABLE IF NOT EXISTS  $choiceTable ($choiceId text primary key,$choiceQuestionnaireId text not null,$choiceMessage text not null,$choicePosition integer not null,$choiceDestinationId text not null)');
        });
    return db;
  }

  Future afterLogin() async {
    Database database = await initDatabase();
    batch = database.batch();
    batch.delete(versionTable);
    batch.delete(questionnaireTable);
    batch.delete(questionTable);
    batch.delete(choiceTable);

    for (var slot in await downloadVersionDatabase()) {
      batch.insert(versionTable, slot.toMap());
    }

    for (var slot in await downloadQuestionDatabase()) {
      batch.insert(questionTable, slot.toMap());
    }

    for (var slot in await downloadQuestionnaireDatabase()) {
      batch.insert(questionnaireTable, slot.toMap());
    }

    for (var slot in await downloadChoiceDatabase()) {
      batch.insert(choiceTable, slot.toMap());
    }

    //await insertToDatabase(versionTable,await downloadVersionDatabase());
    //await insertToDatabase(questionTable,await downloadQuestionDatabase());
    //await insertToDatabase(questionnaireTable,await downloadQuestionnaireDatabase());

    batch.commit();
  }

  Future insertToDatabase(String tableName,List list) async {
    for (var slot in list) {
      batch.insert(tableName, slot.toMap());
    }
  }

  Future<List<Version>> downloadVersionDatabase() async {
    String url =
        'https://melondev-frailty-project.herokuapp.com/api/download/downloadAllVersion';
    var response = await http.get(url);
    var versions = new List<Version>();

    Iterable list = json.decode(response.body);
    versions = list.map((model) => Version.fromJson(model)).toList();

    return versions;
  }


  Future<List<Choice>> downloadChoiceDatabase() async {
    String url =
        'https://melondev-frailty-project.herokuapp.com/api/download/downloadAllChoice';
    var response = await http.get(url);
    var choices = new List<Choice>();

    Iterable list = json.decode(response.body);
    choices = list.map((model) => Choice.fromJson(model)).toList();

    return choices;
  }



  Future<List<Question>> downloadQuestionDatabase() async {
    String url =
        'https://melondev-frailty-project.herokuapp.com/api/download/downloadAllQuestion';
    var response = await http.get(url);
    var questions = new List<Question>();

    Iterable list = json.decode(response.body);
    questions = list.map((model) => Question.fromJson(model)).toList();

    return questions;
  }

  Future<List<Questionnaire>> downloadQuestionnaireDatabase() async {
    String url =
        'https://melondev-frailty-project.herokuapp.com/api/download/downloadAllQuestionnaire';
    var response = await http.get(url);
    var questionnaire = new List<Questionnaire>();

    Iterable list = json.decode(response.body);
    questionnaire = list.map((model) => Questionnaire.fromJson(model)).toList();

    return questionnaire;
  }

  Future<List<Questionnaire>> getQuestionnaireDatabase() async {
    Database database = await initDatabase();
    List<Map> maps = await database.rawQuery('SELECT * FROM $questionnaireTable');
    if (maps.isNotEmpty) {
      return maps.map((model) {

        var q = Questionnaire.fromMap(model);
        return q;
      }).toList();
    }
    return null;
  }
}
