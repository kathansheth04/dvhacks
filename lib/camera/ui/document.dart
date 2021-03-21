import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dvhacks/camera/tools/result.dart';

class Document extends StatelessWidget {
  List data;

  Document(String json) {
    var content =
        jsonDecode(json.substring(1, json.length - 1).replaceAll('\\"', '"'));
    data = new List();
    for (final jsonString in content) {
      data.add(Field.fromJson(jsonString));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:
          new AppBar(title: new Text("Image"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
              child: Column(
            children: [
              new Text(data[index].label),
              new Text(data[index].value),
            ],
          ));
        },
      ),
    );
  }
}
