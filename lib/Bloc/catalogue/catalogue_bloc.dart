import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frailty_project_2019/Model/AnswerPack.dart';
import 'package:frailty_project_2019/Model/CompleteItem.dart';
import 'package:frailty_project_2019/Model/Questionnaire.dart';
import 'package:frailty_project_2019/Model/UncompletedData.dart';
import 'package:frailty_project_2019/Model/UncompletedDataPack.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestion.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestionnaires.dart';
import 'package:frailty_project_2019/database/OnLocalDatabase.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'catalogue_event.dart';

part 'catalogue_state.dart';

class CatalogueBloc extends Bloc<CatalogueEvent, CatalogueState> {
  @override
  CatalogueState get initialState => InitialCatalogueState();

  @override
  Stream<CatalogueState> mapEventToState(CatalogueEvent event) async* {
    await OnLocalDatabase().analysisLocalAnswerPack();
    if (event is QuestionnaireSelectedEvent) {
      print("QuestionnaireSelectedEvent");
      yield* _mapOfflineQuestionnaireLoadingToState();
    } else if (event is UncompletedSelectedEvent) {
      print("UncompletedSelectedEvent");
      yield* _mapUncompletedToState();
    } else if (event is CompletedSelectedEvent) {
      print("CompletedSelectedEvent");
      yield* _mapCompletedToState();
    } else if (event is UncompletedDeleteItemEvent) {
      yield* _mapDeleteUncompletedToState(event);
    }
  }

  Stream<CatalogueState> _mapQuestionnaireLoadingToState() async* {
    yield LoadingCatalogueState();

    try {
      http.Response response = await http
          .get(
              'https://melondev-frailty-project.herokuapp.com/api/question/showAllQuestionnaire')
          .then((onValue) {
        return onValue;
      }).catchError((error) {
        return null;
      });
      if (response != null) {
        List responseJson = json.decode(response.body);
        List<Questionnaire> snapshot =
            responseJson.map((m) => new Questionnaire.fromJson(m)).toList();
        yield QuestionnaireCatalogueState(snapshot);
      } else {
        yield ErrorCatalogueState();
      }
    } catch (error) {
      yield ErrorCatalogueState();
    }

    //yield QuestionnaireCatalogueState();
  }

  Stream<CatalogueState> _mapOfflineQuestionnaireLoadingToState() async* {
    yield LoadingCatalogueState();

    try {
      var questionnaireList =
          await OnDeviceQuestionnaires().getQuestionnaireDatabase();
/*
      //var a = await OnDeviceQuestion().nextQuesion("5c942947-12ef-4f31-a7ed-6793ad85f609", null, null);
      //var a = await OnDeviceQuestion().nextQuesion("5c942947-12ef-4f31-a7ed-6793ad85f609", "e1a09147-1b16-48d2-86f3-16535d415902", null);
      //var a = await OnDeviceQuestion().nextQuesion("5c942947-12ef-4f31-a7ed-6793ad85f609", "5cb96909-3ab9-4159-8dc9-380b59e391c1", null);
      //var a = await OnDeviceQuestion().nextQuesion("5c942947-12ef-4f31-a7ed-6793ad85f609", "1de18f89-43a3-4a92-91e4-1bd637c45365", null);
      //var a = await OnDeviceQuestion().nextQuesion("5c942947-12ef-4f31-a7ed-6793ad85f609", "4018b02f-55a1-4e34-ae4a-7c801507611e", null);
      //var a = await OnDeviceQuestion().nextQuesion("5c942947-12ef-4f31-a7ed-6793ad85f609", "e65267a5-9c82-42e5-9e72-414eabf790af", null);

      //var a = await OnDeviceQuestion().nextQuesion("24129d77-f289-4634-a34f-e00c623ccf5f", "de504313-4668-4547-8579-02d7ce7a02b1", null);
      //var a = await OnDeviceQuestion().nextQuesion("24129d77-f289-4634-a34f-e00c623ccf5f", "9d13ca2d-a9b1-471e-b7ae-598c2ad261d6", "4027a147-ad81-46f5-9ca6-2130098f9475");
      //var a = await OnDeviceQuestion().nextQuesion("24129d77-f289-4634-a34f-e00c623ccf5f", "9d13ca2d-a9b1-471e-b7ae-598c2ad261d6", "4027a147-ad81-46f5-9ca6-2130098f9475");
      //var a = await OnDeviceQuestion().nextQuesion("24129d77-f289-4634-a34f-e00c623ccf5f", "de504313-4668-4547-8579-02d7ce7a02b1", null);



      var a = await OnDeviceQuestion().nextQuesion("5C942947-12EF-4F31-A7ED-6793AD85F609", "6242EF8E-AD46-4FF8-9705-E653D51BDCDE", "1b8278c5-d9af-448a-aa25-c56b9fdff123");
      if(a != null){
        print(a.question.message);
        for (var i in a.choices){
          print(i.message);
        }
        print("A_PASS");
      }else {
        print("A_NULL");
      }
*/

      yield QuestionnaireCatalogueState(questionnaireList);
    } catch (error) {
      yield ErrorCatalogueState();
    }

    //yield QuestionnaireCatalogueState();
  }

