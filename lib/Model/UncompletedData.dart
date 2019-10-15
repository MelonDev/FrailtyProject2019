import 'package:frailty_project_2019/Model/AnswerPack.dart';
import 'package:frailty_project_2019/Model/Questionnaire.dart';

class UncompletedData {

  final AnswerPack answerPack;
  final int totalQuestion;
  final int completedQuestion;
  final Questionnaire questionnaire;

  UncompletedData({this.answerPack,this.questionnaire,this.totalQuestion,this.completedQuestion});

}