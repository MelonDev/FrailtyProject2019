part of '../question_page.dart';

Widget recentPage(RecentQuestionState _state, BuildContext context) {
  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);
  ThemeData _themeData = Theme.of(context);

  return Container(
    color: _themeData.backgroundColor,
    child: ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 50),
      itemCount: _state.list.length,
      itemBuilder: (context, position) {
        print(position);

        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: _state.list[position].answer != null ?_themeData.accentColor:_themeData.cardColor),
          margin: EdgeInsets.fromLTRB(
              _state.list[position].question.category.length > 1 ? 60 : 20,
              0,
              20,
              10),
          padding: EdgeInsets.all(16),
          child: RichText(
            maxLines: 3,
            text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text:  _state.list[position].question.category.length > 1
                      ? "ข้อที่ ${_state.list[position].fromQuestion.position}.${_state.list[position].question.position}"
                      : "ข้อที่ ${_state.list[position].question.position}",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _state.list[position].answer != null ? Colors.white : _themeData.primaryTextTheme.title.color.withAlpha(100),
                      fontSize: 20,
                      fontFamily: _themeData.primaryTextTheme.subtitle.fontFamily)),
                  TextSpan(text: "\n${_state.list[position].question.message}",style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color:_state.list[position].answer != null ? Colors.white : _themeData.primaryTextTheme.title.color.withAlpha(100),
                      fontSize: 18,
                      fontFamily: _themeData.primaryTextTheme.subtitle.fontFamily))
                ]
            ),
          ),
          /*child: Text(
              _state.list[position].question.category.length > 1
                  ? "ข้อที่ ${_state.list[position].fromQuestion.position}.${_state.list[position].question.position}\n${_state.list[position].question.message}"
                  : "ข้อที่ ${_state.list[position].question.position}\n${_state.list[position].question.message}",
              maxLines: 2,
              semanticsLabel: ".",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _themeData.primaryTextTheme.title.color.withAlpha(170),
                  fontSize: 18,
                  fontFamily: _themeData.primaryTextTheme.subtitle.fontFamily)),

           */
        );
      },
    ),
  );
}
