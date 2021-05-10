import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/finca_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';
import 'package:app_suelo/src/models/punto_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:flutter/material.dart';

class TodaDatos extends StatefulWidget {
    const TodaDatos({Key key}) : super(key: key);

  @override
  _TodaDatosState createState() => _TodaDatosState();
}

int flagRecorrido = 0;
int flagSalida = 0;
int flagSuelo = 0;
int flagEntrada = 0;

class _TodaDatosState extends State<TodaDatos> {

    final fincasBloc = new FincasBloc();

    Future _getdataFinca(TestSuelo textPlaga) async{
        Finca finca = await DBProvider.db.getFincaId(textPlaga.idFinca);
        Parcela parcela = await DBProvider.db.getParcelaId(textPlaga.idLote);
        //List<Decisiones> desiciones = await DBProvider.db.getDecisionesIdTest(textPlaga.id);
        
        return [finca, parcela];
    }


    @override
    void initState() {
        super.initState();
    }
    @override
    Widget build(BuildContext context) {
        
        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        fincasBloc.obtenerPuntos(suelo.id);
        fincasBloc.obtenerSalida(suelo.id);
        fincasBloc.obtenerSuelo(suelo.id);
        fincasBloc.obtenerEntradas(suelo.id);

       return Scaffold(
            appBar: AppBar(),
            body: Column(
                children: [
                    escabezadoEstacion( context, suelo ),
                    Expanded(
                        
                    child: ListView(
                            children: [
                                _cardRecorrido(suelo),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Balance nutrientes',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme
                                            .headline5
                                            .copyWith(fontWeight: FontWeight.w900, fontSize: 22 )
                                    ),
                                ),
                                Divider(),
                                _cardSalidaNutriente(suelo),
                                
                                
                                _cardEntrada(suelo),
                                _cardSueloNutriente(suelo)
                            ],
                        ),
                    ),
                    
                ],
            ),
            bottomNavigationBar: BottomAppBar(
                child: _tomarDecisiones(suelo)
            ),
        );
    }



    Widget escabezadoEstacion( BuildContext context, TestSuelo suelo ){

        return FutureBuilder(
            future: _getdataFinca(suelo),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                }
                Finca finca = snapshot.data[0];
                Parcela parcela = snapshot.data[1];

                return Container(
                    
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                            
                            Flexible(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                    
                                        Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                            child: Text(
                                                "${finca.nombreFinca}",
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.headline6,
                                            ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only( bottom: 10.0),
                                            child: Text(
                                                "${parcela.nombreLote}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: kLightBlackColor),
                                            ),
                                        ),
                                        
                                    ],  
                                ),
                            ),
                        ],
                    ),
                );
            },
        );        
    }

    Widget _cardRecorrido(TestSuelo suelo){

        return StreamBuilder(
            stream: fincasBloc.puntoStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                
                List<Punto> puntos= snapshot.data;
                if (puntos.length >= 5) {
                  flagRecorrido = 1;                    
                }else{
                    flagRecorrido = 0; 
                }
                                
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
                                        'Recorrido de parcela',
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context).textTheme.headline6,
                                    ),
                                ),
                                Container(
                                    child: Icon(Icons.check_circle, 
                                        color: puntos.length < 5 ? Colors.black38 : Colors.green[900],
                                        size: 30,
                                    ),
                                    
                                ) 
                                
                                
                                
                            ],
                        ),
                    ),
                    onTap: () => Navigator.pushNamed(context, 'recorridoPage', arguments: suelo),
                );
            },
        );

    }
    
    Widget _cardSalidaNutriente(TestSuelo suelo){

        return StreamBuilder(
            stream: fincasBloc.salidaStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                
                SalidaNutriente salidaNutriente = snapshot.data;
                
                
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
                                        'Cosecha anual',
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context).textTheme.headline6,
                                    ),
                                ),
                                Container(
                                    child: Icon(Icons.check_circle, 
                                        color: salidaNutriente.id == null ? Colors.black38 : Colors.green[900],
                                        size: 30,
                                    ),
                                    
                                )
                            ],
                        ),
                    ),
                    onTap: () => Navigator.pushNamed(context, 'cosechaAnual', arguments: [suelo, salidaNutriente]),
                );
            },
        );

    }
    
    Widget _cardSueloNutriente(TestSuelo suelo){

        return StreamBuilder(
            stream: fincasBloc.sueloStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                
                SueloNutriente sueloNutriente = snapshot.data;
                
                
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
                                        'Análisis de suelo',
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context).textTheme.headline6,
                                    ),
                                ),
                                Container(
                                    child: Icon(Icons.check_circle, 
                                        color: sueloNutriente.id == null ? Colors.black38 : Colors.green[900],
                                        size: 30,
                                    ),
                                    
                                )
                            ],
                        ),
                    ),
                    onTap: () => Navigator.pushNamed(context, 'analisisSuelo', arguments: [suelo,sueloNutriente]),
                );
            },
        );

    }
    
    Widget _cardEntrada(TestSuelo suelo){

        return StreamBuilder(
            stream: fincasBloc.entradaStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                
                List<EntradaNutriente> entradas = snapshot.data;
                
                
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
                                        'Uso de abono anual',
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
                    onTap: () => Navigator.pushNamed(context, 'abonosPage', arguments: suelo),
                );
            },
        );

    }
    
    
    

    Widget  _tomarDecisiones(TestSuelo suelo){
        if (flagRecorrido == 1) {
          return Container(
                            color: kBackgroundColor,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                child: RaisedButton.icon(
                                    icon:Icon(Icons.add_circle_outline_outlined),
                                    
                                    label: Text('Toma de decisiones',
                                        style: Theme.of(context).textTheme
                                            .headline6
                                            .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
                                    ),
                                    padding:EdgeInsets.all(13),
                                    onPressed: () => Navigator.pushNamed(context, 'decisiones', arguments: suelo),
                                )
                            ),
                        );
        } else {
            return Container(
            color: kBackgroundColor,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                    "Complete las estaciones",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.w900, color: kRedColor, fontSize: 22)
                ),
            ),
        );
        }
        
    //     if(countEstaciones[0] >= 10 && countEstaciones[1] >= 10 && countEstaciones[2] >= 10){
            
    //         return StreamBuilder(
    //         stream: fincasBloc.decisionesStream ,
    //             builder: (BuildContext context, AsyncSnapshot snapshot) {
    //                 if (!snapshot.hasData) {
    //                     return Center(child: CircularProgressIndicator());
    //                 }
    //                 List<Decisiones> desiciones = snapshot.data;

    //                 //print(desiciones);

    //                 if (desiciones.length == 0){

                        
                        
                    // }


    //                 return Container(
    //                     color: kBackgroundColor,
    //                     child: Padding(
    //                         padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
    //                         child: RaisedButton.icon(
    //                             icon:Icon(Icons.receipt_rounded),
                            
    //                             label: Text('Consultar decisiones',
    //                                 style: Theme.of(context).textTheme
    //                                     .headline6
    //                                     .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
    //                             ),
    //                             padding:EdgeInsets.all(13),
    //                             onPressed: () => Navigator.pushNamed(context, 'reporte', arguments: suelo.id),
    //                         )
    //                     ),
    //                 );
                                       
    //             },  
    //         );
    //     }
        

    //     return Container(
    //         color: kBackgroundColor,
    //         child: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //             child: Text(
    //                 "Complete las estaciones",
    //                 textAlign: TextAlign.center,
    //                 style: Theme.of(context).textTheme
    //                     .headline5
    //                     .copyWith(fontWeight: FontWeight.w900, color: kRedColor, fontSize: 22)
    //             ),
    //         ),
    //     );
    }
}