import 'Dart:io';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:kenito/Utility/CustomButton.dart';
import 'package:kenito/Utility/CustomMenu.dart';
import "package:serial_number/serial_number.dart";
import 'package:global_configuration/global_configuration.dart';
import 'package:kenito/pages/chat_page.dart';
import 'package:kenito/controller/bd.dart';
import 'package:kenito/models/Equipos.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    // La aplicación esta en ejecución
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text(
          'KENITO ',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        //image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        image: new Image(image: AssetImage('assets/pngocean.com.png')),
        backgroundColor: Colors.blueAccent,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Esperemos un momento"),
        loaderColor: Colors.red);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool condition = true;
    var serialStatus = getSerial();
    return new Scaffold(
        backgroundColor: Colors.blue,
        drawer: MenuLateral(),
        body: new Center(
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).copyWith().size.width,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/pngocean.com.png"),
                          fit: BoxFit.cover),
                    )),
                Container(
                  child: CustomButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ChatPage()));
                      },
                      mensaje: "Comencemos"),
                )
              ],
            ),
          ),
        ));
  }

  getSerial() async {
    GlobalConfiguration cfg = new GlobalConfiguration();
    String sn = await SerialNumber.serialNumber;
    Equipos equipo = new Equipos(sn.toString(), true);
    var bd = BD.add(equipo);
    debugPrint(sn);
    cfg.setValue("serial", sn);
    var chat_id = randomAlphaNumeric(15);
    debugPrint(chat_id);
    cfg.setValue("chat_id", chat_id);
    return true;
  }
}
