part of 'questionnaire_bloc.dart';

@immutable
abstract class QuestionnaireState {}

class InitialQuestionnaireState extends QuestionnaireState {
  @override
  String toString() {
    return "InitialQuestionnaireState";
  }
}

class FirstQuestionState extends QuestionnaireState {
  @override
  String toString() {
    return "FirstQuestionState";
  }
}

class LoadingQuestionState extends QuestionnaireState {
  final String message;

  LoadingQuestionState(this.message);

  @override
  String toString() {
    return "LoadingQuestionState";
  }
}

class TitleQuestionState extends QuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  TitleQuestionState(this.questionWithChoice);

  @override
  String toString() {
    return "TitleQuestionState";
  }
}

class NumberMultiplyQuestionState extends QuestionnaireState {
  final QuestionWithChoice questionWithChoice;
  final List<int> numberList;

  NumberMultiplyQuestionState(this.questionWithChoice,this.numberList);

  @override
  String toString() {
    return "NumberMultiplyQuestionState";
  }
}

class LocationQuestionState extends QuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  LocationQuestionState(this.questionWithChoice);

  @override
  String toString() {
    return "LocationQuestionState";
  }
}

class MultiplyQuestionState extends QuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  MultiplyQuestionState(this.questionWithChoice);

  @override
  String toString() {
    return "MultiplyQuestionState";
  }
}

class NumberQuestionState extends QuestionnaireState {
  final QuestionWithChoice questionWithChoice;
  final List<int> numberList;


  NumberQuestionState(this.questionWithChoice,this.numberList);

  @override
  String toString() {
    return "NumberQuestionState";
  }
}

class TextInputQuestionState extends QuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  TextInputQuestionState(this.questionWithChoice);

  @override
  String toString() {
    return "TextInputQuestionState";
  }
}

class RequestPermissionState extends QuestionnaireState {
  @override
  String toString() {
    return "RequestPermissionState";
  }
}

