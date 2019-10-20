import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailty_project_2019/Bloc/catalogue/catalogue_bloc.dart';
import 'package:frailty_project_2019/Bloc/questionnaire/questionnaire_bloc.dart';
import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/Question.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';
import 'package:frailty_project_2019/Tools/CellCalculator.dart';
import 'package:frailty_project_2019/database/OnLocalDatabase.dart';
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
          .add(NextQuestionEvent(_questionnaireKey, null, null, null));
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
            .primaryColor,
        appBar: mainPageAppbar(_state, context),
        body: _pageManager(context, _state));
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
