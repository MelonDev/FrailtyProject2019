part of '../question_page.dart';

Widget _textInputPage(BuildContext context,TextInputQuestionState state) {
  ThemeData _themeData = Theme.of(context);

  // ignore: close_sinks
  QuestionnaireBloc _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);

  bool _actionBtn = false;

  String str = "";

  return Container(
    color: _themeData.primaryColor,
    child: SafeArea(
      child: Container(
        color: _themeData.primaryColor,
        //color: Color(0xFF009688),
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0, 0, 0, _actionBtn ? 180 : 240),
                        height: double.infinity,
                        width: double.infinity,
                        //color: Colors.black.withAlpha(30),
                        color: _themeData.backgroundColor,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: AutoSizeText(
                              state.questionWithChoice.question.message,
                              minFontSize: 16,
                              maxFontSize: 34,
                              style: TextStyle(
                                fontSize: 34,
                                //color: Colors.black.withAlpha(200),
                                color: _themeData.primaryTextTheme.bodyText1.color,
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
                            margin: EdgeInsets.fromLTRB(0, 00, 0, 0),
                            width: double.infinity,
                            height: _actionBtn ? 150 : 220,
                            color: _themeData.primaryColor,
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin:
                                        EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: Text(
                                          "กรุณาใส่คำตอบ",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily: 'SukhumvitSet',
                                              //color: Colors.black.withAlpha(150),
                                              color: _themeData.primaryTextTheme.subtitle1.color,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      height: 50,
                                      margin:
                                      EdgeInsets.fromLTRB(20, 16, 20, 0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          //color: Colors.black.withAlpha(30)
                                        color: _themeData.primaryTextTheme.subtitle1.color.withAlpha(30)
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              20, 0, 20, 0),
                                          child: TextField(
                                              keyboardAppearance: _themeData.brightness,
                                              keyboardType: TextInputType
                                                  .text,
                                              onTap: () {
                                                _actionBtn = true;
                                              },
                                              onChanged: (value){
                                                str = value;
                                              },
                                              onSubmitted: (str) {
                                                _actionBtn = false;
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                    new FocusNode());
                                              },
                                              style: TextStyle(
                                                  fontFamily: 'SukhumvitSet',
                                                  //color: Colors.black,
                                                  color: _themeData.primaryTextTheme.bodyText1.color,
                                                  fontSize: 21,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              cursorColor: _themeData.cursorColor,
                                              decoration: InputDecoration
                                                  .collapsed(
                                                  hintText: 'พิมพ์ที่นี่',
                                                  hintStyle: TextStyle(
                                                      fontFamily:
                                                      'SukhumvitSet',
                                                      //color: Colors.black.withAlpha(120),
                                                      color: _themeData.primaryTextTheme.subtitle1.color.withAlpha(160),
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight
                                                          .normal),
                                                  border:
                                                  InputBorder.none)),
                                        ),
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                      margin:
                                      EdgeInsets.fromLTRB(20, 30, 20, 0),
                                      child: Visibility(
                                        visible: !_actionBtn,
                                        child: MaterialButton(
                                          minWidth: 258,
                                          height: 56,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  16.0)),
                                          splashColor: Colors.white12,
                                          color: Colors.teal,
                                          elevation: 0,
                                          highlightElevation: 0,
                                          child: Text(
                                            "ยืนยัน",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontSize: 22,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            print(_actionBtn);
                                            if (_actionBtn) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                  new FocusNode());
                                              _actionBtn = false;
                                            } else {
                                              if(str.length > 0){
                                                _questionnaireBloc.add(NextQuestionEvent(state.questionWithChoice.question.questionnaireId,state.questionWithChoice.question.id,null,str,state.list,state.questionWithChoice));
                                              }else {
                                                showMyDialog(context);
                                              }
                                            }
                                          },
                                        ),
                                      )),
                                )
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

void showMyDialog(BuildContext context){
 ThemeData _themeData = Theme.of(context);


  showDialog(context: context,
      builder: (BuildContext context) =>
       new CupertinoAlertDialog(
        title: new Text(
          "ช่องว่างเปล่า",
          style: TextStyle(
              fontFamily: _themeData
                  .primaryTextTheme
                  .bodyText1
                  .fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _themeData.appBarTheme.textTheme.subtitle1.color.withAlpha(200)),
        ),
        content: new Text(
            "กรุณากรอกข้อมูลในช่องกรอกข้อมูลแล้วลองอีกครั้ง",
            style: TextStyle(
                fontFamily: _themeData
                    .primaryTextTheme
                    .bodyText1
                    .fontFamily,
                fontSize: 16,
                fontWeight:
                FontWeight.normal,
                color: _themeData.appBarTheme.textTheme.subtitle1.color.withAlpha(200).withAlpha(150))),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: new Text("รับทราบ",
                style: TextStyle(
                    fontFamily: _themeData
                        .primaryTextTheme
                        .bodyText1
                        .fontFamily,
                    fontSize: 18,
                    fontWeight:
                    FontWeight.normal,
                    color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();

            },
          ),
        ],
      ));
}