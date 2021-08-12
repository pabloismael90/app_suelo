import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';


class Manuales extends StatelessWidget {
  const Manuales({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text('Lista de instructivos'),),
            body: ListView(
                children: [
                    _card( context, 'Instructivo suelo cacao', 'assets/documentos/Instructivo suelo.pdf'),
                    _card( context, 'Manual de usuario Cacao Suelo', 'assets/documentos/Manual de usuario Cacao Suelo.pdf')
                ],
            )
        );
    }

    Widget _card( BuildContext context, String titulo, String url){
        return GestureDetector(
            child: cardDefault(
                tituloCard('$titulo'),
            ),
            onTap: () => Navigator.pushNamed(context, 'PDFview', arguments: [titulo, url]),
        );
    }


}