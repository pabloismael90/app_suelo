import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/pages/parcelas/parcelas_page.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/dialogDelete.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';

class AbonosPage extends StatefulWidget {
  AbonosPage({Key key}) : super(key: key);

  @override
  _AbonosPageState createState() => _AbonosPageState();
}

class _AbonosPageState extends State<AbonosPage> {
    @override
    Widget build(BuildContext context) {

        List dataRoute = ModalRoute.of(context).settings.arguments;

        TestSuelo suelo = dataRoute[0];
        int tipo = dataRoute[1];
        

        fincasBloc.obtenerEntradas(suelo.id, tipo);
        
        
        
        return Scaffold(
            appBar: AppBar(),
            body: StreamBuilder(
                stream: fincasBloc.entradaStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    
                    List<EntradaNutriente> entradas = snapshot.data;

                    if (entradas.length == 0) {
                        return Column(
                            children: [
                                TitulosPages(titulo: 'Lista de Abonos'),
                                Divider(), 
                                Expanded(child: Center(
                                    child: Text('No hay datos: \nIngrese datos de abonos', 
                                    textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.headline6,
                                        )
                                    )
                                )
                            ],
                        );
                    }
                    return Column(
                        children: [
                            TitulosPages(titulo: 'Lista de Abonos'),
                            Divider(),                            
                            Expanded(
                                child: SingleChildScrollView(
                                    child: _listaDePisos(entradas, context)
                                    
                                )
                            ),
                        ],
                    );
                },
            ),
            bottomNavigationBar: BottomAppBar(
                child: Container(
                    color: kBackgroundColor,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _addAbono(suelo, tipo)
                    ),
                ),
            ),
        );
    }

    Widget  _listaDePisos(List<EntradaNutriente> entradas, BuildContext context){

        return ListView.builder(
            itemBuilder: (context, index) {
                
                String labelAbono = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entradas[index].idAbono}', orElse: () => {"value": "1","label": "No data"})['label'];

                return Dismissible(
                    key: UniqueKey(),
                    child: GestureDetector(
                        child:Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.5),
                                    boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF3A5160)
                                                .withOpacity(0.05),
                                            offset: const Offset(1.1, 1.1),
                                            blurRadius: 17.0),
                                        ],
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        
                                        Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                            child: Text(
                                                labelAbono,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.headline6,
                                            ),
                                        ),
                                    ],
                                ),
                        )
                    ),
                    confirmDismiss: (direction) => confirmacionUser(direction, context),
                    direction: DismissDirection.endToStart,
                    background: backgroundTrash(context),
                    movementDuration: Duration(milliseconds: 500),
                    onDismissed: (direction) => fincasBloc.borrarEntrada(entradas[index]),
                );
                
            },
            shrinkWrap: true,
            itemCount: entradas.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }


    Widget _addAbono(TestSuelo suelo, int tipo){
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
                    onPressed: () => Navigator.pushNamed(context, 'AddAbono', arguments: [suelo, tipo]),
                )
            ),
        );
    }
}