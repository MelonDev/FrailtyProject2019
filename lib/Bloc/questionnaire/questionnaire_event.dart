part of 'questionnaire_bloc.dart';

@immutable
abstract class QuestionnaireEvent {}

abstract class QuestionnaireDelegate {
  void onSuccess(String message);

  void onError(String message);
}


class InitialQuestionnaireEvent extends QuestionnaireEvent {}

class NextQuestionEvent extends QuestionnaireEvent {

  String questionnaireId;
  String currentQuestionId;
  String choiceYouChoose;

  NextQuestionEvent(this.questionnaireId,this.currentQuestionId,this.choiceYouChoose);

}