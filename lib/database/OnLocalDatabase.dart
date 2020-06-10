import 'package:frailty_project_2019/Model/Answer.dart';
import 'package:frailty_project_2019/Model/AnswerPack.dart';
import 'package:frailty_project_2019/Model/AnswerResultPack.dart';
import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/Question.dart';
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

  Future<AnswerResultPack> getAnswerResultPack(String answerPackId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final String currentAnswerPack =
    preferences.getString("CURRENT_ANSWERPACK");

    print("currentAnswerPack: $currentAnswerPack");

    Database database = await _initDatabase();

    List<Map> total = await database
        .rawQuery(
        "SELECT * FROM $answerPackTable ")
        .then((onValue) => onValue);
    List<AnswerPack> answerLists =
    total.map((m) => new AnswerPack.fromJson(m)).toList();

    AnswerPack answerPack;

    for(AnswerPack a in answerLists){
      if(a.id.contains(currentAnswerPack.toUpperCase())){
        answerPack = a;
      }
    }


    List<Map> answerList = await database
        .rawQuery(
        "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${currentAnswerPack.toUpperCase()}')")
        .then((onValue) => onValue);

    List<Answer> answers = answerList.map((m) => new Answer.fromJson(m)).toList();

    for (var a in answers){
      print(a.id);
    }

    if(answerPack != null){
      return AnswerResultPack(answerPack, answers);
    }else {
      return AnswerResultPack(null,null);
    }

  }

  Future createLocalSlot() async {
    Database database = await _initDatabase();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var now = new DateTime.now();
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String formatted = formatter.format(now);

    String uuid = Uuid().v4().toUpperCase();
    //final String userId = preferences.getString("USER_ID");
    final String userId = preferences.getString("ACCOUNT_USER_ID");
    //print("userIds: $userId}");


    AnswerPack answerPack = AnswerPack(
        id: uuid.toUpperCase(),
        takerId: userId.toUpperCase(),
        dateTime: formatted);

    Batch batch = database.batch();
    batch.insert(answerPackTable, answerPack.toMap());
    batch.commit().then((onValue) {
      preferences.setString("CURRENT_ANSWERPACK", answerPack.id);
      preferences.setInt("CURRENT_QUESTION", 0);
      print("Batch Complete");
    }).catchError((error) {
      print("Batch Error: $error");
    });
  }

  Future saveLocalSlot(String questionId, String value) async {
    Database database = await _initDatabase();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    print("ME");
    print(questionId);
    print(value);

    String uuid = Uuid().v4().toUpperCase();
    final String currentAnswerPack =
        preferences.getString("CURRENT_ANSWERPACK");

    await OnDeviceQuestion().spinQuestionToAnswer(questionId, value);

    Answer answer = Answer(
        id: uuid.toUpperCase(),
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

    batch.delete(answerPackTable,
        where: '$answerPackId = ?', whereArgs: [answerPackIds.toUpperCase()]);
    batch.delete(answerTable,
        where: '$answerAnswerPackId = ?',
        whereArgs: [answerPackIds.toUpperCase()]);

    batch.commit().then((onValue) {
      print("Batch Complete");
    }).catchError((error) {
      print("Batch Error: $error");
    });
  }

  Future deleteAnswer(String answerPackId, String targetId) async {
    Database database = await _initDatabase();

    List<Map> lists = await database
        .rawQuery(
            "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${answerPackId}') AND ($answerQuestionId = '${targetId}')")
        .then((onValue) => onValue);

    print("DELETE TEST: ${lists.length}");

    Batch batch = database.batch();

    //batch.delete(answerTable,where: '$answerId = ?', whereArgs: [answerPackIds.toUpperCase()]);

    batch.commit().then((onValue) {
      print("Batch Complete");
    }).catchError((error) {
      print("Batch Error: $error");
    });
  }

  Future deleteHistory() async {
    Database database = await _initDatabase();

    Batch batch = database.batch();

    List<Map> list = await database
        .rawQuery("SELECT * FROM $answerPackTable")
        .then((onValue) => onValue);
    List<AnswerPack> answerPackList =
        list.map((m) => new AnswerPack.fromJson(m)).toList();

    for (var answerPack in answerPackList) {
      List<Map> lists = await database
          .rawQuery(
              "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${answerPack.id}')")
          .then((onValue) => onValue);
      if (lists.length > 0) {
        List<Answer> answerList =
            list.map((m) => new Answer.fromJson(m)).toList();
        print(answerList.length);

        for (var answer in answerList) {
          batch.delete(answerTable,
              where: '$answerId = ?', whereArgs: [answer.id]);
        }

        batch.delete(answerPackTable,
            where: '$answerPackId = ?', whereArgs: [answerPack.id]);
      }
    }

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
        .rawQuery("SELECT * FROM $answerPackTable")
        .then((onValue) => onValue);
    List<AnswerPack> answerPackList =
        list.map((m) => new AnswerPack.fromJson(m)).toList();

    print(list.length);

    for (var answerPack in answerPackList) {
      List<Map> lists = await database
          .rawQuery(
              "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${answerPack.id}')")
          .then((onValue) => onValue);
      if (lists.length == 0) {
        batch.delete(answerPackTable,
            where: '$answerPackId = ?', whereArgs: [answerPack.id]);
      }
    }

    batch.commit().then((onValue) {
      print("Batch Complete");
    }).catchError((error) {
      print("Batch Error: $error");
    });
  }

  Future changeData(List<Choice> listChoice, Answer answer) async {
    Database database = await _initDatabase();

    Batch batch = database.batch();

    batch.update(answerTable, answer.toMap(),
        where: '$answerId = ?', whereArgs: [answer.id]);

    batch.commit().then((onValue) {
      print("Batch Complete");
    }).catchError((error) {
      print("Batch Error: $error");
    });
  }

  Future<int> getCounter(String answerPackIds) async {
    Database database = await _initDatabase();

    if(answerPackIds != null) {
      print("getCounter - answerPackIds : $answerPackIds");

      List<Map> list = await database
          .rawQuery(
          "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${answerPackIds
              .toUpperCase()}')")
          .then((onValue) => onValue);

      print(list.length);

      return list.length;
    }else {
      return 0;
    }
  }

  Future<Answer> findLastAnswer(String answerPackId) async {
    Database database = await _initDatabase();
    List<Map> list = await database
        .rawQuery(
            "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${answerPackId}')")
        .then((onValue) => onValue);
    Answer answer = new Answer.fromJson(list.last);
    //print(answer.questionId);
    //print(list.length);
    return answer;
  }

  Future<List<UncompletedData>> loadUnCompletedList() async {
    Database database = await _initDatabase();
    List<Map> list = await database
        .rawQuery("SELECT * FROM $answerPackTable")
        .then((onValue) => onValue);
    List<AnswerPack> answerPackList =
        list.map((m) => new AnswerPack.fromJson(m)).toList();

    List<UncompletedData> unList = [];

    for (var answerPack in answerPackList) {
      List<Map> pass = await database
          .rawQuery(
              "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${answerPack.id}')")
          .then((onValue) => onValue);
      Map passFirst = pass.first;
      Answer answer = Answer.fromMap(passFirst);

      Questionnaire questionnaire =
          await OnDeviceQuestion().findQuestionnaire(answer.questionId);

      int total =
          await OnDeviceQuestion().countOfQuestionnaire(questionnaire.id);

      unList.add(UncompletedData(
          answerPack: answerPack,
          totalQuestion: total,
          questionnaire: questionnaire,
          completedQuestion: pass.length,
          answer: answer));
    }
    return unList;
  }

  Future<Answer> loadAnswer(String questionIds) async {
    Database database = await _initDatabase();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String current = preferences.getString("CURRENT_ANSWERPACK");

    List<Map> pass = await database
        .rawQuery(
            "SELECT * FROM $answerTable WHERE ($answerAnswerPackId = '${current}') AND ($answerQuestionId = '${questionIds.toUpperCase()}')")
        .then((onValue) => onValue);
    if (pass.length > 0) {
      Map passFirst = pass.first;
      Answer answer = Answer.fromMap(passFirst);
      return answer;
    } else {
      return null;
    }
  }
}
