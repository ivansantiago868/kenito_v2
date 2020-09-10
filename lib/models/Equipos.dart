import 'package:firebase_database/firebase_database.dart';

class Equipos {
  String tabla = "Equipos";
  String key;
  bool completed;
  String serialId;

  Equipos(this.serialId, this.completed);

  Equipos.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        serialId = snapshot.value["serialId"],
        completed = snapshot.value["completed"];

  toJson() {
    return {
      "serialId": serialId,
      "completed": completed,
    };
  }
}
