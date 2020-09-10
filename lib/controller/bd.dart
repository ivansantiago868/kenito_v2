import 'package:firebase_database/firebase_database.dart';

class BD {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // constructor
  BD() {}

  BD.add(objeto) {
    _database.reference().child(objeto.tabla).push().set(objeto.toJson());
  }
}
