import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:frailty_project_2019/Model/Answer.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';
import 'package:frailty_project_2019/Model/TotalQuestionList.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestion.dart';
import 'package:frailty_project_2019/database/OnLocalDatabase.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'questionnaire_event.dart';

part 'questionnaire_state.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  @override
  QuestionnaireState get initialState => InitialQuestionnaireState();

  List<int> generateNumber() {
    List<int> arr = <int>[];
    arr.clear();
    var count = 0;
    while (count <= 300) {
      arr.add(count);
      count++;
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
    }
  }

  @override
  Stream<QuestionnaireState> mapNextQuestionEventToState(
      NextQuestionEvent event) async* {
    yield LoadingQuestionState("กำลังเปิดคำถาม..", event.lastList);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    OnLocalDatabase onLocalDatabase = OnLocalDatabase();

    QuestionWithChoice questionWithChoice;

    print("questionnaireId: ${event.questionnaireId}");
    print("choiceYouChoose: ${event.choiceYouChoose}");
    print("currentQuestionId: ${event.currentQuestionId}");

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

    /*QuestionWithChoice questionWithChoice = await OnDeviceQuestion()
        .nextQuesion(event.questionnaireId, event.currentQuestionId,
            event.choiceYouChoose);
*/

    //final String counter =
    //preferences.getString("CURRENT_QUESTION");

    final String current = preferences.getString("CURRENT_ANSWERPACK");

    int count = await OnLocalDatabase().getCounter(current) + 1;
    List<QuestionWithChoice> listQWC = await OnDeviceQuestion()
        .superNewLoadAllQuestion(questionWithChoice.question.questionnaireId);

    await Future.delayed(Duration(milliseconds: 200));

    if (questionWithChoice != null) {
      if (questionWithChoice.question.type.contains("title")) {
        yield TitleQuestionState(questionWithChoice, count, listQWC);
      } else if (questionWithChoice.question.type.contains("textinput")) {
        yield TextInputQuestionState(questionWithChoice, count, listQWC);
      } else if (questionWithChoice.question.type.contains("number_multiply")) {
        yield NumberMultiplyQuestionState(
            questionWithChoice, generateNumber(), count, listQWC);
      } else if (questionWithChoice.question.type
          .contains("location_multiply")) {
        yield LocationQuestionState(questionWithChoice, count, listQWC);
      } else if (questionWithChoice.question.type.contains("multiply")) {
        yield MultiplyQuestionState(questionWithChoice, count, listQWC);
      } else if (questionWithChoice.question.type.contains("number")) {
        yield NumberQuestionState(
            questionWithChoice, generateNumber(), count, listQWC);
      } else {
        yield InitialQuestionnaireState();
      }
    } else {
      yield InitialQuestionnaireState();
    }
  }

  @override
  Stream<QuestionnaireState> mapResumeQuestionEventToState(
      ResumeQuestionEvent event) async* {
    yield LoadingQuestionState("กำลังเปิดคำถาม..", []);
    Answer lastAnswer =
        await OnLocalDatabase().findLastAnswer(event.answerPackId);
    QuestionWithChoice questionWithChoice = await loadNext(NextQuestionEvent(
        event.questionnaireId,
        lastAnswer.questionId,
        lastAnswer.value,
        null, []));

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("CURRENT_ANSWERPACK", event.answerPackId);

    int count = await OnLocalDatabase().getCounter(event.answerPackId) + 1;

    List<QuestionWithChoice> listQWC = await OnDeviceQuestion()
        .superNewLoadAllQuestion(questionWithChoice.question.questionnaireId);

    await Future.delayed(Duration(milliseconds: 200));

    if (questionWithChoice != null) {
      if (questionWithChoice.question.type.contains("title")) {
        yield TitleQuestionState(questionWithChoice, count, listQWC);
      } else if (questionWithChoice.question.type.contains("textinput")) {
        yield TextInputQuestionState(questionWithChoice, count, listQWC);
      } else if (questionWithChoice.question.type.contains("number_multiply")) {
        yield NumberMultiplyQuestionState(
            questionWithChoice, generateNumber(), count, listQWC);
      } else if (questionWithChoice.question.type
          .contains("location_multiply")) {
        yield LocationQuestionState(questionWithChoice, count, listQWC);
      } else if (questionWithChoice.question.type.contains("multiply")) {
        yield MultiplyQuestionState(questionWithChoice, count, listQWC);
      } else if (questionWithChoice.question.type.contains("number")) {
        yield NumberQuestionState(
            questionWithChoice, generateNumber(), count, listQWC);
      } else {
        yield InitialQuestionnaireState();
      }
    } else {
      yield InitialQuestionnaireState();
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
      List<QuestionWithChoice> listQWC = await OnDeviceQuestion()
          .superNewLoadAllQuestion(questionWithChoice.question.questionnaireId);

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
          yield NumberMultiplyQuestionState(
              questionWithChoice, generateNumber(), count, listQWC);
        } else if (questionWithChoice.question.type
            .contains("location_multiply")) {
          yield LocationQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type.contains("multiply")) {
          yield MultiplyQuestionState(questionWithChoice, count, listQWC);
        } else if (questionWithChoice.question.type.contains("number")) {
          yield NumberQuestionState(
              questionWithChoice, generateNumber(), count, listQWC);
        } else {
          yield InitialQuestionnaireState();
        }
      } else {
        yield InitialQuestionnaireState();
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
