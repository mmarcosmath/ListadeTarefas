import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ListaTarefas extends StatefulWidget {
  @override
  _ListaTarefasState createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  List list = [];
  TextEditingController tarefa = TextEditingController();

  _ListaTarefasState() {
    _readData();
  }

  @override
  void initState() {
    super.initState();
    _readData();
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    var data = json.encode(list);
    var file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    String str;
    try {
      var file = await _getFile();
      str = await file.readAsString();
    } catch (e) {
      return null;
    }
    list = json.decode(str);
  }

  void addTarefa() {
    Map tf = Map<String, dynamic>();
    tf["tarefa"] = tarefa.text;
    tf["check"] = false;
    setState(() {
      list.add(tf);
    });
    _saveData();
    tarefa.clear();
  }

  void remove(Map tarefa) {
    setState(() {
      list.remove(tarefa);
      _saveData();
      _readData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: tarefa,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Digite uma nova tarefa',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(20),
                    color: Colors.blue,
                    child: Text('ADD'),
                    onPressed: addTarefa,
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    var tf = list[index];
                    return Dismissible(
                      key: Key(tf['tarefa']),
                      onDismissed: (direction) {
                        remove(tf);
                      },
                      child: Card(
                        child: ListTile(
                          leading: Container(
                            height: double.maxFinite,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: tf['check']
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                            ),
                          ),
                          title: Text(
                            tf['tarefa'],
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            setState(() {
                              tf['check'] = tf['check'] ? false : true;
                            });
                            _saveData();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
