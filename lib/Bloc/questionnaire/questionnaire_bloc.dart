import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestion.dart';
import 'package:meta/meta.dart';

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
    }
  }

  @override
  Stream<QuestionnaireState> mapNextQuestionEventToState(
      NextQuestionEvent event) async* {
    yield LoadingQuestionState();
    QuestionWithChoice questionWithChoice = await OnDeviceQuestion()
        .nextQuesion(event.questionnaireId, event.currentQuestionId,
            event.choiceYouChoose);

    print("Current: ${event.questionnaireId} ${event.currentQuestionId} ${event.choiceYouChoose}");
    print("Current: ${questionWithChoice.question.questionnaireId} ${questionWithChoice.question.id} ${questionWithChoice.question.type}");


    if (questionWithChoice != null) {
      if (questionWithChoice.question.type.contains("title")) {
        yield TitleQuestionState(questionWithChoice);
      } else if (questionWithChoice.question.type.contains("textinput")) {
        yield TextInputQuestionState(questionWithChoice);
      } else if (questionWithChoice.question.type.contains("number_multiply")) {
        yield NumberMultiplyQuestionState(questionWithChoice, generateNumber());
      } else if (questionWithChoice.question.type.contains("location_multiply")) {
        yield LocationQuestionState(questionWithChoice);
      } else if (questionWithChoice.question.type.contains("multiply")) {
        yield MultiplyQuestionState(questionWithChoice);
      } else if (questionWithChoice.question.type.contains("number")) {
        yield NumberQuestionState(questionWithChoice, generateNumber());
      } else {
        yield InitialQuestionnaireState();
      }
    } else {
      yield InitialQuestionnaireState();
    }
  }
}
