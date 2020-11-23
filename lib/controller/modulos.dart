import 'dart:math';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:kenito/controller/arbol.dart';
import 'package:kenito/controller/bd.dart';
import 'package:kenito/models/Config.dart';
import 'package:kenito/models/Respuestas.dart';

//******************************************************************* */
//****Clase que controla el flujo de la converzacion sea por DialogFlow o Por el modulo nativo *** */
//******************************************************************* */
class ModuloController {
  Pregunta mensaje_ini;
  ArbolConfig mensaje_bk;
  String error;
  int conteo = 0;
  GlobalConfiguration config;
  int contador = 0;

  // constructor
  ModuloController({ArbolConfig config, String modulo}) {
    GlobalConfiguration cfg = new GlobalConfiguration();
    this.config = cfg;
    mensaje_bk = config;
    asignacionModuloInicial(modulo);
  }
  void asignacionModuloInicial(String modulo) {
    switch (modulo) {
      case "@Educacion":
        this.mensaje_ini = mensaje_bk.page.educacion;
        break;
      case "@Dolor":
        this.mensaje_ini = mensaje_bk.page.dolor;
        break;
      case "@Charla":
        var pre = new Pregunta(
            key: 0,
            type: "dialogflow",
            pregunta: "preguntame lo que quieras",
            respuesta: "",
            image: "",
            izq: new Pregunta(),
            der: new Pregunta());
        this.mensaje_ini = pre;
        break;
      default:
    }
  }

