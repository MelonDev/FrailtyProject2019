import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:frailty_project_2019/Bloc/authentication/authentication_bloc.dart';
import 'package:frailty_project_2019/Design/catalogue_page.dart';
import 'package:frailty_project_2019/Design/setting_page.dart';
import 'package:frailty_project_2019/Tools/frailty_route.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:io';

import '../home.dart';

class NewMain extends StatefulWidget {
  _newMain createState() => new _newMain();
}

class _newMain extends State<NewMain>
    with WidgetsBindingObserver
    implements AuthenticationDelegate {
  static const _appname = "ระบบวิเคราะห์ภาวะเปราะบาง";
  AuthenticationBloc _authenticationBloc;

  var _context;
  var firebaseAuth = FirebaseAuth.instance;
  PanelController _panelController = new PanelController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("resumed");
        _authenticationBloc.dispatch(AuthenticatingLoginEvent("กำลังรีเฟรส.."));
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.paused:
        print("paused");
        break;
      case AppLifecycleState.suspending:
        print("suspending");
        break;
    }
  }

  void goToQuestion(BuildContext context) {
    Navigator.push(context,
        FrailtyRoute(builder: (BuildContext context) => CataloguePage()));
  }

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    //_authenticationBloc = AuthenticationBloc();
    //_authenticationBloc = BlocProvider.BlocProvider.of(context).authenticationBloc;


    _context = context;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, _state) {
      if (_state is InitialAuthenticationState) {
        _authenticationBloc.dispatch(AuthenticatingLoginEvent("เช็คสถานะ.."));
        return SizedBox();
      } else if (_state is AuthenticatingState) {
        return Material(
          child: Container(
              color: Colors.teal,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Text(_state.message,
                          style: TextStyle(
                            color: Colors.white.withAlpha(220),
                              fontSize: 18,
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.normal)),
                    )
                  ],
                ),
              )),
        );
      } else if (_state is AuthenticatedState ||
          _state is UnAuthenticationState) {
        return Material(
          color: Color(0xFFD9D9D9),
          child: SlidingUpPanel(
            controller: _panelController,
            parallaxEnabled: true,
            minHeight: (105 + (Device.get().isIphoneX ? 25 : 0).toDouble()),
            maxHeight: _state is AuthenticatedState
                ? (_state.account.personnel ? 520 : 570)
                : 460,
            backdropEnabled: true,
            backdropTapClosesPanel: true,
            renderPanelSheet: false,
            panel: _floatingPanel(context, _state),
            collapsed: _floatingCollapsed(_state),
            body: Scaffold(
              backgroundColor: Color(0xFFD9D9D9),
              appBar: AppBar(
                elevation: 0,
                title: Text(_appname,
                    style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold)),
              ),
              body: BlocBuilder(
                bloc: _authenticationBloc,
                builder: (BuildContext context, AuthenticationState _state) {
                  return Stack(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xFF52c7b8),
                                  Color(0xFFD9D9D9),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                          child: SingleChildScrollView(
                            child: Stack(children: <Widget>[
                              Center(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      17.5, 25.0, 17.5, 120.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              blurRadius: 10.0,
                                            ),
                                          ]),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 530),
                                            //width: MediaQuery.of(context).size.width > 1000 ? 1000 : MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(24)),
                                                color: Colors.white),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      top: 26,
                                                      left: 30,
                                                      right: 30,
                                                      bottom: 20),
                                                  color: Colors.transparent,
                                                  child: Image.asset(
                                                    'images/funny-elderly-couple-dancing-cartoon-vector-24002358.jpg',
                                                    fit: BoxFit.contain,
                                                    height: Device.get()
                                                            .isIphoneX
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.7
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.2,
                                                  ),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            24, 0, 20, 0),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              'แบบทดสอบภาวะเปราะบาง',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'SukhumvitSet',
                                                                  fontSize:
                                                                      Device.get()
                                                                              .isTablet
                                                                          ? 26
                                                                          : 21,
                                                                  color: Colors
                                                                      .teal[600]
                                                                      .withOpacity(
                                                                          0.8),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              'ภาวะเปราะบาง คือ ภาวะหนึ่งของร่างกายซึ่งอยู่ระหว่าง ภาวะที่สามารถทำงานต่างๆได้ กับ ภาวะไร้ความสามารถ หรือก็คือ ระหว่างสุขภาพดี กับความเป็นโรค โดยในผู้สูงอายุ ช่วงเวลาดังกล่าวเป็นช่วงที่มีความสุ่มเสี่ยงจะเกิดการพลัดตกหรือหกล้ม',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              maxLines: 5,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'SukhumvitSet',
                                                                  fontSize: Device
                                                                              .get()
                                                                          .isTablet
                                                                      ? 22
                                                                      : 17,
                                                                  color: Colors
                                                                      .black45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            )
                                                          ],
                                                        ))),
                                                Container(
                                                  height: 1,
                                                  width: 180,
                                                  margin: EdgeInsets.only(
                                                      top: 15, bottom: 15),
                                                  color: Colors.teal,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  child: MaterialButton(
                                                    minWidth: 256,
                                                    height: 56,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14.0)),
                                                    splashColor: Colors.white12,
                                                    color: Colors.teal,
                                                    elevation: 0,
                                                    highlightElevation: 0,
                                                    child: Text(
                                                      _state is AuthenticatedState
                                                          ? "เริ่มทำแบบทดสอบ"
                                                          : "ลงชื่อเข้าใช้",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SukhumvitSet',
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      if (_state
                                                          is AuthenticatedState) {
                                                        //print("I'm ready!");
                                                        goToQuestion(context);
                                                      } else {
                                                        _panelController.open();
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              )
                            ]),
                          ))
                    ],
                  );
                },
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    });

    return BlocBuilder(
        bloc: _authenticationBloc,
        builder: (BuildContext context, AuthenticationState _state) {
          if (_state is InitialAuthenticationState) {
            _authenticationBloc.dispatch(AuthenticatingLoginEvent(null));
            return SizedBox();
          } else if (_state is AuthenticatingState) {
            return Container(
              color: Colors.teal,
              child: Center(
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            );
          } else if (_state is AuthenticatedState ||
              _state is UnAuthenticationState) {
            return Material(
              color: Color(0xFFD9D9D9),
              child: SlidingUpPanel(
                controller: _panelController,
                parallaxEnabled: true,
                minHeight: (105 + (Device.get().isIphoneX ? 25 : 0).toDouble()),
                maxHeight: _state is AuthenticatedState
                    ? (_state.account.personnel ? 520 : 570)
                    : 460,
                backdropEnabled: true,
                backdropTapClosesPanel: true,
                renderPanelSheet: false,
                panel: _floatingPanel(context, _state),
                collapsed: _floatingCollapsed(_state),
                body: Scaffold(
                  backgroundColor: Color(0xFFD9D9D9),
                  appBar: AppBar(
                    elevation: 0,
                    title: Text(_appname,
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold)),
                  ),
                  body: BlocBuilder(
                    bloc: _authenticationBloc,
                    builder:
                        (BuildContext context, AuthenticationState _state) {
                      return Stack(
                        children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF52c7b8),
                                      Color(0xFFD9D9D9),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                              child: SingleChildScrollView(
                                child: Stack(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        17.5, 25.0, 17.5, 120.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(24)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                blurRadius: 10.0,
                                              ),
                                            ]),
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              //width: MediaQuery.of(context).size.width > 1000 ? 1000 : MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(24)),
                                                  color: Colors.white),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 26,
                                                        left: 30,
                                                        right: 30,
                                                        bottom: 20),
                                                    color: Colors.transparent,
                                                    child: Image.asset(
                                                      'images/funny-elderly-couple-dancing-cartoon-vector-24002358.jpg',
                                                      fit: BoxFit.contain,
                                                      height: Device
                                                                  .get()
                                                              .isIphoneX
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.7
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3.2,
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              24, 0, 20, 0),
                                                      child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                'แบบทดสอบภาวะเปราะบาง',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'SukhumvitSet',
                                                                    fontSize:
                                                                        Device.get().isTablet
                                                                            ? 26
                                                                            : 21,
                                                                    color: Colors
                                                                        .teal[
                                                                            600]
                                                                        .withOpacity(
                                                                            0.8),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                'ภาวะเปราะบาง คือ ภาวะหนึ่งของร่างกายซึ่งอยู่ระหว่าง ภาวะที่สามารถทำงานต่างๆได้ กับ ภาวะไร้ความสามารถ หรือก็คือ ระหว่างสุขภาพดี กับความเป็นโรค โดยในผู้สูงอายุ ช่วงเวลาดังกล่าวเป็นช่วงที่มีความสุ่มเสี่ยงจะเกิดการพลัดตกหรือหกล้ม',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'SukhumvitSet',
                                                                    fontSize:
                                                                        Device.get().isTablet
                                                                            ? 22
                                                                            : 17,
                                                                    color: Colors
                                                                        .black45,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              )
                                                            ],
                                                          ))),
                                                  Container(
                                                    height: 1,
                                                    width: 180,
                                                    margin: EdgeInsets.only(
                                                        top: 15, bottom: 15),
                                                    color: Colors.teal,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 20),
                                                    child: MaterialButton(
                                                      minWidth: 256,
                                                      height: 56,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14.0)),
                                                      splashColor:
                                                          Colors.white12,
                                                      color: Colors.teal,
                                                      elevation: 0,
                                                      highlightElevation: 0,
                                                      child: Text(
                                                        _state is AuthenticatedState
                                                            ? "เริ่มทำแบบทดสอบ"
                                                            : "ลงชื่อเข้าใช้",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SukhumvitSet',
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onPressed: () {
                                                        if (_state
                                                            is AuthenticatedState) {
                                                          //print("I'm ready!");
                                                          goToQuestion(context);
                                                        } else {
                                                          _panelController
                                                              .open();
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                ]),
                              ))
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _authenticatedBottomBar(AuthenticationState state) {
    var _state = state as AuthenticatedState;
    return Padding(
        padding: EdgeInsets.fromLTRB(10.0, 14.0, 10.0, 0.0),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  //'ชัยวิวัฒน์ กกสันเทียะ',
                  '${_state.account.firstName} ${_state.account.lastName}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontSize: 21,
                      color: Colors.teal[600].withOpacity(0.8),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'ประเภท: ${_state.account.personnel ? "บุคลากร" : "ผู้ใช้ทั่วไป"}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontSize: 15,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 54,
                  width: 54,
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: FlatButton(
                      onPressed: null,
                      padding:
                          EdgeInsets.only(right: 0, left: 5, top: 5, bottom: 5),
                      child: Image.asset(
                        'images/settings.png',
                        color: Colors.black45,
                        fit: BoxFit.contain,
                      )),
                )),
          ],
        ));
  }

  Widget _unauthenticationBottomBar(AuthenticationState _state) {
    return Center(
      child: Text(
        'กรุณาลงชื่อเข้าใช้งาน',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'SukhumvitSet',
            fontSize: 21,
            color: Colors.black54.withOpacity(0.8),
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _authenticatedCard(BuildContext context, AuthenticationState _state) {
    return (_state as AuthenticatedState).account.personnel
        ? getActivePersonnel(context, _state)
        : getActiveNormal(context, _state);
  }

  Widget _unauthenticationCard(
      BuildContext context, AuthenticationState _state) {
    return getInActive(context, _state);
  }

  Widget _floatingCollapsed(AuthenticationState _state) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        margin: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
        padding: EdgeInsets.fromLTRB(0, 0, 0,
            Device.get().isIos ? (Device.get().isIphoneX ? 16 : 0) : 0),
        child: FlatButton(
          onPressed: () {
            _panelController.open();
          },
          child: _state is AuthenticatedState
              ? _authenticatedBottomBar(_state)
              : _unauthenticationBottomBar(_state),
        ));
  }

  Widget _floatingPanel(BuildContext context, AuthenticationState _state) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 16.0,
              color: Colors.grey.withAlpha(100),
            ),
          ]),
      margin: EdgeInsets.fromLTRB(16, 20, 16, Device.get().isIphoneX ? 40 : 16),
      child: Center(
        child: _state is AuthenticatedState
            ? _authenticatedCard(context, _state)
            : _unauthenticationCard(context, _state),
        //child: Text("This is the SlidingUpPanel when open"),
      ),
    );
  }

  @override
  void onError(String message) {
    print("onError");
  }

  @override
  void onSuccess(String message) {
    print("onSuccess");
  }

  Widget getActiveNormal(BuildContext context, AuthenticationState state) {
    var _state = state as AuthenticatedState;
    return Stack(
      children: <Widget>[
        Container(
            height: 65,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 20, top: 10),
                    alignment: Alignment.topRight,
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Center(
                      child: Image.asset(
                        'images/settings.png',
                        fit: BoxFit.contain,
                        height: 25,
                        width: 25,
                        color: Colors.white,
                      ),
                    )),
              ],
            )),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                child: Text(
                    _state.account.firstName + " " + _state.account.lastName,
                    style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        color: Colors.teal)),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: <Widget>[
                    Text(
                        _state.account.personnel
                            ? "ประเภท : บุคลากร"
                            : "ประเภท : ผู้ใช้งานทั่วไป",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black54)),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: <Widget>[
                    Text(
                        "ที่อยู่ : " +
                            "ต." +
                            _state.account.subDistrict +
                            " อ." +
                            _state.account.district +
                            " จ." +
                            _state.account.province,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black54)),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                        "อายุ : " +
                            calculatingDay(_state.account.birthDate).toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black54)),
                  ],
                ),
              ),

              //แก้ไขชื่อ-นามสกุล
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.black38,
                margin: EdgeInsets.only(top: 4, left: 25, right: 25),
                child: null,
              ),
              Container(
                alignment: Alignment.center,
                child: Container(
                  margin:
                      EdgeInsets.only(top: 16, left: 25, right: 25, bottom: 14),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text("แก้ไขโปรไฟล์",
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87)),
                  ),
                ),
              ),

              //แก้ไขที่อยู่

              Container(
                alignment: Alignment.center,
                child: Container(
                  margin:
                      EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text("แก้ไขที่อยู่",
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87)),
                  ),
                ),
              ),

              //อัปเกรดบัญชีผู้ใช้งาน

              Container(
                alignment: Alignment.center,
                child: Container(
                  margin:
                      EdgeInsets.only(top: 4, left: 25, right: 25, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text("อัปเกรดบัญชีผู้ใช้งาน",
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87)),
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.black38,
                margin: EdgeInsets.only(top: 10, left: 75, right: 75),
                child: null,
              ),

              Container(
                alignment: Alignment.center,
                child: Container(
                  margin:
                      EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: FlatButton(
                    splashColor: Colors.white54,
                    onPressed: () {
                      _authenticationBloc
                          .dispatch(UnAuthenticatingLoginEvent());
                      //confirmSignOut(context, widget);
                    },
                    child: Text("ลงชื่อออก",
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getActivePersonnel(BuildContext context, AuthenticationState state) {
    var _state = state as AuthenticatedState;
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
              height: 65,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 20, top: 10),
                      alignment: Alignment.topRight,
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Center(
                        child: Image.asset(
                          'images/settings.png',
                          fit: BoxFit.contain,
                          height: 25,
                          width: 25,
                          color: Colors.white,
                        ),
                      )),
                ],
              )),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: Text(
                      _state.account.firstName + " " + _state.account.lastName,
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          color: Colors.teal)),
                ),

                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: <Widget>[
                      Text("ประเภท : บุคลากร",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black54)),
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: <Widget>[
                      Text(
                          "ที่อยู่ : " +
                              "ต." +
                              _state.account.subDistrict +
                              " อ." +
                              _state.account.district +
                              " จ." +
                              _state.account.province,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black54)),
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: <Widget>[
                      Text(
                          "อายุ : " +
                              calculatingDay(_state.account.birthDate)
                                  .toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black54)),
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Text("หน่วยงานที่สังกัด : " + _state.account.department,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black54)),
                    ],
                  ),
                ),

                //แก้ไขชื่อ-นามสกุล
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Colors.black38,
                  margin: EdgeInsets.only(top: 4, left: 25, right: 25),
                  child: null,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 16, left: 25, right: 25, bottom: 14),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: FlatButton(
                      onPressed: () {},
                      child: Text("แก้ไขโปรไฟล์",
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87)),
                    ),
                  ),
                ),

                //ตั้งค่า

                Container(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 0, left: 25, right: 25, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            FrailtyRoute(
                                builder: (BuildContext context) =>
                                    SettingPage()));
                      },
                      child: Text("ตั้งค่า",
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87)),
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Colors.black38,
                  margin: EdgeInsets.only(top: 10, left: 75, right: 75),
                  child: null,
                ),

                Container(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 20, left: 25, right: 25, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: FlatButton(
                      splashColor: Colors.white54,
                      onPressed: () {
                        _authenticationBloc
                            .dispatch(UnAuthenticatingLoginEvent());
                      },
                      child: Text("ลงชื่อออก",
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getInActive(BuildContext context, AuthenticationState _state) {
    return //INACTIVE
        SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 0, left: 25, right: 25),
            child: Text("เลือกรูปแบบการเข้าใช้งาน",
                style: TextStyle(
                    fontFamily: 'SukhumvitSet',
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Colors.black87)),
          ),
          //ชื่อนามสกุล
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.black38,
            margin: EdgeInsets.only(top: 10, left: 25, right: 25),
            child: null,
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 20),
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: FlatButton(
                onPressed: () {},
                child: Text("ชื่อ-นามสกุล",
                    style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87)),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80,
                height: 1,
                color: Colors.black38,
                margin: EdgeInsets.only(top: 0, left: 0, right: 20),
                child: null,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text("หรือ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87))),
              Container(
                width: 80,
                height: 1,
                color: Colors.black38,
                margin: EdgeInsets.only(left: 20),
                child: null,
              ),
            ],
          ),

          //google
          Container(
            child: Container(
              margin: EdgeInsets.only(top: 25, left: 25, right: 25),
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10.0,
                    ),
                  ]),
              child: FlatButton(
                  onPressed: () {
                    //handleSignIn(widget, context);
                    _authenticationBloc.dispatch(GoogleLoginEvent());
                    //_authenticationBloc.dispatch(TestEvent(context));
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 6),
                        child: Image.asset(
                          'images/search-4.png',
                          fit: BoxFit.contain,
                          height: 30,
                          width: 30,
                        ),
                      ),
                      Center(
                        child: Text("กูเกิล",
                            style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87)),
                      )
                    ],
                  )),
            ),
          ),

          //Facebook
          Container(
            child: Container(
              margin: EdgeInsets.only(top: 25, left: 25, right: 25),
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF1465C3),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: FlatButton(
                  splashColor: Colors.white30,
                  onPressed: () {
                    
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 6),
                        child: Image.asset(
                          'images/facebook.png',
                          fit: BoxFit.contain,
                          height: 30,
                          width: 30,
                        ),
                      ),
                      Center(
                        child: Text("เฟสบุ๊ค",
                            style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white)),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  int calculatingDay(DateTime date) {
    final year1 = DateTime.now().year;
    final year2 = date.year;
    final difference = year1 - year2;
    if (date.month > DateTime.now().month) {
      return difference - 1;
    } else {
      return difference;
    }
  }
}
