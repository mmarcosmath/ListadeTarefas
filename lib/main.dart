import 'package:flutter/material.dart';
import 'package:listatarefas/pages/telaInicial.dart';

void main() {
  runApp(Inicial());
}

class Inicial extends StatefulWidget {
  @override
  _InicialState createState() => _InicialState();
}

class _InicialState extends State<Inicial> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListaTarefas(),
    );
  }
}
