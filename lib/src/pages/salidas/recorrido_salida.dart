import 'package:app_suelo/src/models/finca_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';
import 'package:app_suelo/src/models/punto_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';

class RecorridoResultado extends StatefulWidget {
  RecorridoResultado({Key key}) : super(key: key);

  @override
  _RecorridoResultadoState createState() => _RecorridoResultadoState();
}

class _RecorridoResultadoState extends State<RecorridoResultado> {
    
    Size size;

    Future _getdataFinca( TestSuelo suelo ) async{
        Finca finca = await DBProvider.db.getFincaId(suelo.idFinca);
        Parcela parcela = await DBProvider.db.getParcelaId(suelo.idLote);
        List<Punto> puntos = await DBProvider.db.getPuntosIdTest(suelo.id);
        
        return [finca, parcela, puntos,];
    }

    Future<double> _count(String idTest,int idPregunta, int idItem, int repuesta) async{
        double countPalga = await DBProvider.db.countPunto(idTest,idPregunta, idItem, repuesta);

        return (countPalga/5)*100;
    }
    
    @override
    Widget build(BuildContext context) {
        
        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        size = MediaQuery.of(context).size;

        return Scaffold(
            appBar: AppBar(),
            body: FutureBuilder(
            future:  _getdataFinca(suelo),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }

                    Finca finca = snapshot.data[0];
                    Parcela parcela = snapshot.data[1];
                    List<Punto> puntos = snapshot.data[2];


                    

                    return Column(
                        children: [
                            Container(
                                child: Column(
                                    children: [
                                        TitulosPages(titulo: 'Resultado recorrido'),
                                        _dataFincas(context,finca, parcela)                                      
                                    ],
                                )
                            ),
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
    Widget _dataFincas( BuildContext context, Finca finca, Parcela parcela ){
        String labelMedidaFinca;
        String labelvariedad;

        final item = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}');
        labelMedidaFinca  = item['label'];

        final itemvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela.variedadCacao}');
        labelvariedad  = itemvariedad['label'];

        return Container(
                    
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                                        style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only( bottom: 10.0),
                                    child: Text(
                                        "Productor ${finca.nombreProductor}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                ),

                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Flexible(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Padding(
                                                        padding: EdgeInsets.only( bottom: 10.0),
                                                        child: Text(
                                                            "Área Finca: ${finca.areaFinca} ($labelMedidaFinca)",
                                                            style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                                        ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only( bottom: 10.0),
                                                        child: Text(
                                                            "N de Plantas: ${parcela.numeroPlanta}",
                                                            style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                        Flexible(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Padding(
                                                        padding: EdgeInsets.only( bottom: 10.0, left: 20),
                                                        child: Text(
                                                            "Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)",
                                                            style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                                        ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only( bottom: 10.0, left: 20),
                                                        child: Text(
                                                            "Variedad: $labelvariedad ",
                                                            style: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        )
                                    ],
                                )

                                
                            ],  
                        ),
                    ),
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
                            style: Theme.of(context).textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
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
                        Expanded(child: Text('', style: Theme.of(context).textTheme.headline6
                                        .copyWith(fontSize: 14, fontWeight: FontWeight.w600))),
                        Container(
                            width: 60,
                            child: Text('No', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 14, fontWeight: FontWeight.w600,) ),
                        ),
                        Container(
                            width: 60,
                            child: Text(tipo == 1 ? 'Algo' : 'Mala', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 14, fontWeight: FontWeight.w600,) ),
                        ),
                        Container(
                            width: 60,
                            child: Text(tipo == 1 ? 'Severo' : 'Buena', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                    ],
                ),
                Divider(),
            ],
        );
    }

    Widget _rowRecorrido(String idTest,int tipo, String titulo, int pregunta, List<Map<String, dynamic>> preguntaItem){
        List<Widget> prueba = [];

        prueba.add(_tituloPregunta(titulo));
        prueba.add(_labelTipo(tipo));

        for (var item in preguntaItem) {
            
            prueba.add(
                 Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Text(item['label'], style: Theme.of(context).textTheme.headline6
                                        .copyWith(fontSize: 14, fontWeight: FontWeight.w600))),
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

    Widget _recorrido(TestSuelo suelo,List<Punto> puntos){
    
        return Container(
            decoration: BoxDecoration(
                
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                    Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                                color: Colors.white,
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                            BoxShadow(
                                                    color: Color(0xFF3A5160)
                                                        .withOpacity(0.05),
                                                    offset: const Offset(1.1, 1.1),
                                                    blurRadius: 17.0),
                                            ],
                                    ),
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
                            ),
                        ),
                    )
                    
                ],
            ),
        );
            
    }
    

}