import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailty_project_2019/Bloc/catalogue/catalogue_bloc.dart';
import 'package:frailty_project_2019/Bloc/questionnaire/questionnaire_bloc.dart';
import 'package:frailty_project_2019/Model/Answer.dart';
import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/Question.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';
import 'package:frailty_project_2019/Tools/CellCalculator.dart';
import 'package:frailty_project_2019/database/OnLocalDatabase.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'QuestionPage/title_page.dart';

part 'QuestionPage/number_multiply_page.dart';

part 'QuestionPage/location_page.dart';

part 'QuestionPage/multiply_page.dart';

part 'QuestionPage/number_page.dart';

part 'QuestionPage/text_input_page.dart';

part 'QuestionPage/main_page.dart';

part 'QuestionPage/recent_page.dart';


class MainQuestion extends StatefulWidget {
  String _keys;
  String _answerPackId;

  MainQuestion(this._keys, this._answerPackId);

  @override
  _questionPage createState() => _questionPage();
}

class _questionPage extends State<MainQuestion> {
  QuestionnaireBloc _questionnaireBloc;

  CellCalculator _cellCalculator;

  String _questionnaireKey;
  String _answerPackId;


  int numberCounter;

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    _questionnaireKey = widget._keys;
    _answerPackId = widget._answerPackId;

    _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(this.context);
    _cellCalculator = new CellCalculator(context);

    if (_answerPackId == null) {
      _questionnaireBloc
          .add(NextQuestionEvent(_questionnaireKey, null, null, null,[]));
    } else {
      _questionnaireBloc
          .add(ResumeQuestionEvent(_questionnaireKey, _answerPackId));
    }


    return BlocBuilder<QuestionnaireBloc, QuestionnaireState>(
        builder: (context, _state) {
          return mainLayout(context, _state);
        });
  }

  Widget mainLayout(BuildContext context, QuestionnaireState _state) {
    return Scaffold(
        backgroundColor: Theme
            .of(context)
            .brightness == Brightness.dark? Color(0xFF0f0f0f) :Color(0xFFc4c4c4),
        appBar: Device.get().isTablet ? null :mainPageAppbar(_state, context),
        body: Device.get().isTablet
            ? _loadTabletSize(_state,context)
            : _pageManager(context, _state));
  }

  Widget _loadTabletSize(QuestionnaireState _state,BuildContext context) {
    ThemeData _themeData = Theme.of(context);



    return Row(
      children: <Widget>[
        Container(
          width: 300,
          color: DynamicTheme.of(context).brightness == Brightness.dark
              ? Color(0xFF121212)
              : Color(0xFFe8e8e8),
          child: Scaffold(
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0), // here the desired height
              child: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                titleSpacing: 0.0,
                centerTitle: true,
                automaticallyImplyLeading: false,
                // Don't show the leading button
                title: Text(
                  "ทั้งหมด",
                  textAlign:
                  TextAlign.left,
                  style: TextStyle(
                    //color: Colors.black.withAlpha(200),
                      color: _themeData
                          .primaryTextTheme
                          .title
                          .color,
                      fontFamily:
                      'SukhumvitSet',
                      fontSize: 22,
                      fontWeight:
                      FontWeight
                          .bold),
                ),

                brightness: _themeData.brightness,
                backgroundColor: _themeData.primaryColor,
                elevation: 0,
              ),
            ),
            body: _sideBar(_state, context),
          ),
          //child: _sideBar(_state,context),
        ),
        Container(
          width: 1,
          color: Colors.transparent,
          height: MediaQuery.of(context).size.width,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 300-1,
          child: Scaffold(
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            appBar: mainPageAppbar(_state, context),
            body: _pageManager(context,_state),
          ),
          //child: _pageManager(context,_state),
        )
      ],
    );
  }

  Widget _sideBar(QuestionnaireState _state,BuildContext context) {
    return recentPageTablet(_state, context);
  }


  Widget _pageManager(BuildContext context, QuestionnaireState _state) {
    if (_state is InitialQuestionnaireState) {
      return Container(
        color: Colors.white,
      );
    } else if (_state is LoadingQuestionState) {
      return Container(
          color: Theme
              .of(context)
              .primaryColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: SpinKitThreeBounce(
                    color: Theme
                        .of(context)
                        .primaryTextTheme
                        .subtitle
                        .color,
                    size: 50.0,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Text(_state.message,
                      style: TextStyle(
                          color:
                          Theme
                              .of(context)
                              .primaryTextTheme
                              .subtitle
                              .color,
                          fontSize: 18,
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.normal)),
                )
              ],
            ),
          ));
    } else if (_state is TitleQuestionState) {
      //getCounter();
      return _titlePage(context, _state);
    } else if (_state is NumberMultiplyQuestionState) {
      //getCounter();
      return _numberMultiplyPage(context, _state);
    } else if (_state is LocationQuestionState) {
      //getCounter();
      return _locationPage(context, _state);
    } else if (_state is MultiplyQuestionState) {
      //getCounter();
      return _multiplyPage(context, _state);
    } else if (_state is NumberQuestionState) {
      //getCounter();
      return _numberPage(context, _state);
    } else if (_state is TextInputQuestionState) {
      //getCounter();
      return _textInputPage(context, _state);
    } else if (_state is RecentQuestionState) {
      return recentPage(_state, context);
    } else if (_state is RequestPermissionState) {
      return Container(
        color: Colors.blue,
      );
    }
  }

/*
  void getCounter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String currentAnswerPack =
        preferences.getString("CURRENT_ANSWERPACK");

    int count = await OnLocalDatabase().getCounter(currentAnswerPack) + 1;
    numberCounter = count;
  }

   */


}
