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

      //await OnDeviceQuestion().nextQuesion("24129d77-f289-4634-a34f-e00c623ccf5f", "65c99713-8950-4bcd-9b82-c8cc43795679", "");

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