  void GetResponseBool(String mesaje) {
    Random random = new Random();
    var serial = this.config.getValue("serial");
    if (this
            .mensaje_ini
            .binario
            .der
            .toLowerCase()
            .indexOf(mesaje.toLowerCase()) >=
        0) {
      var rest = new RespuestasModel(
          serial,
          true,
          this.mensaje_bk.page.nombre,
          this.mensaje_ini.pregunta,
          jsonEncode(this.mensaje_ini.toJsonDB()),
          mesaje,
          contador,
          jsonEncode(this.mensaje_ini.binario.toJson()));
      var bd = BD.add(rest);
      switch (this.mensaje_ini.der.type) {
        case "pregunta":
          int keyBuscar = int.parse(this.mensaje_ini.der.respuesta);
          for (var i = 0; i < this.mensaje_bk.page.preguntas.length; i++) {
            if (this.mensaje_bk.page.preguntas[i].key == keyBuscar) {
              if (this.mensaje_bk.page.preguntas[i].type == "ruta") {
                var tipo = "bool";
                if (this.mensaje_bk.page.preguntas[i].image != "") {
                  tipo = "image";
                }
                Pregunta pre = Pregunta(
                    key: this.mensaje_bk.page.preguntas[i].key,
                    type: tipo,
                    pregunta: this.mensaje_bk.page.preguntas[i].pregunta,
                    respuesta: "",
                    image: this.mensaje_bk.page.preguntas[i].image,
                    izq: Pregunta(
                        type: "pregunta",
                        respuesta: this
                            .mensaje_bk
                            .page
                            .preguntas[i]
                            .respuesta
                            .izq
                            .toString()),
                    der: Pregunta(
                        type: "pregunta",
                        respuesta: this
                            .mensaje_bk
                            .page
                            .preguntas[i]
                            .respuesta
                            .der
                            .toString()),
                    binario: this.mensaje_bk.page.preguntas[i].binario);
                this.mensaje_ini = pre;
              }
              if (this.mensaje_bk.page.preguntas[i].type == "enrutador") {
                Pregunta pre = Pregunta(
                    key: this.mensaje_bk.page.preguntas[i].key,
                    type: "respuesta",
                    pregunta: "Perfecto " + this.mensaje_bk.page.nombre,
                    respuesta: this.mensaje_bk.page.preguntas[i].pregunta,
                    image: this.mensaje_bk.page.preguntas[i].image,
                    izq: Pregunta(
                        type: "respuesta",
                        respuesta: this
                            .mensaje_bk
                            .page
                            .preguntas[i]
                            .respuesta
                            .izq
                            .toString()),
                    der: Pregunta(
                        type: "respuesta",
                        respuesta: this
                            .mensaje_bk
                            .page
                            .preguntas[i]
                            .respuesta
                            .der
                            .toString()),
                    binario: this.mensaje_bk.page.preguntas[i].binario);
                this.mensaje_ini = pre;
              }
              break;
            }
          }
          break;
        case "boolmulti":
          var splitPregunta = this.mensaje_ini.der.pregunta.split(",");
          int randomNumber =
              random.nextInt(this.mensaje_ini.der.pregunta.split(",").length);
          this.mensaje_ini.der.pregunta = splitPregunta[randomNumber];
          this.mensaje_ini = this.mensaje_ini.der;
          break;
        case "bool":
          this.mensaje_ini = this.mensaje_ini.der;
          break;
        case "respuesta":
          switch (this.mensaje_ini.der.respuesta) {
            case "@Gracias":
              this.mensaje_ini.der.pregunta = mensaje_bk.page.gracias;
              this.mensaje_ini = this.mensaje_ini.der;
              break;
            case "@Dolor":
              this.mensaje_ini = mensaje_bk.page.dolor;
              break;
            case "@Educacion":
              this.mensaje_ini = mensaje_bk.page.educacion;
              break;
            case "@Charla":
              var pre = new Pregunta(
                  key: 0,
                  type: "dialogflow",
                  pregunta: "hola soy kenito",
                  respuesta: "",
                  image: "",
                  izq: new Pregunta(),
                  der: new Pregunta());
              this.mensaje_ini = pre;
              break;
          }

          break;
        default:
          this.mensaje_ini = this.mensaje_ini.der;
      }
      this.error = "";
    } else if (this
            .mensaje_ini
            .binario
            .izq
            .toLowerCase()
            .indexOf(mesaje.toLowerCase()) >=
        0) {
      var rest = new RespuestasModel(
          serial,
          true,
          this.mensaje_bk.page.nombre,
          this.mensaje_ini.pregunta,
          jsonEncode(this.mensaje_ini.toJsonDB()),
          mesaje,
          contador,
          jsonEncode(this.mensaje_ini.binario.toJson()));
      var bd = BD.add(rest);
      switch (this.mensaje_ini.izq.type) {
        case "pregunta":
          int keyBuscar = int.parse(this.mensaje_ini.izq.respuesta);
          for (var i = 0; i < this.mensaje_bk.page.preguntas.length; i++) {
            if (this.mensaje_bk.page.preguntas[i].key == keyBuscar) {
              if (this.mensaje_bk.page.preguntas[i].type == "ruta") {
                var tipo = "bool";
                if (this.mensaje_bk.page.preguntas[i].image != "") {
                  tipo = "image";
                }
                Pregunta pre = Pregunta(
                    key: this.mensaje_bk.page.preguntas[i].key,
                    type: tipo,
                    pregunta: this.mensaje_bk.page.preguntas[i].pregunta,
                    respuesta: "",
                    image: this.mensaje_bk.page.preguntas[i].image,
                    izq: Pregunta(
                        type: "pregunta",
                        respuesta: this
                            .mensaje_bk
                            .page
                            .preguntas[i]
                            .respuesta
                            .izq
                            .toString()),
                    der: Pregunta(
                        type: "pregunta",
                        respuesta: this
                            .mensaje_bk
                            .page
                            .preguntas[i]
                            .respuesta
                            .der
                            .toString()),
                    binario: this.mensaje_bk.page.preguntas[i].binario);
                this.mensaje_ini = pre;
              }
              if (this.mensaje_bk.page.preguntas[i].type == "enrutador") {
                Pregunta pre = Pregunta(
                    key: this.mensaje_bk.page.preguntas[i].key,
                    type: "respuesta",
                    pregunta: "Perfecto " + this.mensaje_bk.page.nombre,
                    respuesta: this.mensaje_bk.page.preguntas[i].pregunta,
                    image: "",
                    izq: Pregunta(
                        type: "respuesta",
                        respuesta: this
                            .mensaje_bk
                            .page
                            .preguntas[i]
                            .respuesta
                            .izq
                            .toString()),
                    der: Pregunta(
                        type: "respuesta",
                        respuesta: this
                            .mensaje_bk
                            .page
                            .preguntas[i]
                            .respuesta
                            .der
                            .toString()),
                    binario: this.mensaje_bk.page.preguntas[i].binario);
                this.mensaje_ini = pre;
              }
              break;
            }
          }
          break;
        case "boolmulti":
          var splitPregunta = this.mensaje_ini.izq.pregunta.split(",");
          int randomNumber =
              random.nextInt(this.mensaje_ini.izq.pregunta.split(",").length);
          this.mensaje_ini.izq.pregunta = splitPregunta[randomNumber];
          this.mensaje_ini = this.mensaje_ini.izq;
          break;
        case "bool":
          this.mensaje_ini = this.mensaje_ini.izq;
          break;
        case "respuesta":
          switch (this.mensaje_ini.izq.respuesta) {
            case "@Gracias":
              this.mensaje_ini.izq.pregunta = mensaje_bk.page.gracias;
              this.mensaje_ini = this.mensaje_ini.izq;
              break;
            case "@Dolor":
              this.mensaje_ini = mensaje_bk.page.dolor;
              break;
            case "@Educacion":
              this.mensaje_ini = mensaje_bk.page.educacion;
              break;
            case "@Charla":
              var pre = new Pregunta(
                  key: 0,
                  type: "dialogflow",
                  pregunta: "hola soy kenito",
                  respuesta: "",
                  image: "",
                  izq: new Pregunta(),
                  der: new Pregunta());
              this.mensaje_ini = pre;
              break;
          }

          break;
        default:
          this.mensaje_ini = this.mensaje_ini.izq;
      }
      this.error = "";
    } else {
      this.mensaje_ini = this.mensaje_ini;
      this.error = mensaje_bk.page.exepcion;

      var rest = new RespuestasModel(
          serial,
          false,
          this.mensaje_bk.page.nombre,
          this.mensaje_ini.pregunta,
          jsonEncode(this.mensaje_ini.toJsonDB()),
          mesaje,
          contador,
          jsonEncode(this.mensaje_ini.binario.toJson()));
      rest.tabla = "RespuestasFalla";
      var bd = BD.add(rest);
    }
    contador += 1;
  }
}
