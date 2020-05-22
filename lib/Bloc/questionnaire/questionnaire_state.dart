part of 'questionnaire_bloc.dart';

@immutable
abstract class QuestionnaireState {}

class MyQuestionnaireState extends QuestionnaireState {
  final int questionCounter;
  final List<QuestionWithChoice> list;
  final String qKey;

  MyQuestionnaireState(this.questionCounter,this.list,{this.qKey});
}


class InitialQuestionnaireState extends MyQuestionnaireState {

  InitialQuestionnaireState({List<QuestionWithChoice> list}) : super(0,list);

  @override
  String toString() {
    return "InitialQuestionnaireState";
  }
}

class FirstQuestionState extends MyQuestionnaireState {
  FirstQuestionState({List<QuestionWithChoice> list}) : super(0,list);

  @override
  String toString() {
    return "FirstQuestionState";
  }
}

class RecentQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;
  //final List<QuestionWithChoice> list;
  //final TotalQuesionList totalList;

  RecentQuestionState(this.questionWithChoice,List<QuestionWithChoice> list):super(0,list);

  @override
  String toString() {
    return "RecentState";
  }
}

class LoadingQuestionState extends MyQuestionnaireState {
  final String message;

  LoadingQuestionState(this.message,List<QuestionWithChoice> list) : super(0,list);

  @override
  String toString() {
    return "LoadingQuestionState";
  }
}

class ResultLoadingQuestionState extends MyQuestionnaireState {
  final String message;

  ResultLoadingQuestionState(this.message,List<QuestionWithChoice> list) : super(0,list);

  @override
  String toString() {
    return "ResultLoadingQuestionState";
  }
}


class FinishedQuestionState extends MyQuestionnaireState {


  FinishedQuestionState() : super(0,null);

  @override
  String toString() {
    return "FinishedQuestionState";
  }
}

class TitleQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  TitleQuestionState(this.questionWithChoice,int counter,List<QuestionWithChoice> list) : super(counter,list);

  @override
  String toString() {
    return "TitleQuestionState";
  }
}

class NumberMultiplyQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;
  final List<int> numberListA;
  final List<int> numberListB;


  NumberMultiplyQuestionState(this.questionWithChoice,this.numberListA,this.numberListB,int counter,List<QuestionWithChoice> list) : super(counter,list);

  @override
  String toString() {
    return "NumberMultiplyQuestionState";
  }
}

class LocationQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;
  final List<AddressDao> listAddress;

  LocationQuestionState(this.questionWithChoice,int counter,List<QuestionWithChoice> list,{this.listAddress}) : super(counter,list);

  @override
  String toString() {
    return "LocationQuestionState";
  }
}

class MultiplyQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  MultiplyQuestionState(this.questionWithChoice,int counter,List<QuestionWithChoice> list) : super(counter,list);

  @override
  String toString() {
    return "MultiplyQuestionState";
  }
}

class NumberQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;
  final List<int> numberList;


  NumberQuestionState(this.questionWithChoice,this.numberList,int counter,List<QuestionWithChoice> list) : super(counter,list);

  @override
  String toString() {
    return "NumberQuestionState";
  }
}

class TextInputQuestionState extends MyQuestionnaireState {
  final QuestionWithChoice questionWithChoice;

  TextInputQuestionState(this.questionWithChoice,int counter,List<QuestionWithChoice> list) : super(counter,list);

  @override
  String toString() {
    return "TextInputQuestionState";
  }
}

class RequestPermissionState extends MyQuestionnaireState {
  RequestPermissionState() : super(0,null);

  @override
  String toString() {
    return "RequestPermissionState";
  }
}

