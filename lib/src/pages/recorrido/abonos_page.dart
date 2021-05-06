import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';

class AbonosPage extends StatefulWidget {
  AbonosPage({Key key}) : super(key: key);

  @override
  _AbonosPageState createState() => _AbonosPageState();
}

class _AbonosPageState extends State<AbonosPage> {
    @override
    Widget build(BuildContext context) {

        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        
        return Scaffold(
            appBar: AppBar(),
            body: Column(
                children: [
                    TitulosPages(titulo: 'Titulo'),
                    Divider(), 
                    Expanded(child: Center(
                        child: Text('No hay datos: \nIngrese datos de pasos', 
                        textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                            )
                        )
                    )
                ],
            ),
            bottomNavigationBar: BottomAppBar(
                child: Container(
                    color: kBackgroundColor,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _addAbono(suelo)
                    ),
                ),
            ),
        );
    }

    Widget _addAbono(TestSuelo suelo){
        return Container(
            color: kBackgroundColor,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                child: RaisedButton.icon(
                    icon:Icon(Icons.add_circle_outline_outlined),
                    
                    label: Text('Agregar Abono',
                        style: Theme.of(context).textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
                    ),
                    padding:EdgeInsets.all(13),
                    onPressed: () => Navigator.pushNamed(context, 'AddAbono', arguments: suelo),
                )
            ),
        );
    }
}