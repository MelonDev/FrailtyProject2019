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
  final QuestionWithChoice questionWithChoice;

  NextQuestionEvent(this.questionnaireId,this.currentQuestionId,this.choiceYouChoose,this.value,this.lastList,this.questionWithChoice);
}

class SearchingLocationEvent extends QuestionnaireEvent {

  final BuildContext context;

  final String searchMessage;
  final LocationQuestionState locationQuestionState;

  SearchingLocationEvent(this.locationQuestionState,{this.context,this.searchMessage});

}


class UploadQuestionEvent extends QuestionnaireEvent {
  final String answerPackId;
  final BuildContext context;

  UploadQuestionEvent(this.answerPackId,this.context);
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

class LoadQuestionEvent extends QuestionnaireEvent {

  final QuestionWithChoice questionWithChoice;



  LoadQuestionEvent(this.questionWithChoice);

}
