import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({Key key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {

    var brightness = DynamicTheme.of(context).brightness;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // Don't show the leading button
        title: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 60,
                      height: 56,
                      child: LayoutBuilder(builder: (context, constraint) {
                        return FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.transparent,
                            child: Icon(
                              Icons.close,
                              size: constraint.biggest.height - 26,
                              //color: Colors.black.withAlpha(150),
                              color: Theme.of(context).iconTheme.color,
                            ));
                      }),
                    )),
              ],
            ),
            SizedBox(
              height: 56,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "QR Code Scanner",
                      style: Theme.of(context).appBarTheme.textTheme.subtitle1,
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

        brightness: brightness,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
      ),
    );
  }
}