import 'package:flutter/material.dart';
import 'package:kenito_v2/services/authentication.dart';
import 'package:kenito_v2/pages/root_page.dart';
import 'package:kenito_v2/pages/bd_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // _signInAnonymously();
    return new MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: true,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: new BdPage());
        home: new RootPage(auth: new Auth()));
  }

  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }
}
