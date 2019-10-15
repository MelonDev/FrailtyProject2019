part of '../question_page.dart';

Widget mainPageAppbar(MyQuestionnaireState _state, BuildContext context) {
  ThemeData _themeData = Theme.of(context);

  return PreferredSize(
    preferredSize: Size.fromHeight(60.0),
    child: AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      titleSpacing: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      // Don't show the leading button
      title: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 62, 0),
              color: Colors.transparent,
              height: double.infinity,
              width: 62,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    minWidth: 0,
                    height: double.infinity,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.low_priority,
                            //color: Colors.black.withAlpha(180),
                            color: _themeData.primaryTextTheme.title.color,
                            size: 30,
                          ),
                        ],
                      ),
                      width: 30,
                      margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.black.withAlpha(0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: Colors.transparent,
              height: double.infinity,
              width: 62,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    minWidth: 0,
                    height: double.infinity,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.close,
                            //color: Colors.black.withAlpha(180),
                            color: _themeData.primaryTextTheme.title.color,
                            size: 30,
                          ),
                        ],
                      ),
                      width: 30,
                      margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.black.withAlpha(0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: 280,
                    height: 100,
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          child: Row(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 0),
                                          margin:
                                              EdgeInsets.fromLTRB(16, 0, 20, 0),
                                          child: _state.questionCounter != null
                                              ? (_state.questionCounter > 0
                                                  ? Text(
                                                      "ข้อที่ ${_state.questionCounter}",
                                                      textAlign: TextAlign.left,
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
                                                              FontWeight.bold),
                                                    )
                                                  : Container())
                                              : Container())),
                                ],
                              ),
                            ],
                          ));
                    }),
                  )),
            ],
          ),
          SizedBox(
            height: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "",
                    style: TextStyle(
                        color: Colors.black.withAlpha(200),
                        fontFamily: 'SukhumvitSet',
                        //fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[Container()],
          )
        ],
      ),

      brightness: _themeData.brightness,
      backgroundColor: _themeData.primaryColor,
      elevation: 0,
    ),
  );
}
