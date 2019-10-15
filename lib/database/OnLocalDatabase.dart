import 'package:frailty_project_2019/Model/Answer.dart';
import 'package:frailty_project_2019/Model/AnswerPack.dart';
import 'package:frailty_project_2019/Model/Questionnaire.dart';
import 'package:frailty_project_2019/Model/UncompletedData.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestion.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class OnLocalDatabase {
  final String answerPackTable = "ANSWERPACK";
  final String answerPackId = "id";
  final String answerPackTakerId = "takerId";
  final String answerPackDatetime = "dateTime";

  final String answerTable = "ANSWER";
  final String answerId = "id";
  final String answerQuestionId = "questionId";
  final String answerAnswerPackId = "answerPack";
  final String answerValue = "value";

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'localdatabase.db');
    Database db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE IF NOT EXISTS  $answerPackTable ($answerPackId text primary key,$answerPackTakerId text not null,$answerPackDatetime text not null)');
          await db.execute(
              'CREATE TABLE IF NOT EXISTS  $answerTable ($answerId text primary key,$answerQuestionId text not null,$answerAnswerPackId text not null,$answerValue text not null)');
        }).then((db) {
      return db;
    });
    return db;
  }

  Future createLocalSlot() async {
    Database database = await _initDatabase();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var now = new DateTime.now();
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String formatted = formatter.format(now);


    String uuid = Uuid().v4().toUpperCase();
    final String userId = preferences.getString("USER_ID");

    AnswerPack answerPack = AnswerPack(id: uuid.toUpperCase(),
        takerId: userId.toUpperCase(),
        dateTime: formatted);

    Batch batch = database.batch();
    batch.insert(answerPackTable, answerPack.toMap());
    batch.commit().then((onValue) {
      preferences.setString("CURRENT_ANSWERPACK", answerPack.id);
      print("Batch Complete");
    }).catchError((error) {
      print("Batch Error: $error");
    });
  }

  Future saveLocalSlot(String questionId, String value) async {
    Database database = await _initDatabase();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String uuid = Uuid().v4().toUpperCase();
    final String currentAnswerPack = preferences.getString(
        "CURRENT_ANSWERPACK");

    List<Map> list = await database
        .rawQuery(
        "SELECT * FROM $answerTable")
        .then((onValue) => onValue);


    Answer answer = Answer(id: uuid.toUpperCase(),
        questionId: questionId.toUpperCase(),
        answerPack: currentAnswerPack.toUpperCase(),
        value: value);

    Batch batch = database.batch();
    batch.insert(answerTable, answer.toMap());
    batch.commit().then((onValue) {
      print("Batch Complete");
    }).catchError((error) {
      print("Batch Error: $error");
    });
  }

  Future deleteSlot(String answerPackIds) async {
    Database database = await _initDatabase();

    Batch batch = database.batch();

    batch.delete(answerPackTable, where: '$answerPackId = ?', whereArgs: [answerPackIds.toUpperCase()]);
    batch.delete(answerTable, where: '$answerAnswerPackId = ?', whereArgs: [answerPackIds.toUpperCase()]);


    batch.commit().then((onValue) {

      print("Batch Complete");
    }).catchError((error) {
      print("Batch Error: $error");
    });
  }

  Future analysisLocalAnswerPack() async {
    Database database = await _initDatabase();

    Batch batch = database.batch();

    List<Map> list = await database
        .rawQuery(
        "SELECT * FROM $answerPackTable")
        .then((onValue) => onValue);
    List<AnswerPack> answerPackList = list.map((m) =>
    new AnswerPack.fromJson(m)).toList();

    for (var answerPack in answerPackList) {
      List<Map> lists = await database
          .rawQuery(
          "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${answerPack
              .id}')")
          .then((onValue) => onValue);
      if (lists.length == 0) {
        batch.delete(answerPackTable, where: '$answerPackId = ?', whereArgs: [answerPack.id]);
      }
    }
    batch.commit().then((onValue) {
      print("Batch Complete");
    }).catchError((error) {
      print("Batch Error: $error");
    });
  }

  Future<List<UncompletedData>> loadUnCompletedList() async {
    Database database = await _initDatabase();
    List<Map> list = await database
        .rawQuery(
        "SELECT * FROM $answerPackTable")
        .then((onValue) => onValue);
    List<AnswerPack> answerPackList = list.map((m) =>
    new AnswerPack.fromJson(m)).toList();

    List<UncompletedData> unList = [];


    for (var answerPack in answerPackList) {

      List<Map> pass = await database
          .rawQuery(
          "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${answerPack
              .id}')")
          .then((onValue) => onValue);
      Map passFirst = pass.first;
      Answer answer = Answer.fromMap(passFirst);

      Questionnaire questionnaire = await OnDeviceQuestion().findQuestionnaire(answer.questionId);

      int total = await OnDeviceQuestion().countOfQuestionnaire(questionnaire.id);

      unList.add(UncompletedData(answerPack: answerPack,totalQuestion: total,questionnaire: questionnaire,completedQuestion: pass.length));

    }
    return unList;
  }



}