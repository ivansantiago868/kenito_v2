import 'package:flutter/material.dart';
import 'package:kenito/pages/admin/loader_page.dart';
import 'package:kenito/pages/admin/speech_page.dart';
import 'package:kenito/pages/admin/bot_page.dart';
import 'package:kenito/pages/admin/bd_page.dart';
import 'package:kenito/pages/admin/speech_page_flutter.dart';
import 'package:kenito/pages/admin/text_speech_page.dart';
import 'package:kenito/pages/admin/permission_page.dart';
import 'package:kenito/main.dart';

class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text("KENITO EL BOT"),
            accountEmail: Text("ivalle@unbosque.edu.co"),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://sentisis.com/wp-content/uploads/post-chatbot-conversacional-1.png"),
                    fit: BoxFit.cover)),
          ),
          new ListTile(
            title: Text("INICIO"),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new MyApp()));
            },
          ),
          new ListTile(
            title: Text("DEMO BOT"),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new BotPage()));
            },
          ),
          new ListTile(
            title: Text("DEMO SPEECH TO TEXT"),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SpeechPage()));
            },
          ),
          new ListTile(
            title: Text("DEMO SPEECH TO TEXT V2"),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SpeechPageFlutter()));
            },
          ),
          new ListTile(
            title: Text("DEMO TEXT TO SPEECH"),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new TextPage()));
            },
          ),
          new ListTile(
            title: Text("DEMO BASE DE DATOS"),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new BdPage()));
            },
          ),
          new ListTile(
            title: Text("DEMO PERMISOS"),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new PermissionPage()));
            },
          ),
          new ListTile(
            title: Text("Loader"),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new LoaderPage()));
            },
          ),
        ],
      ),
    );
  }
}
