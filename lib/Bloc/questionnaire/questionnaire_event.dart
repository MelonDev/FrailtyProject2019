part of 'questionnaire_bloc.dart';

@immutable
abstract class QuestionnaireEvent {}

abstract class QuestionnaireDelegate {
  void onSuccess(String message);

  void onError(String message);
}


class InitialQuestionnaireEvent extends QuestionnaireEvent {}

class NextQuestionEvent extends QuestionnaireEvent {

  final String questionnaireId;
  final String currentQuestionId;
  final String choiceYouChoose;
  final String value;
  final List<QuestionWithChoice> lastList;

  NextQuestionEvent(this.questionnaireId,this.currentQuestionId,this.choiceYouChoose,this.value,this.lastList);

}

class ResumeQuestionEvent extends QuestionnaireEvent {

  final String questionnaireId;
  final String answerPackId;


  ResumeQuestionEvent(this.questionnaireId,this.answerPackId);

}

class RecentQuestionEvent extends QuestionnaireEvent {

  final bool open;
  final QuestionWithChoice questionWithChoice;



  RecentQuestionEvent(this.open,this.questionWithChoice);

}