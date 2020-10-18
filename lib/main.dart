import 'package:flutter/material.dart';
import 'package:kenito/pages/load_page.dart';
import 'package:permission/permission.dart';
import 'Dart:io';
import 'package:kenito/pages/home_page.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kenito/controller/arbol.dart';
import 'package:random_string/random_string.dart';
import 'package:serial_number/serial_number.dart';
import 'AppSettings.config.dart';
import 'DevSettings.config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kenito/models/Equipos.dart';
import 'package:kenito/controller/bd.dart';

void main() {
  GlobalConfiguration().loadFromMap(appSettings).loadFromMap(devSettings);

  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool inte = false;

  @override
  void initState() {
    super.initState();
    GlobalConfiguration cfg = new GlobalConfiguration();
    cfg.getValue("serial");
    bool status = false;
    _signInAnonymously();
    try {
      bool permisos = false;
      bool internet = false;
      bool config = false;
      bool serial = false;
      _getSerial().then((serial) => {
            _getPermissionsStatus().then((permisos) => {
                  _getInternetStatus().then((internet) => {
                        _getConfigStatus().then((config) => {
                              if (permisos && internet && config)
                                {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => new LoadPage()))
                                }
                              else
                                {
                                  if (!permisos)
                                    {mensajeError("Sin permisos a microfono")}
                                  else if (!internet)
                                    {mensajeError("Sin permisos a internet")}
                                  else
                                    {
                                      mensajeError(
                                          "Sin permisos a archivo config")
                                    }
                                }
                            })
                      })
                })
          });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: new Center(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        ));
  }

  mensajeError(mensaje) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text(mensaje),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  Future<bool> _getPermissionsStatus() async {
    print("Ingresa _getPermissionsStatus");
    bool status = true;
    List<PermissionName> permissionNames = [];
    String os = Platform.operatingSystem;
    if (Platform.isMacOS) {
      if (true) permissionNames.add(PermissionName.Internet);
      if (true) permissionNames.add(PermissionName.Microphone);
    } else {
      if (true) permissionNames.add(PermissionName.Microphone);
    }
    List<Permissions> permissions =
        await Permission.getPermissionsStatus(permissionNames);
    permissions.forEach((permission) {
      debugPrint(
          '${permission.permissionName}: ${permission.permissionStatus}\n');
    });
    permissions = await Permission.requestPermissions(permissionNames);
    permissions.forEach((permission) {
      if (permission.permissionStatus != PermissionStatus.allow) {
        status = false;
        debugPrint(
            '${permission.permissionName}: ${permission.permissionStatus}\n');
      }
    });
    print("Carga de Permisos");
    print("Termina _getPermissionsStatus");
    return status;
  }

  Future<bool> _getInternetStatus() async {
    print("Ingresa _getInternetStatus");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        print("Termina _getInternetStatus");
        return true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      return false;
    }
  }

  Future<bool> _getConfigStatus() async {
    print('comienza _getConfigStatus');
    ArbolConfig data = ArbolConfig();
    await data.saveConfig().then((ret) => ret);
    print('termina _getConfigStatus');
    return true;
  }

  Future<bool> _getSerial() async {
    print('comienza _getSerial');
    GlobalConfiguration cfg = new GlobalConfiguration();
    String sn = await SerialNumber.serialNumber;
    Equipos equipo = new Equipos(sn.toString(), true);
    var bd = BD.add(equipo);
    debugPrint(sn);
    cfg.setValue("serial", sn);
    var chat_id = randomAlphaNumeric(15);
    debugPrint(chat_id);
    cfg.setValue("chat_id", chat_id);
    print('termina _getSerial');
    return true;
  }
}
