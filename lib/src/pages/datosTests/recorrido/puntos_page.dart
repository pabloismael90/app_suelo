import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/punto_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/dialogDelete.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';

class RecorridoPage extends StatefulWidget {
  RecorridoPage({Key? key}) : super(key: key);

  @override
  _RecorridoPageState createState() => _RecorridoPageState();
}

class _RecorridoPageState extends State<RecorridoPage> {

    final fincasBloc = new FincasBloc();
    

    @override
    Widget build(BuildContext context) {
        
        TestSuelo suelo = ModalRoute.of(context)!.settings.arguments as TestSuelo;
        fincasBloc.obtenerPuntos(suelo.id);

        return Scaffold(
            appBar: AppBar(title:Text('Recorrido de parcela')),
            body: StreamBuilder<List<Punto>>(
                stream: fincasBloc.puntoStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    
                    List<Punto> puntos = snapshot.data;

                    return Column(
                        children: [ 
                            Expanded(
                                child: puntos.length == 0
                                ?
                                textoListaVacio('Ingrese datos de los puntos')
                                :
                                SingleChildScrollView(child: _listaDePisos(puntos, context)),
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
                        child: _countPiso(suelo)
                    ),
                ),
            ),
        );
    }

    Widget  _listaDePisos(List<Punto> puntos, BuildContext context){

        return ListView.builder(
            itemBuilder: (context, index) {
                
                return Dismissible(
                    key: UniqueKey(),
                    child: GestureDetector(
                        child:cardDefault(
                            tituloCard('Punto ${index+1}'),
                        )
                    ),
                    confirmDismiss: (direction) => confirmacionUser(direction, context),
                    direction: DismissDirection.endToStart,
                    background: backgroundTrash(context),
                    movementDuration: Duration(milliseconds: 500),
                    onDismissed: (direction) => fincasBloc.borrarPunto(puntos[index]),
                );
                
            },
            shrinkWrap: true,
            itemCount: puntos.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget  _countPiso(TestSuelo suelo){
                
        return StreamBuilder<List<Punto>>(
            stream: fincasBloc.puntoStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }

                 if (snapshot.data.length < 5) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            textoBottom('Pasos: ${snapshot.data.length} / 5',  kTextColor),
                            ButtonMainStyle(
                                title: 'Agregar punto',
                                icon: Icons.post_add,
                                press: () => Navigator.pushNamed(context, 'agregarPunto', arguments: [suelo.id, snapshot.data.length ]),
                            )
                        ],
                    );
                }else{
                    
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            textoBottom('Pasos: ${snapshot.data.length} / 5',  kTextColor),
                            ButtonMainStyle(
                                title: 'Finalizar',
                                icon: Icons.navigate_next_rounded,
                                press: () => Navigator.pop(context, 'salidaPage'),
                            )
                        ],
                    );
                }

            },
        );   
    }

    
}