import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kenito_v2/services/authentication.dart';
import 'package:kenito_v2/pages/index_page.dart';
import 'package:flutter/scheduler.dart';
import 'package:kenito_v2/tools/utilitis.dart';
import 'dart:async';

import 'package:kenito_v2/pages/speech_page.dart';
import 'package:kenito_v2/pages/bot_page.dart';
import 'package:kenito_v2/pages/bd_page.dart';
import 'package:kenito_v2/pages/text_speech_page.dart';
import 'package:kenito_v2/pages/permission_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        title: new Text('Home'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Salir',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut)
        ],
      ),
      drawer: MenuLateral(),
      body: MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  MyStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () => Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new IndexPage())),
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text('Iniciar', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
