import 'package:app_suelo/src/models/punto_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/pages/finca/finca_page.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';


class BalanceRecorrido extends StatelessWidget {
    const BalanceRecorrido({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {

        TestSuelo suelo = ModalRoute.of(context)!.settings.arguments as TestSuelo;
        fincasBloc.obtenerPuntos(suelo.id);
        fincasBloc.obtenerSalida(suelo.id);
        fincasBloc.obtenerSuelo(suelo.id);
        fincasBloc.obtenerEntradas(suelo.id, 1);
        

        return Container(
            child: ListView(
                children: [
                    _cardRecorrido(suelo),
                    _btnRecorrido( suelo, 'Resultado recorrido', 'recorridoResultado', fincasBloc.puntoStream, 5 ),
                    Divider(),
                    _tituloDivider('Balance nutrientes actual'),
                    Divider(),
                    _cardItem(suelo, 'Cosecha anual', 'cosechaAnual', fincasBloc.salidaStream),
                    _cardItem(suelo, 'Análisis de suelo', 'analisisSuelo', fincasBloc.sueloStream),
                    _cardEntrada(suelo, fincasBloc.entradaStream, 'Uso de abono anual', 'abonosPage', 1 ),
                    _btnBalanceActual( suelo, 'Balance nutrientes actual', 1),
                ],
            ),
            
        );
    }

    Widget _tituloDivider(String titulo){
        return Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
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
                    child: cardDefault(
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                tituloCard('Recorrido de parcela'),
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
    
    Widget _cardItem(TestSuelo suelo, String titulo, String url, Stream streamData){

        return StreamBuilder(
            stream: streamData,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                
                var nutrientes = snapshot.data;
                
                return GestureDetector(
                    child: cardDefault(
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                tituloCard(titulo),
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
                    child: cardDefault(
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                tituloCard(titulo),
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

    Widget  _btnRecorrido(TestSuelo suelo, String titulo, String url, Stream streamData, int validacion ){
        
        return StreamBuilder(
            stream: streamData ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }

                return Row(
                    children: [
                        Spacer(),
                        ButtonMainStyle(
                            title: titulo,
                            icon: Icons.save,
                            press: snapshot.data.length == validacion ? () => Navigator.pushNamed(context, url, arguments: suelo) : null,
                        ),
                        Spacer(),
                    ],
                );
            },
        );

        
        
    }

    Widget  _btnBalanceActual(TestSuelo suelo, String titulo, int tipo){
        fincasBloc.monitoreoBalance(suelo.id);
        return StreamBuilder(
            stream: fincasBloc.monitoreoStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                }
                return Row(
                    children: [
                        Spacer(),
                        ButtonMainStyle(
                            title: titulo,
                            icon: Icons.save,
                            press: snapshot.data == 1 ? () => Navigator.pushNamed(context, 'ResultadoNutrientes', arguments: [suelo, titulo, tipo]) : null,
                        ),
                        Spacer(),
                    ],
                );
                
            },
        );
        
         

    }
    
}