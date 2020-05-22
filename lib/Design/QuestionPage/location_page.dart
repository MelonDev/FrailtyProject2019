part of '../question_page.dart';

Widget _locationPage(BuildContext context, LocationQuestionState state) {
  CellCalculator _cellCalculator = new CellCalculator(context);

  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);
  ThemeData _themeData = Theme.of(context);

  return Container(
    color: _themeData.primaryColor,
    child: SafeArea(
      child: Container(
        //color: Colors.black.withAlpha(30),
        color: _themeData.backgroundColor,
        //color: Color(0xFF009688),
        child: _insertAddressPage(context, state),
        /*child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          //margin: EdgeInsets.fromLTRB(0, 0, 0, (20+(80*count)).toDouble()),
                          margin: EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              _cellCalculator
                                  .calDesHeight(state.questionWithChoice)),
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
                                  //color: Colors.black.withAlpha(160),
                                  color: _themeData
                                      .primaryTextTheme.bodyText1.color,
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
                            margin: EdgeInsets.fromLTRB(
                                0,
                                _cellCalculator.calChoiceAreaMarginTop(
                                    state.questionWithChoice),
                                0,
                                0),
                            width: double.infinity,
                            height: _cellCalculator
                                .calChoiceAreaHeight(state.questionWithChoice),
                            //height: (50 + (count * 80)).toDouble(),
                            //height: 200,
                            color: _themeData.primaryColor,
                            child: Stack(
                              children: <Widget>[
                                ListView.builder(
                                    itemCount: state
                                            .questionWithChoice.choices.length +
                                        1,
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
                                            "ตัวเลือก ${state.questionWithChoice.choices.length} ข้อ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.teal.withAlpha(255),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SukhumvitSet',
                                            ),
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                            onTap: () {
                                              //getLocation();
                                              /*nextQuestion(
                                                  context, state, position);

                                               */
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
                                                  state
                                                      .questionWithChoice
                                                      .choices[position - 1]
                                                      .message,
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white
                                                        .withAlpha(255),
                                                    //color: Color(0xFF42A898),
                                                    fontWeight: FontWeight.w700,
                                                    //color: Colors.white.withAlpha(230),
                                                    fontFamily: 'SukhumvitSet',
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
                                                          Radius.circular(16)),
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
        ]),*/
      ),
    ),
  );
}

Widget _insertAddressPage(BuildContext context, LocationQuestionState _state) {
  ThemeData _theme = Theme.of(context);

  return Stack(
    children: [
      Container(
        color: _theme.backgroundColor,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: _theme.bottomAppBarColor,
              child: _generateTextField(context, "ค้นหา", _state,
                  id: 1, size: 44, marginTop: 3, marginBottom: 0, fontSize: 19),
            ),
            Container(
              margin: EdgeInsets.only(top: 60, bottom: 50),
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _state.listAddress != null
                      ? (_state.listAddress.length)
                      : 0,
                  itemBuilder: (context, position) {
                    return FlatButton(
                      onPressed: () {
                        nextQuestion(
                            context, _state, _state.listAddress[position]);
                        /*_registerBloc.add(StartRegisterEvent(
                            _state.account,
                            _firstName,
                            _lastName,
                            _dateTime,
                            _state.listAddress[position],
                            context: this.context,
                            department: _personnel ? _department : null,
                            pin: _personnel ? _pin : null,
                            personnel: _personnel));

                         */
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${_state.listAddress[position].province.nameTh.contains("กรุงเทพมหานคร") ? "แขวง" : "ตำบล"}${_state.listAddress[position].district.nameTh}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                                "${_state.listAddress[position].province.nameTh.contains("กรุงเทพมหานคร") ? "" : "อำเภอ"}${_state.listAddress[position].amphure.nameTh}, จังหวัด${_state.listAddress[position].province.nameTh}, ${_state.listAddress[position].district.zipCode}",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.normal)),
                            position != (_state.listAddress.length - 1)
                                ? Container(
                                    color: _theme.dividerColor.withAlpha(100),
                                    margin: EdgeInsets.only(top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 1,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      )
    ],
  );
}

Widget _generateTextField(
    BuildContext context, String message, LocationQuestionState _state,
    {int id = 0,
    double size = 50,
    double marginTop = 16,
    double marginBottom = 0,
    double fontSize = 20}) {
  TextEditingController controller;
  ThemeData _theme = Theme.of(context);

  return Align(
    alignment: Alignment.center,
    child: Container(
      height: size,
      margin: EdgeInsets.fromLTRB(20, marginTop, 20, marginBottom),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          //color: Colors.black.withAlpha(30)
          color: _theme.primaryTextTheme.subtitle1.color.withAlpha(30)),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextField(
            controller: controller,
            keyboardAppearance: _theme.brightness,
            keyboardType: TextInputType.text,
            onTap: () {
              //_actionBtn = true;
            },
            onChanged: (value) {
              //str = value;
              _searching(context, _state, value);
            },
            onSubmitted: (str) {
              //_actionBtn = false;
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            style: TextStyle(
                fontFamily: 'SukhumvitSet',
                //color: Colors.black,
                color: _theme.primaryTextTheme.bodyText1.color,
                fontSize: fontSize += 1,
                fontWeight: FontWeight.normal),
            cursorColor: _theme.cursorColor,
            decoration: InputDecoration.collapsed(
                hintText: message,
                hintStyle: TextStyle(
                    fontFamily: 'SukhumvitSet',
                    //color: Colors.black.withAlpha(120),
                    color:
                        _theme.primaryTextTheme.subtitle1.color.withAlpha(160),
                    fontSize: fontSize,
                    fontWeight: FontWeight.normal),
                border: InputBorder.none),
          ),
        ),
      ),
    ),
  );
}

void _searching(
    BuildContext context, LocationQuestionState state, String message) {
  // _registerBloc
  //     .add(SearchingEvent(account, context: context, searchMessage: message));
  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);

  _questionnaireBloc.add(SearchingLocationEvent(
      state,
      context: context,
      searchMessage: message));
}

void nextQuestion(
    BuildContext context, LocationQuestionState state, AddressDao address) {
  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);

  _questionnaireBloc.add(NextQuestionEvent(
      state.questionWithChoice.question.questionnaireId,
      state.questionWithChoice.question.id,
      null,
      "${address.district.nameTh}/${address.amphure.nameTh}/${address.province.nameTh}/${address.district.zipCode}",
      state.list,
      state.questionWithChoice));
}
