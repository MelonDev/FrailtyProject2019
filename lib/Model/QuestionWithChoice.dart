import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/Question.dart';

class QuestionWithChoice{

  final Question question;
  final List<Choice> choices;

  QuestionWithChoice(this.question,this.choices);

}