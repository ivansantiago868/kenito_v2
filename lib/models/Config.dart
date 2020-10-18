import 'dart:developer';

import 'dart:ffi';

class Config {
  double version;
  String gracias;
  String exepcion;
  String nombre;
  String bienvenida;
  bool pedir_nombre;
  List<Orden> orden;
  Pregunta educacion;
  Pregunta dolor;
  Binario binario;
  List<Ruta> preguntas;

  Config(
      {this.version,
      this.exepcion,
      this.nombre,
      this.pedir_nombre,
      this.bienvenida,
      this.gracias,
      this.orden,
      this.educacion,
      this.dolor,
      this.binario,
      this.preguntas});

  factory Config.fromJson(Map<String, dynamic> parsedJson) {
    try {
      var list = parsedJson['orden'] as List;
      List<Orden> data = list.map((i) => Orden.fromJson(i)).toList();

      var listPreguntas = parsedJson['@listaPreguntas'] as List;
      List<Ruta> dataPreguntas =
          listPreguntas.map((i) => Ruta.fromJson(i)).toList();

      return Config(
          version: parsedJson['version'],
          gracias: parsedJson['gracias'],
          nombre: parsedJson['nombre'],
          pedir_nombre: parsedJson['pedir_nombre'],
          bienvenida: parsedJson['bienvenida'],
          exepcion: parsedJson['exepcion'],
          orden: data,
          educacion: Pregunta.fromJson(parsedJson['@Educacion']),
          dolor: Pregunta.fromJson(parsedJson['@Dolor']),
          binario: Binario.fromJson(parsedJson['@binario']),
          preguntas: dataPreguntas);
    } catch (e) {
      print(parsedJson.toString());
    }
  }
}

class Binario {
  String izq;
  String der;
  Binario({this.izq, this.der});
  factory Binario.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return Binario(izq: parsedJson['negativo'], der: parsedJson['positivo']);
    } catch (e) {
      print(parsedJson.toString());
    }
  }
}

class Respuestas {
  int izq;
  int der;
  Respuestas({this.izq, this.der});
  factory Respuestas.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return Respuestas(
          izq: parsedJson['negativo'], der: parsedJson['positivo']);
    } catch (e) {
      print(parsedJson.toString());
    }
  }
}

class Orden {
  String modulo;

  Orden({this.modulo});

  factory Orden.fromJson(Map<String, dynamic> parsedJson) {
    try {
      return Orden(modulo: parsedJson['name']);
    } catch (e) {
      print(parsedJson.toString());
    }
  }
}

class Ruta {
  String type;
  int key;
  String pregunta;
  Respuestas respuesta;
  String image;
  Binario binario;

  Ruta(
      {this.type,
      this.key,
      this.pregunta,
      this.respuesta,
      this.image,
      this.binario});

  factory Ruta.fromJson(Map<String, dynamic> parsedJson) {
    try {
      Binario bin = Binario();
      if (parsedJson['@binario'] != "" && parsedJson.length > 0) {
        bin = Binario.fromJson(parsedJson['@binario']);
      } else {
        print(parsedJson['@binario'].toString());
      }
      Respuestas respuesta = Respuestas();
      respuesta = Respuestas.fromJson(parsedJson['respuesta']);
      return Ruta(
          type: parsedJson['type'],
          key: parsedJson['key'],
          pregunta: parsedJson['pregunta'],
          respuesta: respuesta,
          image: parsedJson['image'],
          binario: bin);
    } catch (e) {
      print(parsedJson.toString());
    }
  }
}

class Pregunta {
  int key;
  String type;
  String pregunta;
  String respuesta;
  String image;
  Pregunta izq;
  Pregunta der;
  Binario binario;

  Pregunta(
      {this.key,
      this.type,
      this.pregunta,
      this.respuesta,
      this.image,
      this.izq,
      this.der,
      this.binario});

  factory Pregunta.fromJson(Map<String, dynamic> parsedJson) {
    try {
      Pregunta izq = Pregunta();
      if (parsedJson['izq'] != "" &&
          parsedJson.length > 0 &&
          parsedJson['izq'] != null) {
        izq = Pregunta.fromJson(parsedJson['izq']);
      } else {
        print(parsedJson['izq'].toString());
      }
      Pregunta der = Pregunta();
      if (parsedJson['der'] != "" &&
          parsedJson.length > 0 &&
          parsedJson['der'] != null) {
        der = Pregunta.fromJson(parsedJson['der']);
      } else {
        print(parsedJson['der'].toString());
      }
      Binario bin = Binario();
      if (parsedJson['@binario'] != "" && parsedJson.length > 0) {
        bin = Binario.fromJson(parsedJson['@binario']);
      } else {
        print(parsedJson['@binario'].toString());
      }
      var key_id = 0;
      if (parsedJson['key'] != "") {
        key_id = parsedJson['key'];
      }
      return Pregunta(
        key: key_id,
        type: parsedJson['type'],
        pregunta: parsedJson['pregunta'],
        respuesta: parsedJson['respuesta'],
        image: parsedJson['image'],
        binario: bin,
        izq: izq,
        der: der,
      );
    } catch (e) {
      print(parsedJson.toString());
    }
  }
}

class Idioma {
  final String name;
  final String code;

  const Idioma(this.name, this.code);
}
