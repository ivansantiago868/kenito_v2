import 'Dart:io';

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:kenito/Utility/CustomButton.dart';
import 'package:kenito/Utility/CustomMenu.dart';

import 'package:kenito/pages/chat_page.dart';
import 'package:kenito/controller/arbol.dart';

class HomePage extends StatefulWidget {
  final ArbolConfig serialStatus;

  HomePage({Key key, @required this.serialStatus}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState(this.serialStatus);
}

class _HomePageState extends State<HomePage> {
  ArbolConfig serialStatus;

  _HomePageState(this.serialStatus);

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.blue,
        drawer: MenuLateral(),
        body: new Center(
          child: Container(
            color: Colors.transparent,
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Container(
                    width: MediaQuery.of(context).copyWith().size.width,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/pngocean.com.png"),
                          fit: BoxFit.cover),
                    )),
                new Container(
                  child: serialStatus.load
                      ? CustomButton(
                          onPressed: () {
                            var push = Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new ChatPage(
                                        serialStatus: serialStatus)));
                          },
                          mensaje: "Comencemos Chat")
                      : CustomButton(onPressed: null, mensaje: "Esperar Carga"),
                )
              ],
            ),
          ),
        ));
  }
}
