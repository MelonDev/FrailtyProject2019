part of 'questionnaire_bloc.dart';

@immutable
abstract class QuestionnaireState {}

class MyQuestionnaireState extends QuestionnaireState {
  final int questionCounter;

  MyQuestionnaireState(this.questionCounter);
}


class InitialQuestionnaireState extends MyQuestionnaireState {

  InitialQuestionnaireState() : super(0);

  @override
  String toString() {
    return "InitialQuestionnaireState";
  }
}

class FirstQuestionState extends MyQuestionnaireState {
  FirstQuestionState() : super(0);

  @override
  String toString() {
    return "FirstQuestionState";
  }
}

class LoadingQuestionState extends MyQuestionnaireState {
  final String message;

  LoadingQuestionState(this.message) : super(0);

  @override
  String toString() {
    return "LoadingQuestionState";
  }
}

class TitleQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  TitleQuestionState(this.questionWithChoice,int counter) : super(counter);

  @override
  String toString() {
    return "TitleQuestionState";
  }
}

class NumberMultiplyQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;
  final List<int> numberList;

  NumberMultiplyQuestionState(this.questionWithChoice,this.numberList,int counter) : super(counter);

  @override
  String toString() {
    return "NumberMultiplyQuestionState";
  }
}

class LocationQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  LocationQuestionState(this.questionWithChoice,int counter) : super(counter);

  @override
  String toString() {
    return "LocationQuestionState";
  }
}

class MultiplyQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  MultiplyQuestionState(this.questionWithChoice,int counter) : super(counter);

  @override
  String toString() {
    return "MultiplyQuestionState";
  }
}

class NumberQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;
  final List<int> numberList;


  NumberQuestionState(this.questionWithChoice,this.numberList,int counter) : super(counter);

  @override
  String toString() {
    return "NumberQuestionState";
  }
}

class TextInputQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  TextInputQuestionState(this.questionWithChoice,int counter) : super(counter);

  @override
  String toString() {
    return "TextInputQuestionState";
  }
}

class RequestPermissionState extends MyQuestionnaireState {
  RequestPermissionState() : super(0);

  @override
  String toString() {
    return "RequestPermissionState";
  }
}

