import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frailty_project_2019/Bloc/questionnaire/questionnaire_bloc.dart';
import 'package:frailty_project_2019/Model/Choice.dart';
import 'package:frailty_project_2019/Model/QuestionWithChoice.dart';
import 'package:frailty_project_2019/Tools/CellCalculator.dart';
import 'package:path/path.dart';

part 'QuestionPage/title_page.dart';

part 'QuestionPage/number_multiply_page.dart';

part 'QuestionPage/location_page.dart';

part 'QuestionPage/multiply_page.dart';

part 'QuestionPage/number_page.dart';

part 'QuestionPage/text_input_page.dart';

part 'QuestionPage/main_page.dart';

class MainQuestion extends StatefulWidget {
  String _keys;
  String uuid;

  MainQuestion(this._keys, this.uuid);

  @override
  _questionPage createState() => _questionPage();
}

class _questionPage extends State<MainQuestion> {
  QuestionnaireBloc _questionnaireBloc;

  CellCalculator _cellCalculator;

  String _questionnaireKey;

  String _uuid;

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    _uuid = widget.uuid;
    _questionnaireKey = widget._keys;

    _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(this.context);
    _cellCalculator = new CellCalculator(context);

    _questionnaireBloc
        .dispatch(NextQuestionEvent(_questionnaireKey, null, null));

    print("UUID: $_uuid");

    return BlocBuilder<QuestionnaireBloc, QuestionnaireState>(
        builder: (context, _state) {
      return mainLayout(context, _state);
    });
  }

  Widget mainLayout(BuildContext context, QuestionnaireState _state) {
    return Scaffold(
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
        color: Colors.red,
      );
    } else if (_state is TitleQuestionState) {
      return _titlePage(context, _state);
    } else if (_state is NumberMultiplyQuestionState) {
      return _numberMultiplyPage(context, _state);
    } else if (_state is LocationQuestionState) {
      return _locationPage(context, _state);
    } else if (_state is MultiplyQuestionState) {
      return _multiplyPage(context, _state);
    } else if (_state is NumberQuestionState) {
      return _numberPage(context, _state);
    } else if (_state is TextInputQuestionState) {
      return _textInputPage(context, _state);
    } else if (_state is RequestPermissionState) {
      return Container(
        color: Colors.blue,
      );
    }
  }
}
