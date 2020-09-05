import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:kenito_v2/pages/speech_page.dart';
import 'package:kenito_v2/pages/bot_page.dart';
import 'package:kenito_v2/pages/bd_page.dart';
import 'package:kenito_v2/pages/text_speech_page.dart';
import 'package:kenito_v2/pages/permission_page.dart';
import 'package:kenito_v2/pages/index_page.dart';
import 'package:kenito_v2/pages/home_page.dart';

class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text("KENITO EL BOT"),
            accountEmail: Text("@unbosque.edu.co"),
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
                  new MaterialPageRoute(builder: (context) => new HomePage()));
            },
          ),
          Ink(
            color: Colors.indigo,
            child: new ListTile(
              title: Text(
                "KENITO",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new IndexPage()));
              },
            ),
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
          )
        ],
      ),
    );
  }
}
