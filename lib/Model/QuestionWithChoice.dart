import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/Question.dart';

class QuestionWithChoice{

  final Question question;
  final List<Choice> choices;
  final Question fromQuestion;

  QuestionWithChoice(this.question,this.choices,{this.fromQuestion});

}