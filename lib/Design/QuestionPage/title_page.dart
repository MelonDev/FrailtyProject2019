part of '../question_page.dart';

Widget _titlePage(BuildContext context,TitleQuestionState state) {
  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);

  return Container(
    color: Colors.white,
    child: SafeArea(
      child: Container(
        color: Colors.white,
        //color: Color(0xFF009688),
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 200),
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: AutoSizeText(
                              state.questionWithChoice.question.message,
                              minFontSize: 16,
                              maxFontSize: 30,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black.withAlpha(200),
                                fontWeight: FontWeight.bold,
                                //color: Colors.white.withAlpha(230),
                                fontFamily: 'SukhumvitSet',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                            width: double.infinity,
                            height: 200,
                            color: Colors.white,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child: FlatButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        _questionnaireBloc.dispatch(NextQuestionEvent(state.questionWithChoice.question.questionnaireId,state.questionWithChoice.question.id,null));
                                      },
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 30,
                                          color: Colors.black.withAlpha(180),
                                        ),
                                        decoration: BoxDecoration(
                                            border: new Border.all(
                                                color: Colors.black
                                                    .withAlpha(180),
                                                width: 2.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                            color: Colors.white),
                                      ),
                                    ))
                              ],
                            )),
                      )
                    ],
                  )))
        ]),
      ),
    ),
  );
}