  Stream<CatalogueState> _mapUncompletedToState() async* {
    yield LoadingCatalogueState();

    List<UncompletedData> uncompletedData =
        await OnLocalDatabase().loadUnCompletedList();

    List<UncompleteDataPack> newList = _compareListDate(uncompletedData);
    //print("$uncompletedData $a");

    yield UncompletedCatalogueState(newList.reversed.toList());
    //yield UncompletedCatalogueState(uncompletedData.reversed.toList());
  }

  Stream<CatalogueState> _mapDeleteUncompletedToState(
      UncompletedDeleteItemEvent event) async* {
    yield LoadingCatalogueState();

    await OnLocalDatabase().deleteSlot(event.uncompletedData.answerPack.id);

    await Future.delayed(Duration(milliseconds: 200));

    List<UncompletedData> uncompletedData =
        await OnLocalDatabase().loadUnCompletedList();

    List<UncompleteDataPack> newList = _compareListDate(uncompletedData);
    //print("$uncompletedData $a");

    yield UncompletedCatalogueState(newList.reversed.toList());
    //yield UncompletedCatalogueState(uncompletedData.reversed.toList());

  }

  List<UncompleteDataPack> _compareListDate(
      List<UncompletedData> originalList) {
    List<UncompleteDataPack> newList = [];

    DateTime _datetime;

    int counter = 0;

    for (var data in originalList) {
      var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      DateTime dateTime = formatter.parse(data.answerPack.dateTime);
      DateTime _date =
          DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0);

      if (_datetime == null) {
        _datetime = _date;
        //newList.add(UncompleteDataPack(uncompletedData: null, labelDateTime: formatter.format(_date)));
      }

      if (_date.isAfter(_datetime)) {
        newList.add(UncompleteDataPack(uncompletedData: null, labelDateTime: formatter.format(_datetime)));
        newList.add(UncompleteDataPack(uncompletedData: data,labelDateTime: null));
        _datetime = _date;
      } else {
        newList.add(UncompleteDataPack(uncompletedData: data,labelDateTime: null));
      }

      counter++;

      if(counter == originalList.length){
        newList.add(UncompleteDataPack(uncompletedData: null, labelDateTime: formatter.format(_date)));
      }


    }

    return newList;
  }

  Stream<CatalogueState> _mapCompletedToState() async* {
    yield LoadingCatalogueState();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String oth = preferences.getString("ACCOUNT_USER_ID");


    print("oth $oth");


    String url =
        'https://melondev-frailty-project.herokuapp.com/api/result/getListOfResult';
    Map map = {"id": "", "oauth": oth};
    var response = await http.post(url, body: map);

    print("COM: ${response.body}");

    Iterable list = json.decode(response.body);

    List<AnswerPack> ans = list.map((model) => AnswerPack.fromJson(model)).toList();

    List<CompleteItem> listCom = [];

    for(var ap in ans){
      String url =
          'https://melondev-frailty-project.herokuapp.com/api/question/showQuestionnaireDetailFromAnswerPackId';
      Map map = {"key": ap.id};
      var response = await http.post(url, body: map);
      Questionnaire questionnaire = Questionnaire.fromJson(jsonDecode(response.body));

      print(questionnaire.name);
      listCom.add(CompleteItem(ap,questionnaire,null));
    }

    //Account account = Account.fromJson(jsonDecode(response.body));

    List<CompleteItem> newList = _compareCompleteListDate(listCom);

    print("newList.length ${newList.length}");


    yield CompletedCatalogueState(newList.reversed.toList());



/*
    String url =
        'https://melondev-frailty-project.herokuapp.com/api/result/getAllOfResult';

    Map map = {"id": "", "oauth": oth};
    var response = await http.post(url, body: map);

    print("COM: ${response.body}");

    Iterable listMap = json.decode(response.body);

    List<CompleteItem> listComplete = _compareCompleteListDate(listMap.map((model) {

      Questionnaire questionnaire = Questionnaire.fromJson(model['answer']['question']['questionnaire']);
      AnswerPack answerPack = AnswerPack.fromJson(model);
      return CompleteItem(answerPack,questionnaire,null);
    }).toList());

    yield CompletedCatalogueState(listComplete);

 */


  }

  List<CompleteItem> _compareCompleteListDate(
      List<CompleteItem> originalList) {
    List<CompleteItem> newList = [];

    DateTime _datetime;

    int counter = 0;

    for (var data in originalList) {
      var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      DateTime dateTime = formatter.parse(data.answerPack.dateTime);
      DateTime _date =
      DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0);

      if (_datetime == null) {
        _datetime = _date;
        //newList.add(UncompleteDataPack(uncompletedData: null, labelDateTime: formatter.format(_date)));
      }

      if (_date.isAfter(_datetime)) {
        newList.add(CompleteItem(null, null, formatter.format(_datetime)));
        newList.add(CompleteItem(data.answerPack, data.questionnaire, null));
        _datetime = _date;
      } else {
        newList.add(CompleteItem(data.answerPack, data.questionnaire, null));
      }

      counter++;

      if(counter == originalList.length){
        newList.add(CompleteItem(null, null, formatter.format(_datetime)));
      }


    }

    return newList;
  }
}
