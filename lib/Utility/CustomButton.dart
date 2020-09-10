import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({@required this.mensaje, @required this.onPressed});
  final GestureTapCallback onPressed;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    var nodo = <Widget>[
      Icon(
        Icons.face,
        color: Colors.amber,
      ),
      SizedBox(
        width: 10.0,
      ),
      new Text(
        mensaje,
        maxLines: 1,
        style: TextStyle(color: Colors.white),
      )
    ];
    return RawMaterialButton(
      fillColor: Colors.green,
      splashColor: Colors.greenAccent,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: nodo,
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}

class CustomButtonAction extends StatelessWidget {
  CustomButtonAction({@required this.label, @required this.onPressed});
  final GestureTapCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: new EdgeInsets.all(12.0),
        child: new RaisedButton(
          color: Colors.cyan.shade600,
          onPressed: onPressed,
          child: new Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
