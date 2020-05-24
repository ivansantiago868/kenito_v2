import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kenito_v2/services/authentication.dart';
import 'package:kenito_v2/pages/speech_page.dart';
import 'package:kenito_v2/pages/bot_page.dart';
import 'package:kenito_v2/pages/bd_page.dart';
import 'package:kenito_v2/pages/text_speech_page.dart';
import 'package:kenito_v2/pages/permission_page.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

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

  void redirect(type) {
    print("redirect:");
    switch (type) {
      case 'SpeechPage':
        print("SpeechPage");
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new SpeechPage()));
        break;
      case 'Permisos':
        print("Permisos");
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new PermissionPage()));
        break;
      case 'TextPage':
        print("TextPage");
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new TextPage()));
        break;
      case 'bot':
        print("Bot");
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new BotPage()));
        break;
      case 'bd':
        print("BD");
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => new BdPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Salir',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut)
        ],
      ),
      body: MyStatelessWidget(),
      // Center(child: new Text('Bienvenio',style: new TextStyle(fontSize: 17.0, color: Colors.red)),),
      persistentFooterButtons: <Widget>[
        IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () => redirect('SpeechPage')),
        IconButton(
            icon: Icon(Icons.access_alarm),
            onPressed: () => redirect('Permisos')),
        IconButton(
            icon: Icon(Icons.account_box),
            onPressed: () => redirect('TextPage')),
        IconButton(icon: Icon(Icons.book), onPressed: () => redirect('bot')),
        IconButton(icon: Icon(Icons.autorenew), onPressed: () => redirect('bd'))
      ],
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
          // const RaisedButton(
          //   onPressed: null,
          //   child: Text('Disabled Button', style: TextStyle(fontSize: 20)),
          // ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () => Navigator.push(
            context, new MaterialPageRoute(builder: (context) => new BdPage())),
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
              child: const Text('Comencemos', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
