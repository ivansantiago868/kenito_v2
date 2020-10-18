import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kenito/Utility/CustomMenu.dart';

class LoaderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  double _progress = 0;

  void startTimer() {
    new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_progress == 10) {
            timer.cancel();
          } else {
            _progress += 0.01;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    return Scaffold(
      appBar: AppBar(
        title: Text('Woolha.com Flutter Tutorial'),
      ),
      drawer: MenuLateral(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                strokeWidth: 10,
                backgroundColor: Colors.cyanAccent,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                value: _progress,
              ),
              RaisedButton(
                child: Text('Start timer'),
                onPressed: () {
                  setState(() {
                    _progress = 0;
                  });

                  startTimer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
