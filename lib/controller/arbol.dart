import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:kenito/models/Config.dart';
import 'dart:async' show Future;
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class ArbolConfig {
  Config page;
  bool load = false;
  String jsonPage;

  ArbolConfig() {
    print('ArbolConfig create');
  }
  Future saveConfig() async {
    print('comienza saveConfig');
    var strinConfig = await _loadConfigUrl();
    await writeConfig(strinConfig)
        .then((respuetaArchivo) => print('ArbolConfig Escritira'));
    print('termina saveConfig');
  }

  Future loadConfig() async {
    try {
      var jsonPage = await readConfig().then(
          (jsonPage) => {serializarString(jsonPage).then((value) => value)});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> serializarString(jsonPage) async {
    try {
      this.jsonPage = jsonPage;
      final jsonResponse = json.decode(jsonPage);
      Config page = new Config.fromJson(jsonResponse);
      this.page = page;
      this.load = true;
      print('ArbolConfig Lectura');
      return true;
    } catch (e) {
      print(e.toString());
    }
  }
}

Future<String> _loadConfigAsset() async {
  return await rootBundle.loadString('assets/Config.json');
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/Config.json');
}

Future<File> writeConfig(String texto) async {
  print('comienza writeConfig');
  final file = await _localFile;
  print('termina writeConfig');
  return file.writeAsString('$texto');
}

Future<String> readConfig() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    return null;
  }
}

Future<String> _loadConfigUrl() async {
  print('comienza _loadConfigUrl');
  final response = await http.get('http://104.248.54.131/Config.json',
      headers: {"charset": "utf-8", "Accept-Charset": "utf-8"});

  if (response.statusCode == 200) {
    print('_loadConfigUrl 200');
    print('termina _loadConfigUrl');
    return Utf8Decoder().convert(response.bodyBytes);
  } else {
    print('_loadConfigUrl Failed to load album');
    print('termina _loadConfigUrl');
    throw Exception('Failed to load album');
  }
}
