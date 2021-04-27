import 'package:flutter/material.dart';

class RecorridoPage extends StatefulWidget {
  RecorridoPage({Key key}) : super(key: key);

  @override
  _RecorridoPageState createState() => _RecorridoPageState();
}

class _RecorridoPageState extends State<RecorridoPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('recorrido page'),),
        );
    }
}