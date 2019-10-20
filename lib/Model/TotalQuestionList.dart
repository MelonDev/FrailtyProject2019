import 'package:frailty_project_2019/Model/Answer.dart';
import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/Question.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';

class TotalQuesionList{

  final List<QuesionList> listOfQuesionList;
  final int count ;

  TotalQuesionList({this.listOfQuesionList,this.count});

}

class QuesionList{

  final QuestionWithChoice questionWithChoice;
  final List<QuestionWithChoice> questionWithChoiceList;
  final Question fromQuestion;
  final int count;

  QuesionList({this.questionWithChoice,this.fromQuestion,this.count,this.questionWithChoiceList});

}