import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/acciones_model.dart';
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/pages/finca/finca_page.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:flutter/material.dart';


class NuevoBalance extends StatefulWidget {
    const NuevoBalance({Key key}) : super(key: key);

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

        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        
        
        return FutureBuilder(
            future: _getdataFoms(suelo),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                _fincasBloc.obtenerEntradas(suelo.id, 2);
                _fincasBloc.obtenerAcciones(suelo.id);
                
                int validacion = snapshot.data[0];
                List<Acciones> acciones = snapshot.data[1];
                
                if (validacion == 1) {
                    
                    return Container(
                        child: ListView(
                            children: [
                                _tituloDivider(context, 'Propuesta fertilización'),
                                Divider(),
                                _cardEntrada(suelo,fincasBloc.entradaStream, 'Propuesta de abonos', 'abonosPage', 2),
                                _botonBalance(context, suelo, 'Propuesta balance nutrientes', 2),
                                Divider(),
                                SizedBox(height: 50,),
                                _botonDecisiones(context, suelo, acciones )
                                
                                
                                

                            ],
                        ),
                        
                    );
                } else {
                    return Center(child: _tituloDivider(context,'Finalizar los formularios de recorrido de puntos y balance de nutriente actual '),);
                }
                
            },
        );
        
    }

    Widget _tituloDivider(BuildContext context, String titulo){
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.w900, fontSize: 20 )
            ),
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
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                            
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                                BoxShadow(
                                        color: Color(0xFF3A5160)
                                            .withOpacity(0.05),
                                        offset: const Offset(1.1, 1.1),
                                        blurRadius: 17.0),
                                ],
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                
                                Padding(
                                    padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                    child: Text(
                                        titulo,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context).textTheme.headline6,
                                    ),
                                ),
                                Container(
                                    child: Icon(Icons.check_circle, 
                                        color: entradas.length == 0 ? Colors.black38 : Colors.green[900],
                                        size: 30,
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
                
                
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    child: RaisedButton(
                        child: Text(titulo,
                            style: Theme.of(context).textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
                        ),
                        padding:EdgeInsets.all(13),
                        onPressed: entradas.length > 0 ? () => Navigator.pushNamed(context, 'ResultadoNutrientes', arguments: [suelo, titulo, tipo]) : null,
                    ),
                );
            },
        );

        

    }

    Widget  _botonDecisiones(BuildContext context, TestSuelo suelo, List<Acciones> acciones ){
        
        return StreamBuilder(
            stream: fincasBloc.entradaStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                if (acciones.length == 0) {
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                        child: RaisedButton(
                            child: Text('Tomar desiciones',
                                style: Theme.of(context).textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
                            ),
                            padding:EdgeInsets.all(13),
                            onPressed: snapshot.data.length > 0 ? () => Navigator.pushNamed(context, 'decisiones', arguments: suelo) : null,
                        ),
                    );
                }

                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    child: RaisedButton(
                        child: Text('Ver Reporte',
                            style: Theme.of(context).textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
                        ),
                        padding:EdgeInsets.all(13),
                        onPressed:  () => Navigator.pushNamed(context, 'reportDetalle', arguments: suelo.id),
                    ),
                );
                
            },
        );

        

    }

}