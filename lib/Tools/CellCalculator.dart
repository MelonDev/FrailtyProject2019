import 'package:flutter/widgets.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';

class CellCalculator {

  BuildContext context;

  CellCalculator(this.context);

  double calDesHeight(QuestionWithChoice questionWithChoice) {
    if (MediaQuery
        .of(context)
        .size
        .height > 880) {
      return (40 + (questionWithChoice.choices.length * 80) + 30).toDouble();
    } else {
      return (40 +
          ((questionWithChoice.choices.length > 4 ? 4 : questionWithChoice
              .choices.length) * 80) +
          (questionWithChoice.choices.length <= 4 ? 30 : 0))
          .toDouble();
    }
  }

  double calChoiceAreaHeight(QuestionWithChoice questionWithChoice) {
    if (MediaQuery
        .of(context)
        .size
        .height > 880) {
      return (40 + (questionWithChoice.choices.length * 80) + 30).toDouble();
    } else {
      return (40 +
          ((questionWithChoice.choices.length > 4 ? 4 : questionWithChoice.choices.length) * 80) +
          (questionWithChoice.choices.length <= 4 ? 30 : 0))
          .toDouble();
    }
  }

  double calChoiceAreaMarginTop(QuestionWithChoice questionWithChoice) {
    if (MediaQuery
        .of(context)
        .size
        .height > 880) {
      return (550 - (questionWithChoice.choices.length * 80) - 30).toDouble();
    } else {
      return (550 -
          ((questionWithChoice.choices.length > 4 ? 4 : questionWithChoice.choices.length) * 80) -
          (questionWithChoice.choices.length <= 4 ? 30 : 0))
          .toDouble();
    }
  }

}