import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/acciones_model.dart';
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/pages/finca/finca_page.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';


class NuevoBalance extends StatefulWidget {
    const NuevoBalance({Key? key}) : super(key: key);

  @override
  _NuevoBalanceState createState() => _NuevoBalanceState();
}

class _NuevoBalanceState extends State<NuevoBalance> {
    Future _getdataFoms(TestSuelo suelo) async{

        int value = await DBProvider.db.activateFerti(suelo.id);
        List<Acciones> acciones= await DBProvider.db.getAccionesIdTest(suelo.id);
        
        return [value, acciones];
    }
    FincasBloc _fincasBloc = FincasBloc();

    @override
    Widget build(BuildContext context) {

        TestSuelo suelo = ModalRoute.of(context)!.settings.arguments as TestSuelo;
        
        
        return FutureBuilder(
            future: _getdataFoms(suelo),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                _fincasBloc.obtenerEntradas(suelo.id, 2);
                _fincasBloc.obtenerAcciones(suelo.id);
                
                int? validacion = snapshot.data[0];
                List<Acciones>? acciones = snapshot.data[1];
                
                 return validacion == 1 ?
                    
                    Container(
                        child: ListView(
                            children: [
                                tituloDivider('Propuesta fertilización'),
                                _cardEntrada(suelo,fincasBloc.entradaStream, 'Propuesta de abonos', 'abonosPage', 2),
                                _botonBalance(context, suelo, 'Propuesta balance nutrientes', 2),
                                Divider(),
                                SizedBox(height: 50,),
                                _botonDecisiones(context, suelo, acciones )
                                
                                
                                

                            ],
                        ),
                        
                    )
                    :
                    Center(child: tituloDivider('Finalizar los formularios de recorrido de puntos y balance de nutriente actual '),);
                
                
            },
        );
        
    }


    Widget _cardEntrada(TestSuelo suelo, Stream streamData, String titulo, String url, int tipo){

        return StreamBuilder(
            stream: streamData,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                
                List entradas = snapshot.data;
                
                
                return GestureDetector(
                    child: cardDefault(
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                tituloCard(titulo),
                                Container(
                                    child: Icon(Icons.check_circle, 
                                        color: entradas.length == 0 ? Colors.black38 : Colors.green[900],
                                        size: 25,
                                    ),
                                    
                                )
                            ],
                        ),
                    ),
                    onTap: () => Navigator.pushNamed(context, url, arguments: [suelo, tipo]),
                );
            },
        );

    }

    Widget  _botonBalance(BuildContext context, TestSuelo suelo, String titulo, int tipo){
        
        return StreamBuilder(
            stream: fincasBloc.entradaStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                
                List<EntradaNutriente> entradas = snapshot.data;
                
                return Row(
                    children: [
                        Spacer(),
                        ButtonMainStyle(
                            title: titulo,
                            icon: Icons.save,
                            press: entradas.length > 0 ? () => Navigator.pushNamed(context, 'ResultadoNutrientes', arguments: [suelo, titulo, tipo]) : null,
                        ),
                        Spacer(),
                    ],
                );
            },
        );
    }

    Widget  _botonDecisiones(BuildContext context, TestSuelo suelo, List<Acciones>? acciones ){
        
        return StreamBuilder(
            stream: fincasBloc.entradaStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                return acciones!.length == 0 ?
                    Row(
                        children: [
                            Spacer(),
                            ButtonMainStyle(
                                title: 'Tomar desiciones',
                                icon: Icons.save,
                                press: snapshot.data.length > 0 ? () => Navigator.pushNamed(context, 'decisiones', arguments: suelo) : null,
                            ),
                            Spacer(),
                        ],
                    )
                    
                :
                    Row(
                        children: [
                            Spacer(),
                            ButtonMainStyle(
                                title: 'Ver Reporte',
                                icon: Icons.save,
                                press: () => Navigator.pushNamed(context, 'reportDetalle', arguments: suelo.id),
                            ),
                            Spacer(),
                        ],
                    )
                ;
                
            },
        );
    }

}