part of '../question_page.dart';

Widget _multiplyPage(BuildContext context,MultiplyQuestionState state) {
  CellCalculator _cellCalculator = new CellCalculator(context);

  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);

  return Container(
    color: Colors.white,
    child: SafeArea(
      child: Container(
        color: Colors.black.withAlpha(30),
        //color: Color(0xFF009688),
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          //margin: EdgeInsets.fromLTRB(0, 0, 0, (20+(80*count)).toDouble()),
                          margin:
                          EdgeInsets.fromLTRB(0, 0, 0,
                              _cellCalculator.calDesHeight(
                                  state.questionWithChoice)),
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: AutoSizeText(
                                state.questionWithChoice.question.message,
                                minFontSize: 16,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.black.withAlpha(160),
                                  fontWeight: FontWeight.w700,
                                  //color: Colors.white.withAlpha(230),
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          //margin: EdgeInsets.fromLTRB(0, 580, 0, 0),
                          /*
                            margin: EdgeInsets.fromLTRB(
                                0,
                                (560 - ((count > 5 ? 5 : count) * 80))
                                    .toDouble(),
                                0,
                                0),
                                */

                            margin: EdgeInsets.fromLTRB(
                                0, _cellCalculator.calChoiceAreaMarginTop(
                                state.questionWithChoice), 0, 0),
                            width: double.infinity,
                            height: _cellCalculator.calChoiceAreaHeight(state
                                .questionWithChoice),
                            //height: (50 + (count * 80)).toDouble(),
                            //height: 200,
                            color: Colors.white,
                            child: Stack(
                              children: <Widget>[
                                ListView.builder(
                                    itemCount: state.questionWithChoice
                                        .choices.length + 1,
                                    //itemCount: count,
                                    itemBuilder: (context, position) {
                                      if (position == 0) {
                                        return Container(
                                          margin: EdgeInsets.fromLTRB(
                                              20, 20, 20, 0),
                                          color: Colors.transparent,
                                          height: 30,
                                          width: double.infinity,
                                          child: Text(
                                            "ตัวเลือก ${state
                                                .questionWithChoice.choices
                                                .length} ข้อ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color:
                                              Colors.teal.withAlpha(255),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SukhumvitSet',
                                            ),
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                            onTap: () {
                                              _questionnaireBloc.dispatch(NextQuestionEvent(state.questionWithChoice.question.questionnaireId, state.questionWithChoice.question.id, state.questionWithChoice.choices[position - 1].id));
                                            },
                                            child: Container(
                                              margin: position == 0
                                                  ? EdgeInsets.fromLTRB(
                                                  20, 30, 20, 10)
                                                  : EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                              width: double.infinity,
                                              height: 60,
                                              child: Align(
                                                child: Text(
                                                  state.questionWithChoice
                                                      .choices[position - 1]
                                                      .message,
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white
                                                        .withAlpha(255),
                                                    //color: Color(0xFF42A898),
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    //color: Colors.white.withAlpha(230),
                                                    fontFamily:
                                                    'SukhumvitSet',
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                /*border: new Border.all(
                                                        color:
                                                            Color(0xFF42A898),
                                                        width: 3.0),*/
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          16)),
                                                  //color: Colors.black.withAlpha(50)
                                                  color: Color(0xFF009688)),
                                              //color: Colors.white)
                                            ));
                                      }
                                    })
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