import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailty_project_2019/Bloc/result_process/result_process_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultPage extends StatefulWidget {

  final String keyS;
  final String answerPackId;
  final String questionnaireName;
  final String dateTime;

  ResultPage({Key key,this.answerPackId,this.questionnaireName,this.dateTime,this.keyS}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  ThemeData _themeData;

  ResultProcessBloc _resultProcessBloc;

  @override
  void initState() {
    super.initState();

    _resultProcessBloc = BlocProvider.of<ResultProcessBloc>(this.context);

  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);

    print(widget.keyS);
    print(widget.answerPackId);
    print(widget.questionnaireName);
    print(widget.dateTime);

    _resultProcessBloc.add(LoadingResultProcessEvent(widget.keyS,widget.answerPackId,widget.questionnaireName,widget.dateTime));

    return BlocBuilder<ResultProcessBloc, ResultProcessState>(
        builder: (context, _state) {
      if (_state is LoadingResultProcessState) {
        return Scaffold(
          body: Material(
            child: Container(
                color: _themeData.brightness == Brightness.dark ? _themeData.backgroundColor : _themeData.primaryColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: SpinKitThreeBounce(
                          color: _themeData.primaryTextTheme.title.color,
                          size: 50.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Text("กำลังโหลด..",
                            style: TextStyle(
                                color: _themeData.primaryTextTheme.title.color,
                                fontSize: 18,
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.normal)),
                      )
                    ],
                  ),
                )),
          ),
        );
      } else if (_state is LoadedResultProcessState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "ผลการวิเคราะห์",
              style: TextStyle(
                  color: _themeData.primaryTextTheme.title.color,
                  //color: Colors.black.withAlpha(200),
                  fontFamily: 'SukhumvitSet',
                  //fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            elevation: 0,
            backgroundColor: _themeData.brightness == Brightness.dark
                ? _themeData.backgroundColor
                : _themeData.primaryColor,
          ),
          backgroundColor: _themeData.brightness == Brightness.dark
              ? _themeData.backgroundColor
              : _themeData.primaryColor,
          body: bodyWidget(_state),
        );
      } else {
        return Container(color: Colors.blue,);
      }
    });
  }

  Widget gaugeWidget(LoadedResultProcessState _state) {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0, top: 40),
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            minimum: 0,
            maximum: 100 ,
            showAxisLine: false,
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: 12,
                  color: Colors.green,
                  label: "ไม่เป็น",
                  rangeOffset: 0,
                  startWidth: 50,
                  labelStyle: GaugeTextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontSize: 20,
                      color: Colors.white),
                  endWidth: 50),
              GaugeRange(
                  startValue: 12.5,
                  endValue: 52,
                  color: Colors.orange,
                  label: "เสี่ยง",
                  rangeOffset: 0,
                  startWidth: 50,
                  labelStyle: GaugeTextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontSize: 20,
                      color: Colors.white),
                  endWidth: 50),
              GaugeRange(
                  startValue: 52.5,
                  endValue: 100,
                  color: Colors.red,
                  label: "เข้าข่าย",
                  labelStyle: GaugeTextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontSize: 20,
                      color: Colors.white),
                  startWidth: 50,
                  endWidth: 50)
            ],
            pointers: <GaugePointer>[
              NeedlePointer(value: _state.resultAfterProcess.percent.toDouble(), enableAnimation: true, needleLength: 0.8)
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child: Text(getMessage(_state.resultAfterProcess.resultMessage),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SukhumvitSet'))),
                  angle: 90,
                  positionFactor: 1)
            ],
            showTicks: false,
            showLabels: false)
      ]),
    );
  }

  Widget bodyWidget(LoadedResultProcessState _state) {
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int position) {
          if (position == 0) {
            return gaugeWidget(_state);
          } else {
            return Container(
              decoration: BoxDecoration(
                  color: _themeData.brightness == Brightness.light
                      ? _themeData.backgroundColor
                      : _themeData.primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 10,bottom: 10),
              margin: EdgeInsets.only(left: 20, right: 20, top: 30),
              child: getCard(_state),
            );
          }
        });
  }

  Widget getCard(LoadedResultProcessState _state){
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "ไอดี: ",
                          style: TextStyle(
                              color: _themeData
                                  .primaryTextTheme.title.color
                                  .withAlpha(200),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: _themeData
                                  .primaryTextTheme.title.fontFamily)),
                      TextSpan(
                          text:
                          "${_state.resultAfterProcess.answerPackId}",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: _themeData
                                  .primaryTextTheme.title.color
                                  .withAlpha(170),
                              fontSize: 18,
                              fontFamily: _themeData.primaryTextTheme
                                  .subtitle.fontFamily)),
                    ]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: "วันที่ทำ: ",
                        style: TextStyle(
                            color: _themeData
                                .primaryTextTheme.title.color
                                .withAlpha(200),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: _themeData
                                .primaryTextTheme.title.fontFamily)),
                    TextSpan(
                        text:
                        "${_loadDate(_state.resultAfterProcess.dateTime)}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: _themeData
                                .primaryTextTheme.title.color
                                .withAlpha(170),
                            fontSize: 18,
                            fontFamily: _themeData
                                .primaryTextTheme.subtitle.fontFamily)),
                  ]),
              maxLines: 1,
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: "ชื่อชุดแบบทดสอบ: ",
                        style: TextStyle(
                            color: _themeData
                                .primaryTextTheme.title.color
                                .withAlpha(200),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: _themeData
                                .primaryTextTheme.title.fontFamily)),
                    TextSpan(
                        text:
                        "\n${_state.resultAfterProcess.questionnaireName}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: _themeData
                                .primaryTextTheme.title.color
                                .withAlpha(170),
                            fontSize: 18,
                            fontFamily: _themeData
                                .primaryTextTheme.subtitle.fontFamily)),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: "คะแนนที่ได้: ",
                        style: TextStyle(
                            color: _themeData
                                .primaryTextTheme.title.color
                                .withAlpha(200),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: _themeData
                                .primaryTextTheme.title.fontFamily)),
                    TextSpan(
                        text:
                        "${_state.resultAfterProcess.score.toString()}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: _themeData
                                .primaryTextTheme.title.color
                                .withAlpha(170),
                            fontSize: 18,
                            fontFamily: _themeData
                                .primaryTextTheme.subtitle.fontFamily)),
                  ]),
              maxLines: 1,
            ),
          ],
        ));
  }
  
  String getMessage(String str){
    
    if(str.contains("non Pre-frail")){
return "ไม่เป็นภาวะเปราะบาง";
    }else if(str.contains("e-frail")){
      return "สุ่มเสี่ยงภาวะเปราะบาง";

    }else {
      return "เป็นภาวะเปราะบาง";

    }

  }


  String _loadDateForLabel(String date) {
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    DateTime dateTime = formatter.parse(date);
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year + 543}";
  }

  String _loadDate(String date) {
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    DateTime dateTime = formatter.parse(date);
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year + 543} (${dateTime.hour}:${dateTime.minute})";
  }

  String _getMonthName(int monthInt) {
    String month = "";
    switch (monthInt) {
      case 1:
        month = "มกราคม";
        break;
      case 2:
        month = "กุมภาพันธ์";
        break;
      case 3:
        month = "มีนาคม";
        break;
      case 4:
        month = "เมษายน";
        break;
      case 5:
        month = "พฤษภาคม";
        break;
      case 6:
        month = "มิถุนายน";
        break;
      case 7:
        month = "กรกฎาคม";
        break;
      case 8:
        month = "สิงหาคม";
        break;
      case 9:
        month = "กันยายน";
        break;
      case 10:
        month = "ตุลาคม";
        break;
      case 11:
        month = "พฤษจิกายน";
        break;
      case 12:
        month = "ธันวาคม";
        break;
    }
    return month;
  }
}
