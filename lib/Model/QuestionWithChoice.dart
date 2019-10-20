import 'package:frailty_project_2019/Model/Answer.dart';
import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/Question.dart';

class QuestionWithChoice{

  final Question question;
  final List<Choice> choices;
  final Question fromQuestion;
  final Answer answer;
  final int position;

  QuestionWithChoice(this.question,this.choices,{this.fromQuestion,this.answer,this.position});

}