import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_thailand_provinces/dao/address_dao.dart';
import 'package:flutter_thailand_provinces/provider/address_provider.dart';
import 'package:frailty_project_2019/Design/result_page.dart';
import 'package:frailty_project_2019/Model/AccountRegister.dart';
import 'package:frailty_project_2019/Model/Answer.dart';
import 'package:frailty_project_2019/Model/AnswerResultPack.dart';
import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/ConstraintData.dart';
import 'package:frailty_project_2019/Model/HttpResult.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';
import 'package:frailty_project_2019/Model/TotalQuestionList.dart';
import 'package:frailty_project_2019/Tools/frailty_route.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestion.dart';
import 'package:frailty_project_2019/database/OnLocalDatabase.dart';
import 'package:frailty_project_2019/main.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

part 'questionnaire_event.dart';

part 'questionnaire_state.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  @override
  QuestionnaireState get initialState => InitialQuestionnaireState();

  List<int> generateNumber(ConstraintData data) {
    List<int> arr = <int>[];
    arr.clear();

    int min = 0;
    int max = 300;

    if (data != null) {
      min = data.min == null ? 0 : data.min;
      max = data.max == null ? 300 : data.max;
    }

    while (min <= max) {
      arr.add(min);
      min++;
    }
    return arr;
  }

  @override
  Stream<QuestionnaireState> mapEventToState(QuestionnaireEvent event) async* {
    if (event is InitialQuestionnaireEvent) {
    } else if (event is NextQuestionEvent) {
      yield* mapNextQuestionEventToState(event);
    } else if (event is ResumeQuestionEvent) {
      yield* mapResumeQuestionEventToState(event);
    } else if (event is RecentQuestionEvent) {
      yield* mapRecentQuestionEventToState(event);
    } else if (event is LoadQuestionEvent) {
      yield* mapLoadQuestionEventToState(event);
    } else if (event is UploadQuestionEvent) {
      yield* mapUploadEventToState(event);
    } else if (event is SearchingLocationEvent){
      yield* mapSearchingEventToState(event);
    }
  }

  @override
  Stream<QuestionnaireState> mapSearchingEventToState(SearchingLocationEvent event) async* {
    List<AddressDao> list =
    await AddressProvider.search(keyword: event.searchMessage);
    //yield AddressRegisterState(event.account, listAddress: _filterZeroAddress(list));
    yield LocationQuestionState(event.locationQuestionState.questionWithChoice, event.locationQuestionState.questionCounter, event.locationQuestionState.list,listAddress: list);
  }

  @override
  Stream<QuestionnaireState> mapUploadEventToState(UploadQuestionEvent event) async* {

    yield ResultLoadingQuestionState("กำลังอัปโหลด..", null);

    AnswerResultPack answerResultPack = await OnLocalDatabase().getAnswerResultPack(event.answerPackId);

    List<Map> answerListMap = answerResultPack.answer.map((Answer m) => m.toMap()).toList();

    String url =
        'https://melondev-frailty-project.herokuapp.com/api/upload/uploadAnswer';
    //Map<String, String> map = {"answerPack": answerResultPack.answerPack.toMap().toString(), "answer": answerListMap.toString()};

    var body = json.encode({"answerPack": answerResultPack.answerPack.toMap(), "answer": answerListMap});


    var response = await http.post(url, body: body,headers: {'Content-type': 'application/json'});
    HttpResult httpResult = HttpResult.fromJson(jsonDecode(response.body));

    print(httpResult.httpStatus);

    SharedPreferences preferences = await SharedPreferences.getInstance();

    final String currentAnswerPack =
    preferences.getString("CURRENT_ANSWERPACK");

    if(httpResult.httpStatus == 302){
      await OnLocalDatabase().deleteSlot(currentAnswerPack);

      Navigator.pop(event.context);

      /*Navigator.pushReplacement(
          event.context,
          FrailtyRoute(
              builder: (BuildContext context) =>
                  ResultPage()));

       */
    }else {
      Navigator.pop(event.context);
    }
  }

  @override
  Stream<QuestionnaireState> mapNextQuestionEventToState(
      NextQuestionEvent event) async* {
    await Future.delayed(Duration(milliseconds: 300));
    yield LoadingQuestionState("กำลังเปิดคำถาม..", event.lastList);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    OnLocalDatabase onLocalDatabase = OnLocalDatabase();

    QuestionWithChoice questionWithChoice;

    print("questionnaireId: ${event.questionnaireId}");
    print("choiceYouChoose: ${event.choiceYouChoose}");
    print("currentQuestionId: ${event.currentQuestionId}");

    if (event.questionWithChoice == null) {
      if (event.questionnaireId != null &&
          event.choiceYouChoose == null &&
          event.currentQuestionId == null) {
        await onLocalDatabase.createLocalSlot().then((_) async {
          questionWithChoice = await loadNext(event);
        });
      } else if (event.questionnaireId != null &&
          event.currentQuestionId != null &&
          event.value != null) {
        await onLocalDatabase
            .saveLocalSlot(event.currentQuestionId, event.value)
            .then((_) async {
          questionWithChoice = await loadNext(event);
        });
      } else if (event.questionnaireId != null &&
          event.currentQuestionId != null &&
          event.value == null) {
        questionWithChoice = await loadNext(event);
      }
    } else if (event.questionWithChoice.answer == null) {
      if (event.questionnaireId != null &&
          event.choiceYouChoose == null &&
          event.currentQuestionId == null) {
        await onLocalDatabase.createLocalSlot().then((_) async {
          questionWithChoice = await loadNext(event);
        });
      } else if (event.questionnaireId != null &&
          event.currentQuestionId != null &&
          event.value != null) {
        await onLocalDatabase
            .saveLocalSlot(event.currentQuestionId, event.value)
            .then((_) async {
          questionWithChoice = await loadNext(event);
        });
      } else if (event.questionnaireId != null &&
          event.currentQuestionId != null &&
          event.value == null) {
        questionWithChoice = await loadNext(event);
      }
    } else if (event.questionWithChoice.answer != null) {
      Answer newAns = Answer(
          id: event.questionWithChoice.answer.id,
          questionId: event.questionWithChoice.answer.questionId,
          answerPack: event.questionWithChoice.answer.answerPack,
          value: event.value);

      await onLocalDatabase.changeData(
          event.questionWithChoice.choices, newAns);
      questionWithChoice = await loadNext(event);
    }

    /*QuestionWithChoice questionWithChoice = await OnDeviceQuestion()
        .nextQuesion(event.questionnaireId, event.currentQuestionId,
            event.choiceYouChoose);
*/

    //final String counter =
    //preferences.getString("CURRENT_QUESTION");

    final String current = preferences.getString("CURRENT_ANSWERPACK");

    int count = await OnLocalDatabase().getCounter(current) + 1;

    /*List<QuestionWithChoice> listQWC = await OnDeviceQuestion()
        .superNewLoadAllQuestion(event.questionWithChoice == null
            ? (event.questionWithChoice.answer == null ? questionWithChoice.question.questionnaireId :questionWithChoice.question.questionnaireId)
            : (event.questionWithChoice.question.questionnaireId));
*/

    if (questionWithChoice.question.type.contains("FINISHED")) {
      yield FinishedQuestionState();
    } else {
      List<QuestionWithChoice> listQWC = await OnDeviceQuestion()
          .superNewLoadAllQuestion(questionWithChoice.question.questionnaireId);

      if (questionWithChoice.question.type.contains("number") ||
          questionWithChoice.question.type.contains("number_multiply")) {
        List<ConstraintData> listCon = [];

        if (questionWithChoice.question.type.contains("number_multiply")) {
          List<Choice> listChoice = questionWithChoice.choices;
          for (Choice choice in listChoice) {
            ConstraintData con =
                await OnDeviceQuestion().getConstraintData(choice.id);
            listCon.add(con);
          }
        } else {
          ConstraintData con = await OnDeviceQuestion()
              .getConstraintData(questionWithChoice.question.id);
          listCon.add(con);
        }

        questionWithChoice.constraint = listCon;
      }

      await Future.delayed(Duration(milliseconds: 200));

      if (questionWithChoice != null) {
        if (questionWithChoice.question.type.contains("title")) {
          yield TitleQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type.contains("textinput")) {
          yield TextInputQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type
            .contains("number_multiply")) {
          ConstraintData conA;
          ConstraintData conB;

          if (questionWithChoice.constraint != null) {
            if (questionWithChoice.constraint.length == 0) {
            } else if (questionWithChoice.constraint.length == 1) {
              if (questionWithChoice.constraint[0] != null) {
                int minA = questionWithChoice.constraint[0].min;
                int maxA = questionWithChoice.constraint[0].max;

                conA = ConstraintData(min: minA, max: maxA);
              }
            } else if (questionWithChoice.constraint.length == 2) {
              if (questionWithChoice.constraint[0] != null) {
                int minA = questionWithChoice.constraint[0].min;
                int maxA = questionWithChoice.constraint[0].max;

                conA = ConstraintData(min: minA, max: maxA);
              }

              if (questionWithChoice.constraint[1] != null) {
                int minB = questionWithChoice.constraint[1].min;
                int maxB = questionWithChoice.constraint[1].max;

                conB = ConstraintData(min: minB, max: maxB);
              }
            }
          }

          yield NumberMultiplyQuestionState(questionWithChoice,
              generateNumber(conA), generateNumber(conB), count, listQWC);
        } else if (questionWithChoice.question.type
            .contains("location_multiply")) {
          List<AddressDao> list =
          await AddressProvider.search(keyword: "");
          yield LocationQuestionState(questionWithChoice, count, listQWC,listAddress: list);
        } else if (questionWithChoice.question.type.contains("multiply")) {
          yield MultiplyQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type.contains("number")) {
          yield NumberQuestionState(
              questionWithChoice,
              questionWithChoice.constraint == null
                  ? generateNumber(null)
                  : generateNumber(questionWithChoice.constraint[0]),
              count,
              listQWC);
        } else {
          yield InitialQuestionnaireState();
        }
      } else {
        yield InitialQuestionnaireState();
      }
    }
  }

  @override
  Stream<QuestionnaireState> mapLoadQuestionEventToState(
      LoadQuestionEvent event) async* {
    yield LoadingQuestionState("กำลังเปิดคำถาม..", []);

    SharedPreferences preferences = await SharedPreferences.getInstance();

    final String current = preferences.getString("CURRENT_ANSWERPACK");
    //print("QQQ: ${current}");

    //preferences.setString("CURRENT_ANSWERPACK", event.questionWithChoice.answer.answerPack);

    //int count = await OnLocalDatabase().getCounter(event.questionWithChoice.answer.answerPack) + 1;
    int count = await OnLocalDatabase().getCounter(current) + 1;

    QuestionWithChoice questionWithChoice = event.questionWithChoice;

    if (questionWithChoice.question.type.contains("FINISHED")) {
      yield FinishedQuestionState();
    } else {
      List<QuestionWithChoice> listQWC = await OnDeviceQuestion()
          .superNewLoadAllQuestion(questionWithChoice.question.questionnaireId);

      if (questionWithChoice.question.type.contains("number") ||
          questionWithChoice.question.type.contains("number_multiply")) {
        List<ConstraintData> listCon = [];

        if (questionWithChoice.question.type.contains("number_multiply")) {
          List<Choice> listChoice = questionWithChoice.choices;
          for (Choice choice in listChoice) {
            ConstraintData con =
                await OnDeviceQuestion().getConstraintData(choice.id);
            listCon.add(con);
          }
        } else {
          ConstraintData con = await OnDeviceQuestion()
              .getConstraintData(questionWithChoice.question.id);
          listCon.add(con);
        }

        questionWithChoice.constraint = listCon;
      }

      await Future.delayed(Duration(milliseconds: 200));

      if (questionWithChoice != null) {
        if (questionWithChoice.question.type.contains("title")) {
          yield TitleQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type.contains("textinput")) {
          yield TextInputQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type
            .contains("number_multiply")) {
          ConstraintData conA;
          ConstraintData conB;

          if (questionWithChoice.constraint != null) {
            if (questionWithChoice.constraint.length == 0) {
            } else if (questionWithChoice.constraint.length == 1) {
              if (questionWithChoice.constraint[0] != null) {
                int minA = questionWithChoice.constraint[0].min;
                int maxA = questionWithChoice.constraint[0].max;

                conA = ConstraintData(min: minA, max: maxA);
              }
            } else if (questionWithChoice.constraint.length == 2) {
              if (questionWithChoice.constraint[0] != null) {
                int minA = questionWithChoice.constraint[0].min;
                int maxA = questionWithChoice.constraint[0].max;

                conA = ConstraintData(min: minA, max: maxA);
              }

              if (questionWithChoice.constraint[1] != null) {
                int minB = questionWithChoice.constraint[1].min;
                int maxB = questionWithChoice.constraint[1].max;

                conB = ConstraintData(min: minB, max: maxB);
              }
            }
          }

          yield NumberMultiplyQuestionState(questionWithChoice,
              generateNumber(conA), generateNumber(conB), count, listQWC);
        } else if (questionWithChoice.question.type
            .contains("location_multiply")) {
          List<AddressDao> list =
          await AddressProvider.search(keyword: "");
          yield LocationQuestionState(questionWithChoice, count, listQWC,listAddress: list);
        } else if (questionWithChoice.question.type.contains("multiply")) {
          yield MultiplyQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type.contains("number")) {
          yield NumberQuestionState(
              questionWithChoice,
              questionWithChoice.constraint == null
                  ? generateNumber(null)
                  : generateNumber(questionWithChoice.constraint[0]),
              count,
              listQWC);
        } else {
          yield InitialQuestionnaireState();
        }
      } else {
        yield InitialQuestionnaireState();
      }
    }
  }

  @override
  Stream<QuestionnaireState> mapResumeQuestionEventToState(
      ResumeQuestionEvent event) async* {
    yield LoadingQuestionState("กำลังเปิดคำถาม..", []);
    Answer lastAnswer =
        await OnLocalDatabase().findLastAnswer(event.answerPackId);

    print(lastAnswer);

    QuestionWithChoice questionWithChoice = await loadNext(NextQuestionEvent(
        event.questionnaireId,
        lastAnswer.questionId,
        lastAnswer.value,
        null,
        [],
        null));

    print("CHOICE ${questionWithChoice.choices != null ? questionWithChoice.choices.length : "NULL"}");

    print("H3");

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("CURRENT_ANSWERPACK", event.answerPackId);
    print("event.answerPackId : ${event.answerPackId}");

    if (questionWithChoice.question.type.contains("FINISHED")) {
      yield FinishedQuestionState();
    } else {


      int count = await OnLocalDatabase().getCounter(event.answerPackId) + 1;

      List<QuestionWithChoice> listQWC = await OnDeviceQuestion()
          .superNewLoadAllQuestion(questionWithChoice.question.questionnaireId);

      if (questionWithChoice.question.type.contains("number") ||
          questionWithChoice.question.type.contains("number_multiply")) {
        List<ConstraintData> listCon = [];

        if (questionWithChoice.question.type.contains("number_multiply")) {
          List<Choice> listChoice = questionWithChoice.choices;
          for (Choice choice in listChoice) {
            ConstraintData con =
                await OnDeviceQuestion().getConstraintData(choice.id);
            listCon.add(con);
          }
        } else {
          ConstraintData con = await OnDeviceQuestion()
              .getConstraintData(questionWithChoice.question.id);
          listCon.add(con);
        }

        questionWithChoice.constraint = listCon;
      }

      await Future.delayed(Duration(milliseconds: 200));

      if (questionWithChoice.constraint != null) {
        print("CON: ${questionWithChoice.constraint.length}");
      }

      if (questionWithChoice != null) {
        print("TEST0");

        if (questionWithChoice.question.type.contains("title")) {
          yield TitleQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type.contains("textinput")) {
          yield TextInputQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type
            .contains("number_multiply")) {
          ConstraintData conA;
          ConstraintData conB;

          if (questionWithChoice.constraint != null) {
            if (questionWithChoice.constraint.length == 0) {
            } else if (questionWithChoice.constraint.length == 1) {
              if (questionWithChoice.constraint[0] != null) {
                int minA = questionWithChoice.constraint[0].min;
                int maxA = questionWithChoice.constraint[0].max;

                conA = ConstraintData(min: minA, max: maxA);
              }
            } else if (questionWithChoice.constraint.length == 2) {
              if (questionWithChoice.constraint[0] != null) {
                int minA = questionWithChoice.constraint[0].min;
                int maxA = questionWithChoice.constraint[0].max;

                conA = ConstraintData(min: minA, max: maxA);
              }

              if (questionWithChoice.constraint[1] != null) {
                int minB = questionWithChoice.constraint[1].min;
                int maxB = questionWithChoice.constraint[1].max;

                conB = ConstraintData(min: minB, max: maxB);
              }
            }
          }

          yield NumberMultiplyQuestionState(questionWithChoice,
              generateNumber(conA), generateNumber(conB), count, listQWC);
        } else if (questionWithChoice.question.type
            .contains("location_multiply")) {
          List<AddressDao> list =
          await AddressProvider.search(keyword: "");
          yield LocationQuestionState(questionWithChoice, count, listQWC,listAddress: list);
        } else if (questionWithChoice.question.type.contains("multiply")) {
          yield MultiplyQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type.contains("number")) {
          yield NumberQuestionState(
              questionWithChoice,
              questionWithChoice.constraint == null
                  ? generateNumber(null)
                  : generateNumber(questionWithChoice.constraint[0]),
              count,
              listQWC);
        } else {
          print("TEST1");

          yield InitialQuestionnaireState();
        }
      } else {
        print("TEST2");

        yield InitialQuestionnaireState();
      }
    }
  }

  @override
  Stream<QuestionnaireState> mapRecentQuestionEventToState(
      RecentQuestionEvent event) async* {
    if (event.open) {
      print(event.questionWithChoice.question.type);

      //List<QuestionWithChoice> listQWC = await OnDeviceQuestion().loadAllQuestion(event.questionWithChoice.question.questionnaireId);
      //TotalQuesionList totalQuesionList = await OnDeviceQuestion().newLoadAllQuestion(event.questionWithChoice.question.questionnaireId);

      List<QuestionWithChoice> listQWC = await OnDeviceQuestion()
          .superNewLoadAllQuestion(
              event.questionWithChoice.question.questionnaireId);

      //yield RecentQuestionState(event.questionWithChoice,TotalQuesionList());
      yield RecentQuestionState(event.questionWithChoice, listQWC);
    } else {
      QuestionWithChoice questionWithChoice = event.questionWithChoice;

      if (questionWithChoice.question.type.contains("FINISHED")) {
        yield FinishedQuestionState();
      } else {
        List<QuestionWithChoice> listQWC = await OnDeviceQuestion()
            .superNewLoadAllQuestion(
                questionWithChoice.question.questionnaireId);

        SharedPreferences preferences = await SharedPreferences.getInstance();

        final String current = preferences.getString("CURRENT_ANSWERPACK");
        print(current.length);
        print(current);
        int count = await OnLocalDatabase().getCounter(current) + 1;

        if (questionWithChoice != null) {
          if (questionWithChoice.question.type.contains("title")) {
            yield TitleQuestionState(questionWithChoice, count, listQWC);
          } else if (questionWithChoice.question.type.contains("textinput")) {
            yield TextInputQuestionState(questionWithChoice, count, listQWC);
          } else if (questionWithChoice.question.type
              .contains("number_multiply")) {
            ConstraintData conA;
            ConstraintData conB;

            if (questionWithChoice.constraint != null) {
              if (questionWithChoice.constraint.length == 0) {
              } else if (questionWithChoice.constraint.length == 1) {
                if (questionWithChoice.constraint[0] != null) {
                  int minA = questionWithChoice.constraint[0].min;
                  int maxA = questionWithChoice.constraint[0].max;

                  conA = ConstraintData(min: minA, max: maxA);
                }
              } else if (questionWithChoice.constraint.length == 2) {
                if (questionWithChoice.constraint[0] != null) {
                  int minA = questionWithChoice.constraint[0].min;
                  int maxA = questionWithChoice.constraint[0].max;

                  conA = ConstraintData(min: minA, max: maxA);
                }

                if (questionWithChoice.constraint[1] != null) {
                  int minB = questionWithChoice.constraint[1].min;
                  int maxB = questionWithChoice.constraint[1].max;

                  conB = ConstraintData(min: minB, max: maxB);
                }
              }
            }

            yield NumberMultiplyQuestionState(questionWithChoice,
                generateNumber(conA), generateNumber(conB), count, listQWC);
          } else if (questionWithChoice.question.type
              .contains("location_multiply")) {
            List<AddressDao> list =
            await AddressProvider.search(keyword: "");
            yield LocationQuestionState(questionWithChoice, count, listQWC,listAddress: list);
          } else if (questionWithChoice.question.type.contains("multiply")) {
            yield MultiplyQuestionState(questionWithChoice, count, listQWC);
          } else if (questionWithChoice.question.type.contains("number")) {
            yield NumberQuestionState(
                questionWithChoice,
                questionWithChoice.constraint == null
                    ? generateNumber(null)
                    : generateNumber(questionWithChoice.constraint[0]),
                count,
                listQWC);
          } else {
            yield InitialQuestionnaireState();
          }
        } else {
          yield InitialQuestionnaireState();
        }
      }
    }
  }

  Future<QuestionWithChoice> loadNext(NextQuestionEvent event) async {
    QuestionWithChoice questionWithChoice = await OnDeviceQuestion()
        .nextQuesion(event.questionnaireId, event.currentQuestionId,
            event.choiceYouChoose);

    //print("Current: ${event.questionnaireId} ${event.currentQuestionId} ${event.choiceYouChoose}");
    //print("Current: ${questionWithChoice.question.questionnaireId} ${questionWithChoice.question.id} ${questionWithChoice.question.type}");

    return questionWithChoice;
  }
}
