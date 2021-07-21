import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/pages/parcelas/parcelas_page.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/dialogDelete.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';

class AbonosPage extends StatefulWidget {
  AbonosPage({Key? key}) : super(key: key);

  @override
  _AbonosPageState createState() => _AbonosPageState();
}

class _AbonosPageState extends State<AbonosPage> {
    @override
    Widget build(BuildContext context) {

        List dataRoute = ModalRoute.of(context)!.settings.arguments as List<dynamic>;

        TestSuelo suelo = dataRoute[0];
        int tipo = dataRoute[1];
        

        fincasBloc.obtenerEntradas(suelo.id, tipo);
        
        
        
        return Scaffold(
            appBar: AppBar(title: Text('Lista de abonos actual')),
            body: StreamBuilder(
                stream: fincasBloc.entradaStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    
                    List<EntradaNutriente> entradas = snapshot.data;

                    return Column(
                        children: [ 
                            Expanded(
                                child: entradas.length == 0
                                ?
                                textoListaVacio('Ingrese datos de abonos')
                                :
                                SingleChildScrollView(child: _listaDePisos(entradas, context)),
                            ),
                        ],
                    );
                },
            ),
            bottomNavigationBar: BottomAppBar(
                child: Container(
                    color: kBackgroundColor,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                            _addAbono(suelo, tipo),
                            _finalizar(),
                        ],
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
                        child:cardDefault(tituloCard(labelAbono))
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
        return ButtonMainStyle(
            title: 'Agregar Abono',
            icon: Icons.post_add,
            press: () => Navigator.pushNamed(context, 'AddAbono', arguments: [suelo, tipo]),
        );
    }

    Widget _finalizar(){
       return StreamBuilder(
            stream: fincasBloc.entradaStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }

                List<EntradaNutriente> entradas = snapshot.data;
                return ButtonMainStyle(
                    title: 'Finalizar',
                    icon: Icons.post_add,
                    press: entradas.length == 0 ? null : () => Navigator.pop(context),
                );
            },
        );
         
    }

    
}