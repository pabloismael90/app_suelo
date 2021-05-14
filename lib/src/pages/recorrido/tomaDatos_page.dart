import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/finca_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';
import 'package:app_suelo/src/models/punto_model.dart';
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
        fincasBloc.obtenerNewAbono(suelo.id);

       return Scaffold(
            appBar: AppBar(),
            body: Column(
                children: [
                    escabezadoEstacion( context, suelo ),
                    Expanded(
                        
                    child: ListView(
                            children: [
                                _cardRecorrido(suelo),
                                _botonResultado( suelo, 'Resultado recorrido', 'recorridoResultado', fincasBloc.puntoStream, 5 ),
                                Divider(),
                                _tituloDivider('Balance nutrientes actual'),
                                Divider(),
                                _cardNutriente(suelo, 'Cosecha anual', 'cosechaAnual', fincasBloc.salidaStream),
                                _cardNutriente(suelo, 'Análisis de suelo', 'analisisSuelo', fincasBloc.sueloStream),
                                _cardEntrada(suelo, fincasBloc.entradaStream, 'Uso de abono anual', 'abonosPage' ),
                                _botonTemporal(suelo, 'Balance nutrientes actual', 1),
                                Divider(),
                                _tituloDivider('Balance nutrientes actual'),
                                Divider(),
                                _cardEntrada(suelo,fincasBloc.newAbono, 'Uso de abono anual2', 'NewAbonosPage'),
                                //_botonTemporal(suelo, 'Propuesta balance nutrientes', 2),
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

    Widget _tituloDivider(String titulo){
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
    

    Widget _cardEntrada(TestSuelo suelo, Stream streamData, String titulo, String url){

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
                    onTap: () => Navigator.pushNamed(context, url, arguments: suelo),
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

    Widget  _botonTemporal(TestSuelo suelo, String titulo, int tipo){
        
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
    
    

    Widget  _tomarDecisiones(TestSuelo suelo){
        
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
        
    }
}