import 'package:firebase_database/firebase_database.dart';
import 'package:kenito/models/Config.dart';

class RespuestasModel {
  String tabla = "Respuestas";
  String key;
  bool coincidencia;
  String nombre;
  String pregunta;
  String serialId;
  String objeto;
  String respuesta;
  String binario;
  int contador;

  RespuestasModel(this.serialId, this.coincidencia, this.nombre, this.pregunta,
      this.objeto, this.respuesta, this.contador, this.binario);

  RespuestasModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        serialId = snapshot.value["serialId"],
        coincidencia = snapshot.value["coincidencia"],
        nombre = snapshot.value["nombre"],
        pregunta = snapshot.value["pregunta"],
        objeto = snapshot.value["objeto"],
        respuesta = snapshot.value["respuesta"],
        contador = snapshot.value["contador"],
        binario = snapshot.value["contador"];

  toJson() {
    return {
      "serialId": serialId,
      "coincidencia": coincidencia,
      "nombre": nombre,
      "pregunta": pregunta,
      "objeto": objeto,
      "respuesta": respuesta,
      "contador": contador,
      "binario": binario
    };
  }
}
