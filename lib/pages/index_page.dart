import 'package:flutter/material.dart';
import 'package:kenito_v2/services/authentication.dart';
import 'package:kenito_v2/tools/utilitis.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key, this.auth, this.userId, this.logoutCallback, this.title})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String title;

  @override
  State<StatefulWidget> createState() => new _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: new Text("KENITO"),
      ),
      drawer: MenuLateral(),
    );
  }
}
