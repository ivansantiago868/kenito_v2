import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kenito/pages/home_page.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:kenito/Utility/CustomButton.dart';
import 'package:kenito/Utility/CustomMenu.dart';

import 'package:kenito/pages/chat_page.dart';
import 'package:kenito/controller/arbol.dart';

class LoadPage extends StatefulWidget {
  @override
  _LoadPageState createState() => new _LoadPageState();
}

//******************************************************************* */
//****Controlador para carga de pantalla de incio *** */
//******************************************************************* */
class _LoadPageState extends State<LoadPage> {
  double _progress = 0;
  @override
  void initState() {
    ArbolConfig data = new ArbolConfig();
    //el modulo solo se carga como visual cuando traiga el config y se redirecciona cuando termine de descargar el Config.json  //
    data.loadConfig().then((estatus) => {
          if (estatus)
            {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new HomePage(serialStatus: data)))
            }
          else
            {print("no carga de datos")}
        });
  }

  void startTimer() {
    new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_progress == 1) {
            timer.cancel();
          } else {
            _progress += 0.2;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // La aplicación esta en ejecución
    return new SplashScreen(
        seconds: 10000,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text(
          'KENITO',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
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
  void initState() {}

  @override
  Widget build(BuildContext context) {
    // startTimer();
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
              ],
            ),
          ),
        ));
  }
}
