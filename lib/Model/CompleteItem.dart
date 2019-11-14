import 'package:frailty_project_2019/Model/AnswerPack.dart';
import 'package:frailty_project_2019/Model/Questionnaire.dart';

class CompleteItem {

  final AnswerPack answerPack;
  final Questionnaire questionnaire;

  final String labelDateTime;

  CompleteItem(this.answerPack,this.questionnaire,this.labelDateTime);

}