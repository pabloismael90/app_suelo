import 'package:app_suelo/src/models/finca_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';
import 'package:app_suelo/src/models/punto_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';

class RecorridoResultado extends StatefulWidget {
  RecorridoResultado({Key? key}) : super(key: key);

  @override
  _RecorridoResultadoState createState() => _RecorridoResultadoState();
}

class _RecorridoResultadoState extends State<RecorridoResultado> {
    
    Size? size;

    Future _getdataFinca( TestSuelo suelo ) async{
        Finca? finca = await DBProvider.db.getFincaId(suelo.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(suelo.idLote);
        List<Punto> puntos = await DBProvider.db.getPuntosIdTest(suelo.id);
        
        return [finca, parcela, puntos,];
    }

    Future<double> _count(String? idTest,int idPregunta, int idItem, int repuesta) async{
        double countPalga = await DBProvider.db.countPunto(idTest,idPregunta, idItem, repuesta);

        return (countPalga/5)*100;
    }
    
    @override
    Widget build(BuildContext context) {
        
        TestSuelo suelo = ModalRoute.of(context)!.settings.arguments as TestSuelo;
        size = MediaQuery.of(context).size;

        return Scaffold(
            appBar: AppBar(title: Text('Resultado recorrido')),
            body: FutureBuilder(
            future:  _getdataFinca(suelo),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }

                    Finca finca = snapshot.data[0];
                    Parcela parcela = snapshot.data[1];
                    List<Punto>? puntos = snapshot.data[2];


                    

                    return Column(
                        children: [
                            _dataFincas(finca, parcela),
                            Expanded(
                                child: _recorrido(suelo, puntos),
                            ),
                        ],
                    );
                },
            ),
            
        );

    }

    //Datos de Finca
    Widget _dataFincas( Finca finca, Parcela parcela  ){
        return Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    encabezadoCard('Área finca: ${finca.nombreFinca}','Productor: ${finca.nombreProductor}', 'assets/icons/finca.svg'),
                    Wrap(
                        spacing: 20,
                        children: [
                            textoCardBody('Área finca: ${finca.areaFinca}'),
                            textoCardBody('Área parcela: ${parcela.areaLote} ${finca.tipoMedida == 1 ? 'Mz': 'Ha'}'), 
                        ],
                    )
                ],
            ),
        );        
    }

    //Pagina de Conteo de puntos
    Widget _tituloPregunta(String titulo){
        
        return  Column(
            children: [
                Container(
                    child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                            titulo,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                        ),
                    )
                ),
                Divider(),
                
            ],
        );
    }

    Widget _labelTipo(int tipo){
        
        return  Column(
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: textList('')),
                        Container(
                            width: 60,
                            child: titleList('No'),
                        ),
                        Container(
                            width: 60,
                            child: titleList(tipo == 1 ? 'Algo' : 'Mala'),
                        ),
                        Container(
                            width: 60,
                            child: titleList(tipo == 1 ? 'Severo' : 'Buena'),
                        ),
                    ],
                ),
                Divider(),
            ],
        );
    }

    Widget _rowRecorrido(String? idTest,int tipo, String titulo, int pregunta, List<Map<String, dynamic>> preguntaItem){
        List<Widget> prueba = [];

        prueba.add(_tituloPregunta(titulo));
        prueba.add(_labelTipo(tipo));

        for (var item in preguntaItem) {
            
            prueba.add(
                 Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: textList(item['label'])),
                        Container(
                            width: 60,
                            child: FutureBuilder(
                                future: _count(idTest,pregunta,int.parse(item['value']),1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return Text('0.0', textAlign: TextAlign.center);
                                    }
                                    
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 60,
                            child: FutureBuilder(
                                future: _count(idTest,pregunta,int.parse(item['value']), 2),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return Text('0.0', textAlign: TextAlign.center);
                                    }
                                    
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 60,
                            child: FutureBuilder(
                                future: _count(idTest,pregunta,int.parse(item['value']),3),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return Text('0.0', textAlign: TextAlign.center);
                                    }
                                    
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                    ],
                ),
            );
            prueba.add(Divider());
        }
        return  Column(
            children:prueba,
        );
 
    }

    Widget _recorrido(TestSuelo suelo,List<Punto>? puntos){
        return Container(
            color: Colors.white,
            padding: EdgeInsets.all(15),
            child: Column(
                children: [
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                                children: [
                                    _rowRecorrido(suelo.id,1, 'Observaciones de erosión', 1, selectMap.erosion()),
                                    _rowRecorrido(suelo.id, 2, 'Obras de conservación de suelo', 2, selectMap.conservacion()),
                                    _rowRecorrido(suelo.id, 1, 'Observaciones de drenaje', 3, selectMap.drenaje()),
                                    _rowRecorrido(suelo.id, 2, 'Obras de drenaje', 4, selectMap.obrasDrenaje()),
                                    _rowRecorrido(suelo.id, 1, 'Enfermedades de raíz', 5, selectMap.raiz()),
                                    
                                ],
                            ),
                        ),
                    )
                    
                ],
            ),
        );
            
    }
    

}