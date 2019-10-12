import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:frailty_project_2019/Model/Questionnaire.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestion.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestionnaires.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'catalogue_event.dart';

part 'catalogue_state.dart';

class CatalogueBloc extends Bloc<CatalogueEvent, CatalogueState> {
  @override
  CatalogueState get initialState => InitialCatalogueState();

  @override
  Stream<CatalogueState> mapEventToState(CatalogueEvent event) async* {
    if (event is QuestionnaireSelectedEvent) {
      print("QuestionnaireSelectedEvent");
      yield* _mapOfflineQuestionnaireLoadingToState();
    } else if (event is UncompletedSelectedEvent) {
      print("UncompletedSelectedEvent");
      yield* _mapUncompletedToState();
    } else if (event is CompletedSelectedEvent) {
      print("CompletedSelectedEvent");
      yield* _mapCompletedToState();
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
      var questionnaireList = await OnDeviceQuestionnaires().getQuestionnaireDatabase();

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



      var a = await OnDeviceQuestion().nextQuesion("24129d77-f289-4634-a34f-e00c623ccf5f", "65c99713-8950-4bcd-9b82-c8cc43795679", null);
      if(a != null){
        print(a.question.message);
        for (var i in a.choices){
          print(i.message);
        }
        print("A_PASS");
      }else {
        print("A_NULL");
      }



      yield QuestionnaireCatalogueState(questionnaireList);
    } catch (error) {
      yield ErrorCatalogueState();
    }

    //yield QuestionnaireCatalogueState();
  }

  Stream<CatalogueState> _mapUncompletedToState() async* {
    //yield LoadingCatalogueState();
    yield UncompletedCatalogueState();
  }

  Stream<CatalogueState> _mapCompletedToState() async* {
    //yield LoadingCatalogueState();
    yield CompletedCatalogueState();
  }
}
