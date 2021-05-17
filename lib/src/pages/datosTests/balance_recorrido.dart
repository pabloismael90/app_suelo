import 'package:app_suelo/src/models/punto_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/pages/finca/finca_page.dart';
import 'package:flutter/material.dart';


class BalanceRecorrido extends StatelessWidget {
    const BalanceRecorrido({Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {

        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        fincasBloc.obtenerPuntos(suelo.id);
        fincasBloc.obtenerSalida(suelo.id);
        fincasBloc.obtenerSuelo(suelo.id);
        fincasBloc.obtenerEntradas(suelo.id, 1);

        return Container(
            child: ListView(
                children: [
                    _cardRecorrido(suelo),
                    _botonResultado( suelo, 'Resultado recorrido', 'recorridoResultado', fincasBloc.puntoStream, 5 ),
                    Divider(),
                    _tituloDivider(context,'Balance nutrientes actual'),
                    Divider(),
                    _cardNutriente(suelo, 'Cosecha anual', 'cosechaAnual', fincasBloc.salidaStream),
                    _cardNutriente(suelo, 'Análisis de suelo', 'analisisSuelo', fincasBloc.sueloStream),
                    _cardEntrada(suelo, fincasBloc.entradaStream, 'Uso de abono anual', 'abonosPage', 1 ),
                    _botonTemporal(context, suelo, 'Balance nutrientes actual', 1),
                ],
            ),
            
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


    Widget _cardRecorrido(TestSuelo suelo){

        return StreamBuilder(
            stream: fincasBloc.puntoStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                
                List<Punto> puntos= snapshot.data;
                
                                
                return GestureDetector(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                            
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
    
    Widget _cardNutriente(TestSuelo suelo, String titulo, String url, Stream streamData){

        return StreamBuilder(
            stream: streamData,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                
                var nutrientes = snapshot.data;
                
                
                return GestureDetector(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            
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
                                        color: nutrientes.id == null ? Colors.black38 : Colors.green[900],
                                        size: 30,
                                    ),
                                    
                                )
                            ],
                        ),
                    ),
                    onTap: () => Navigator.pushNamed(context, url, arguments: [suelo, nutrientes]),
                );
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
    
   

    Widget  _botonResultado(TestSuelo suelo, String titulo, String url, Stream streamData, int validacion ){
        
        return StreamBuilder(
            stream: streamData ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    child: RaisedButton(
                        child: Text(titulo,
                            style: Theme.of(context).textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
                        ),
                        padding:EdgeInsets.all(13),
                        onPressed: snapshot.data.length == validacion ? () => Navigator.pushNamed(context, url, arguments: suelo) : null,
                    ),
                );
            },
        );

        
        
    }

    Widget  _botonTemporal(BuildContext context, TestSuelo suelo, String titulo, int tipo){
        
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
            child: RaisedButton(
                child: Text(titulo,
                    style: Theme.of(context).textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
                ),
                padding:EdgeInsets.all(13),
                onPressed: () => Navigator.pushNamed(context, 'ResultadoNutrientes', arguments: [suelo, titulo, tipo]),
            ),
        );

    }
    
}