part of 'questionnaire_bloc.dart';

@immutable
abstract class QuestionnaireEvent {}

abstract class QuestionnaireDelegate {
  void onSuccess(String message);

  void onError(String message);
}


class InitialQuestionnaireEvent extends QuestionnaireEvent {}
