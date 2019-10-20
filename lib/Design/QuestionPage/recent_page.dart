
part of '../question_page.dart';


Widget recentPage(RecentQuestionState _state, BuildContext context) {

  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);
  ThemeData _themeData = Theme.of(context);

  return Container(
    color: _themeData.backgroundColor,
  );

}