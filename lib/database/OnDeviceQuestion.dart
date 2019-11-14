import 'dart:convert';

import 'package:frailty_project_2019/Model/Answer.dart';
import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/ConstraintData.dart';
import 'package:frailty_project_2019/Model/Question.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';
import 'package:frailty_project_2019/Model/Questionnaire.dart';
import 'package:frailty_project_2019/Model/TotalQuestionList.dart';
import 'package:frailty_project_2019/Model/Version.dart';
import 'package:frailty_project_2019/database/OnLocalDatabase.dart';
import 'package:frailty_project_2019/main.dart';
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
  final String choiceQuestionId = "questionId";
  final String choiceMessage = "message";
  final String choicePosition = "position";
  final String choiceDestinationId = "destinationId";

  final String constraintTable = "CONSTRAINTTABLE";
  final String constraintId = "id";
  final String constraintFromId = "fromId";
  final String constraintMin = "colmin";
  final String constraintMax = "colmax";

  Future<Database> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mylocaldatabase.db');
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
          await db.execute(
              'CREATE TABLE IF NOT EXISTS $constraintTable ($constraintId text primary key,$constraintFromId text not null,$constraintMin integer not null,$constraintMax integer not null)');
        });
    return db;
  }

  Future<QuestionWithChoice> nextQuesionProcess(
      String questionnaire, String currentKey, String choiceYouChoose) async {
    //List<Map> maps = await database.rawQuery("SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${questionnaire.toUpperCase()}') AND ($questionCategory = '-') ORDER BY $questionId ASC");

    Database database = await initDatabase();

    print(questionnaire);
    print(currentKey);
    print(choiceYouChoose);

    if (currentKey == null) {
      if (questionnaire != null) {

        if (questionnaire.length > 0) {
          List<Map> mapsQuestion = await database
              .rawQuery(
              "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${questionnaire.toUpperCase()}') AND ($questionCategory = '-') AND ($questionPosition = 1) ORDER BY $questionPosition ASC")
              .then((onValue) => onValue);
          Map mapQuestion = mapsQuestion.first;
          var q = Question.fromMap(mapQuestion);

          //print(q.id);

          List<Map> mapsChoice = await database
              .rawQuery(
              "SELECT * FROM $choiceTable WHERE ($choiceQuestionId = '${q.id.toLowerCase()}') ORDER BY $questionPosition ASC")
              .then((onValue) => onValue);
          List<Choice> choiceSnap =
          mapsChoice.map((m) => new Choice.fromJson(m)).toList();

          return QuestionWithChoice(q, choiceSnap);
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

        //print(qA1.id);
        //print(qA1.type);

        if (qA1.type.contains("title")) {
          List<Map> mapsA2 = await database.rawQuery(
              "SELECT * FROM $questionTable  WHERE ($questionCategory = '${qA1.id.toLowerCase()}') ORDER BY $questionPosition ASC");

          if (mapsA2 != null) {
            if (mapsA2.length > 0) {
              Map mapA2 = mapsA2.first;
              var qA2 = Question.fromMap(mapA2);

              List<Map> mapsA3 = await database.rawQuery(
                  "SELECT * FROM $choiceTable  WHERE ($choiceQuestionId = '${qA1.id.toLowerCase()}') ORDER BY $choicePosition ASC");
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
              List<Map> nextQuesRaw = await database.rawQuery(
                  "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${qA1.questionnaireId.toLowerCase()}') AND ($questionCategory = '-') AND ($questionPosition > ${qA1.position} ) ORDER BY $questionPosition ASC");
              Map nextQuesRaws = nextQuesRaw.first;
              var nextQues = Question.fromMap(nextQuesRaws);

              if (nextQues.type.contains("title")) {
                return QuestionWithChoice(nextQues, null);
              } else {
                List<Map> choiceListRaw = await database.rawQuery(
                    "SELECT * FROM $choiceTable  WHERE ($choiceQuestionId = '${nextQues.id.toLowerCase()}') ORDER BY $choicePosition ASC");
                if (choiceListRaw != null) {
                  var choiceList = choiceListRaw.map((model) {
                    var q = Choice.fromMap(model);
                    return q;
                  }).toList();

                  return QuestionWithChoice(nextQues, choiceList);
                } else {
                  return null;
                }
              }
            }
          } else {
            return null;
          }
        } else {

          if (qA1.category.length > 1) {

            List<Map> questionList = await database.rawQuery(
                "SELECT * FROM $questionTable  WHERE ($questionCategory = '${qA1.category.toLowerCase()}') ORDER BY $questionPosition ASC");

            if (questionList.length == qA1.position) {
              List<Map> questionSetRaw = await database.rawQuery(
                  "SELECT * FROM $questionTable  WHERE ($questionId = '${qA1.category.toUpperCase()}') ORDER BY $questionPosition ASC");

              Map questionSetRaws = questionSetRaw.first;
              var questionSet = Question.fromMap(questionSetRaws);

              List<Map> allQues = await database.rawQuery(
                  "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${questionSet.questionnaireId.toUpperCase()}') AND ($questionCategory = '-') ORDER BY $questionPosition ASC");

              //print("allQues: ${allQues.length}");
              //print("questionSet.position: ${questionSet.position}");

              if (allQues.length == questionSet.position) {
                Question question = Question(
                    message: "FINISHED",
                    type: "FINISHED",
                    category: "");
                return QuestionWithChoice(question, null);
              } else {
                List<Map> nextQuesRaw = await database.rawQuery(
                    "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${questionSet.questionnaireId.toUpperCase()}') AND ($questionCategory = '-') AND ($questionPosition > ${questionSet.position}) ORDER BY $questionPosition ASC");
                Map nextQuesRaws = nextQuesRaw.first;
                var nextQues = Question.fromMap(nextQuesRaws);

                if (nextQues.type.contains("title")) {
                  return QuestionWithChoice(nextQues, null);
                } else {
                  List<Map> choiceListRaw = await database.rawQuery(
                      "SELECT * FROM $choiceTable  WHERE ($choiceQuestionId = '${nextQues.id.toLowerCase()}') ORDER BY $choicePosition ASC");
                  if (choiceListRaw != null) {
                    var choiceList = choiceListRaw.map((model) {
                      var q = Choice.fromMap(model);
                      return q;
                    }).toList();

                    return QuestionWithChoice(nextQues, choiceList);
                  } else {
                    return null;
                  }
                }
              }
            } else {
              List<Map> quesNextRaw = await database.rawQuery(
                  "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${qA1.questionnaireId.toUpperCase()}') AND ($questionCategory = '${qA1.category.toLowerCase()}') AND ($questionPosition > ${qA1.position}) ORDER BY $questionPosition ASC");
              Map quesNextRaws = quesNextRaw.first;
              var quesNext = Question.fromMap(quesNextRaws);

              List<Map> choiceListRaw = await database.rawQuery(
                  "SELECT * FROM $choiceTable  WHERE ($choiceQuestionId = '${quesNext.category.toLowerCase()}') ORDER BY $choicePosition ASC");
              if (choiceListRaw != null) {
                var choiceList = choiceListRaw.map((model) {
                  var q = Choice.fromMap(model);
                  return q;
                }).toList();

                return QuestionWithChoice(quesNext, choiceList);
              } else {
                return null;
              }
            }
          } else {



            List<Map> allQues = await database.rawQuery(
                "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${qA1.questionnaireId.toUpperCase()}') AND ($questionCategory = '-') ORDER BY $questionPosition ASC");

            if (allQues.length == qA1.position) {
              Question question = Question(
                  message: "FINISHED",
                  type: "FINISHED",
                  category: "");
              return QuestionWithChoice(question, null);
            } else {

              if (qA1.type.contains("multiply")) {
                if (choiceYouChoose != null) {
                  //print(qA1.id);
                  //print(choiceYouChoose.toLowerCase());

                  List<Map> choiceRaw = await database.rawQuery(
                      "SELECT * FROM $choiceTable  WHERE ($choiceId = '${choiceYouChoose.toUpperCase()}') ORDER BY $choicePosition ASC");
                  Map choiceRaws = choiceRaw.first;
                  //print(choiceRaws.length);
                  var choice = Choice.fromMap(choiceRaws);

                  //print(choice.questionId);
                  //print(qA1.id);
                  //print(choice.destinationId.length);

                  if (choice.questionId.toLowerCase() == qA1.id.toLowerCase() &&
                      choice.destinationId.length > 1) {
                    List<Map> nextQuesRaw = await database.rawQuery(
                        "SELECT * FROM $questionTable  WHERE ($questionId = '${choice.destinationId.toUpperCase()}') ORDER BY $questionPosition ASC");

                    Map quesNextRaws = nextQuesRaw.first;
                    var quesNext = Question.fromMap(quesNextRaws);

                    List<Map> choiceListRaw = await database.rawQuery(
                        "SELECT * FROM $choiceTable  WHERE ($choiceQuestionId = '${quesNext.id.toLowerCase()}') ORDER BY $choicePosition ASC");
                    if (choiceListRaw != null) {
                      var choiceList = choiceListRaw.map((model) {
                        var q = Choice.fromMap(model);
                        return q;
                      }).toList();

                      return QuestionWithChoice(quesNext, choiceList);
                    } else {
                      return null;
                    }
                  } else if (choice.destinationId.contains("-")) {
                    List<Map> nextQuesRaw = await database.rawQuery(
                        "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${qA1.questionnaireId.toUpperCase()}') AND ($questionCategory = '-') AND ($questionPosition > ${qA1.position}) ORDER BY $questionPosition ASC");
                    Map quesNextRaws = nextQuesRaw.first;
                    var quesNext = Question.fromMap(quesNextRaws);

                    List<Map> choiceListRaw = await database.rawQuery(
                        "SELECT * FROM $choiceTable  WHERE ($choiceQuestionId = '${quesNext.id.toLowerCase()}') ORDER BY $choicePosition ASC");
                    if (choiceListRaw != null) {
                      var choiceList = choiceListRaw.map((model) {
                        var q = Choice.fromMap(model);
                        return q;
                      }).toList();

                      return QuestionWithChoice(quesNext, choiceList);
                    } else {
                      return null;
                    }
                  } else {
                    return QuestionWithChoice(null, null);
                  }
                } else {
                  List<Map> nextQuesRaw = await database.rawQuery(
                      "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${qA1.questionnaireId.toUpperCase()}') AND ($questionPosition > ${qA1.position}) ORDER BY $questionPosition ASC");

                  Map quesNextRaws = nextQuesRaw.first;
                  var quesNext = Question.fromMap(quesNextRaws);

                  List<Map> choiceListRaw = await database.rawQuery(
                      "SELECT * FROM $choiceTable  WHERE ($choiceQuestionId = '${quesNext.id.toLowerCase()}') ORDER BY $choicePosition ASC");
                  if (choiceListRaw != null) {
                    var choiceList = choiceListRaw.map((model) {
                      var q = Choice.fromMap(model);
                      return q;
                    }).toList();

                    return QuestionWithChoice(quesNext, choiceList);
                  } else {
                    return null;
                  }
                }
              } else {
                List<Map> nextQuesRaw = await database.rawQuery(
                    "SELECT * FROM $questionTable  WHERE ($questionQuestionnaireId = '${qA1.questionnaireId.toUpperCase()}') AND ($questionCategory = '-') AND ($questionPosition > ${qA1.position}) ORDER BY $questionPosition ASC");
                Map nextQuesRaws = nextQuesRaw.first;
                var nextQues = Question.fromMap(nextQuesRaws);

                if (nextQues.type.contains("title")) {
                  return QuestionWithChoice(nextQues, null);
                } else {
                  List<Map> choiceListRaw = await database.rawQuery(
                      "SELECT * FROM $choiceTable  WHERE ($choiceQuestionId = '${nextQues.id.toLowerCase()}') ORDER BY $choicePosition ASC");
                  if (choiceListRaw != null) {
                    var choiceList = choiceListRaw.map((model) {
                      var q = Choice.fromMap(model);
                      return q;
                    }).toList();

                    return QuestionWithChoice(nextQues, choiceList);
                  } else {
                    return null;
                  }
                }
              }
            }
          }
        }
      } else {
        return null;
      }
    }

    //print(maps.length);
  }

  Future<QuestionWithChoice> nextQuesion(
      String questionnaire, String currentKey, String choiceYouChoose) async {
    QuestionWithChoice nextQues =
    await nextQuesionProcess(questionnaire, currentKey, choiceYouChoose);


    Database database = await initDatabase();

    if (nextQues.question.category.length > 1) {

      List<Map> nextQuesRaw = await database.rawQuery(
          "SELECT * FROM $questionTable  WHERE ($questionId = '${nextQues.question.category.toUpperCase()}') ORDER BY $questionPosition ASC");

      Map quesNextRaws = nextQuesRaw.first;
      var quesNext = Question.fromMap(quesNextRaws);
      return QuestionWithChoice(nextQues.question, nextQues.choices,
          fromQuestion: quesNext);
    } else {

      return QuestionWithChoice(nextQues.question, nextQues.choices,
          fromQuestion: null);
    }
  }

  Future spinQuestionToAnswer(String qID,String value) async{
    Database database = await initDatabase();

    List<Map> list = await database
        .rawQuery("SELECT * FROM $choiceTable WHERE ($choiceQuestionId = '${qID.toLowerCase()}')")
        .then((onValue) => onValue);

    if(list.length > 0){
      var choiceList = list.map((choiceMap) {
        var choice = Choice.fromMap(choiceMap);
        return choice;
      }).toList();

      for(var choice in choiceList){
        print(value);
        if(value.contains(choice.message)){
          print("P: ${choice.id}");
        }else {
          print("N: ${choice.id}");

        }
      }
    }

  }

  Future<ConstraintData> getConstraintData(String questionIds)async{
    Database database = await initDatabase();

    List<Map> maps = await database
        .rawQuery(
        "SELECT * FROM $constraintTable WHERE ($constraintFromId = '${questionIds.toLowerCase()}')")
        .then((onValue) => onValue);
    if(maps.length > 0){
      Map map = maps.first;
      var c = ConstraintData.fromMap(map);

      return c;

    }else {
      return null;
    }


  }

  Future<int> countOfQuestionnaire(String questionnaire) async {
    Database database = await initDatabase();

    return await database
        .rawQuery(
        "SELECT * FROM $questionTable WHERE ($questionQuestionnaireId = '${questionnaire.toUpperCase()}')")
        .then((onValue) => onValue.length);
  }

  Future<Questionnaire> findQuestionnaire(String questionIds) async {
    Database database = await initDatabase();

    List<Map> maps = await database
        .rawQuery(
        "SELECT * FROM $questionTable WHERE ($questionId = '${questionIds.toUpperCase()}')")
        .then((onValue) => onValue);
    Map map = maps.first;
    var question = Question.fromMap(map);

    return await database
        .rawQuery(
        "SELECT * FROM $questionnaireTable WHERE ($questionnaireId = '${question.questionnaireId.toUpperCase()}')")
        .then((onValue) => Questionnaire.fromMap(onValue.first));
  }

  Future<List<QuestionWithChoice>> loadAllQuestion(
      String questionnaireIds) async {
    List<QuestionWithChoice> listQWC = [];

    Database database = await initDatabase();
    List<Map> allQuestion = await database.rawQuery(
        "SELECT * FROM $questionTable WHERE ($questionQuestionnaireId = '${questionnaireIds.toUpperCase()}') ORDER BY $questionPosition ASC");
    List<Question> listMap = await allQuestion.map((questionMap) {
      Question question = Question.fromMap(questionMap);
      return question;
    }).toList();

    for (Question question in listMap) {
      List<Map> choiceListRaw = await database.rawQuery(
          "SELECT * FROM $choiceTable WHERE ($choiceQuestionId = '${question.id.toLowerCase()}')");
      var choiceList = choiceListRaw.map((choiceMap) {
        var choice = Choice.fromMap(choiceMap);
        return choice;
      }).toList();

      Answer answer = await OnLocalDatabase().loadAnswer(question.id);

      listQWC.add(QuestionWithChoice(question, choiceList, answer: answer));
    }

    return listQWC;
  }

  Future<QuestionWithChoice> _loadQuestionWithChoice(
      Question question, List<Choice> list) async {
    if (list == null) {
      Database database = await initDatabase();
      List<Map> choiceListRaw = await database.rawQuery(
          "SELECT * FROM $choiceTable WHERE ($choiceQuestionId = '${question.id.toLowerCase()}')");
      var choiceList = choiceListRaw.map((choiceMap) {
        var choice = Choice.fromMap(choiceMap);
        return choice;
      }).toList();

      Answer answer = await OnLocalDatabase().loadAnswer(question.id);

      return QuestionWithChoice(question, choiceList, answer: answer);
    } else {
      Answer answer = await OnLocalDatabase().loadAnswer(question.id);

      return QuestionWithChoice(question, list, answer: answer);
    }
  }

  Future<TotalQuesionList> newLoadAllQuestion(String questionnaireIds) async {
    List<QuesionList> questionList = [];

    Database database = await initDatabase();
    List<Map> allQuestion = await database.rawQuery(
        "SELECT * FROM $questionTable WHERE ($questionQuestionnaireId = '${questionnaireIds.toUpperCase()}') ORDER BY $questionPosition ASC");

    int count = await countOfQuestionnaire(questionnaireIds);
    int counter = 0;

    for (Map questionMap in allQuestion) {
      Question question = Question.fromMap(questionMap);

      List<QuestionWithChoice> subQuestionList = [];

      QuestionWithChoice questionWithChoices =
      await _loadQuestionWithChoice(question, null);
      if (question.category.length <= 1) {
        //questionList.add(question);

        List<Map> myQuestionListRaw = await database.rawQuery(
            "SELECT * FROM $questionTable WHERE ($questionQuestionnaireId = '${question.questionnaireId.toUpperCase()}') AND ($questionCategory = '${question.id.toLowerCase()}') ORDER BY $questionPosition ASC");

        for (Map myQuestionMap in myQuestionListRaw) {
          Question myquestion = Question.fromMap(myQuestionMap);

          QuestionWithChoice questionWithChoice = await _loadQuestionWithChoice(
              myquestion, questionWithChoices.choices);
          subQuestionList.add(questionWithChoice);
        }

        counter = counter + subQuestionList.length + 1;
        questionList.add(QuesionList(
            questionWithChoice: questionWithChoices,
            questionWithChoiceList: subQuestionList,
            count: counter));
      }

      //print("COUNT: ${counter}");

    }

    return TotalQuesionList(count: count, listOfQuesionList: questionList);
  }

  Future<List<QuestionWithChoice>> superNewLoadAllQuestion(
      String questionnaireIds) async {
    List<QuesionList> questionList = [];

    List<QuestionWithChoice> list = [];

    Database database = await initDatabase();
    List<Map> allQuestion = await database.rawQuery(
        "SELECT * FROM $questionTable WHERE ($questionQuestionnaireId = '${questionnaireIds.toUpperCase()}') ORDER BY $questionPosition ASC");

    int count = await countOfQuestionnaire(questionnaireIds);
    int counter = 0;

    for (Map questionMap in allQuestion) {
      Question question = Question.fromMap(questionMap);

      List<QuestionWithChoice> subQuestionList = [];

      QuestionWithChoice questionWithChoices =
      await _loadQuestionWithChoice(question, null);

      if (question.category.length <= 1) {
        //questionList.add(question);

        List<Map> myQuestionListRaw = await database.rawQuery(
            "SELECT * FROM $questionTable WHERE ($questionQuestionnaireId = '${question.questionnaireId.toUpperCase()}') AND ($questionCategory = '${question.id.toLowerCase()}') ORDER BY $questionPosition ASC");
        counter += 1;
        list.add(QuestionWithChoice(
            questionWithChoices.question, questionWithChoices.choices,
            answer: questionWithChoices.answer, position: counter - 1));

        for (Map myQuestionMap in myQuestionListRaw) {
          Question myquestion = Question.fromMap(myQuestionMap);

          QuestionWithChoice questionWithChoicess =
          await _loadQuestionWithChoice(
              myquestion, questionWithChoices.choices);
          //subQuestionList.add(questionWithChoice);

          //list.add(QuestionWithChoice(questionWithChoicess.question,questionWithChoicess.choices,answer: questionWithChoicess.answer,position: counter));

          counter += 1;
          list.add(QuestionWithChoice(
              questionWithChoicess.question, questionWithChoicess.choices,
              answer: questionWithChoicess.answer,
              position: counter - 1,
              fromQuestion: questionWithChoices.question));
        }

        //counter = counter + subQuestionList.length + 1;
        //questionList.add(QuesionList(questionWithChoice: questionWithChoices,questionWithChoiceList: subQuestionList,count: counter));
      }

      //print("COUNT: ${counter}");

    }

    return list;

    //return TotalQuesionList(count: count,listOfQuesionList: questionList);
  }
}
