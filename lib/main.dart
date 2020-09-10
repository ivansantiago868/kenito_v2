import 'package:flutter/material.dart';
import 'package:permission/permission.dart';
import 'Dart:io';
import 'package:kenito/pages/home_page.dart';
import 'package:global_configuration/global_configuration.dart';
import 'AppSettings.config.dart';
import 'DevSettings.config.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      _getPermissionsStatus().then((status) {
        print(status);
        this.inte = status;
        if (inte) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new HomePage()));
          debugPrint("validacion ok");
        } else {
          Widget okButton = FlatButton(
            child: Text("OK"),
            onPressed: () {},
          );
          AlertDialog alert = AlertDialog(
            title: Text("Alerta"),
            content:
                Text("NO tiene permisos sobre microfono o no tiene internet."),
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
          debugPrint("validacion Sin internet");
        }
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

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  Future<bool> _getPermissionsStatus() async {
    bool status = false;
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
    bool tem = true;
    permissions.forEach((permission) {
      if (permission.permissionStatus != PermissionStatus.allow) {
        tem = false;
      }
      debugPrint(
          '${permission.permissionName}: ${permission.permissionStatus}\n');
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        status = true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      status = false;
    }
    return status;
  }
}
