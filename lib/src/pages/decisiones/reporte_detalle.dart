import 'dart:convert';

import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/acciones_model.dart';
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/finca_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';
import 'package:app_suelo/src/models/punto_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:app_suelo/src/utils/calculos.dart' as calculos;
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ReportDetalle extends StatefulWidget {
  ReportDetalle({Key key}) : super(key: key);

  @override
  _ReportDetalleState createState() => _ReportDetalleState();
}

Future<double> _count(String idTest,int idPregunta, int idItem, int repuesta) async{
    double countPalga = await DBProvider.db.countPunto(idTest,idPregunta, idItem, repuesta);

    return (countPalga/5)*100;
}

class _ReportDetalleState extends State<ReportDetalle> {

    Size size;
    final fincasBloc = new FincasBloc();
    String idTest;

    final List<Map<String, dynamic>>  _meses = selectMap.listMeses();
    final List<Map<String, dynamic>>  listSoluciones = selectMap.solucionesXmes();

    Future _getdataFinca( String idTest) async{

            TestSuelo suelo = await DBProvider.db.getTestId(idTest);
            Finca finca = await DBProvider.db.getFincaId(suelo.idFinca);
            Parcela parcela = await DBProvider.db.getParcelaId(suelo.idLote);
            List<Punto> puntos = await DBProvider.db.getPuntosIdTest(suelo.id);
            SalidaNutriente salidaNutriente = await DBProvider.db.getSalidaNutrientes(suelo.id);
            List<EntradaNutriente> entradas = await DBProvider.db.getEntradas(suelo.id, 1);
            SueloNutriente sueloNutriente = await DBProvider.db.getSueloNutrientes(suelo.id);
            List<EntradaNutriente> fertilizacion = await DBProvider.db.getEntradas(suelo.id, 2);
            List<Acciones> listAcciones = await DBProvider.db.getAccionesIdTest(suelo.id);
            
            return [finca, parcela, salidaNutriente, entradas, sueloNutriente, puntos, fertilizacion, suelo, listAcciones];
    }

    @override
    Widget build(BuildContext context) {

        idTest = ModalRoute.of(context).settings.arguments;
        size = MediaQuery.of(context).size;
                

        return Scaffold(
            appBar: AppBar(),
            body: FutureBuilder(
            future:  _getdataFinca(idTest),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }

                    

                    List<Widget> pageItem = List<Widget>();
                    Finca finca = snapshot.data[0];
                    Parcela parcela = snapshot.data[1];
                    SalidaNutriente salidaNutriente = snapshot.data[2];
                    List<EntradaNutriente> entradas = snapshot.data[3];
                    SueloNutriente sueloNutriente  = snapshot.data[4];
                    List<Punto> puntos = snapshot.data[5];
                    List<EntradaNutriente> fertilizacion = snapshot.data[6];
                    TestSuelo suelo = snapshot.data[7];
                    List<Acciones> listAcciones = snapshot.data[8];

                    pageItem.add(_dataFincas( context, finca, parcela),);
                    pageItem.add(_disponibilidad('Balance neto del Sistema SAF actual', 'Disponibilidad de nutriente actual', finca, parcela, salidaNutriente, entradas, sueloNutriente));
                    pageItem.add(_disponibilidad('Propuesta Balance neto del Sistema SAF', 'Propuesta disponibilidad de nutriente', finca, parcela, salidaNutriente, fertilizacion, sueloNutriente));
                    pageItem.add(_recorrido(suelo, puntos));
                    pageItem.add(_accionesMeses(listAcciones));

                    return Column(
                        children: [
                            Container(
                                child: Column(
                                    children: [
                                        TitulosPages(titulo: 'Reporte'),
                                        Divider(),
                                        Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: Row(
                                          
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                    Container(
                                                        width: 200,
                                                        child: Text(
                                                                "Deslice hacia la derecha para continuar con el reporte",
                                                                textAlign: TextAlign.center,
                                                                style: Theme.of(context).textTheme
                                                                    .headline5
                                                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 14)
                                                            )
                                                    
                                                    ),
                                                    
                                                    
                                                    Transform.rotate(
                                                        angle: 90 * math.pi / 180,
                                                        child: Icon(
                                                            Icons.arrow_circle_up_rounded,
                                                            size: 25,
                                                        ),
                                                        
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ],
                                )
                            ),
                            Expanded(
                                
                                child: Swiper(
                                    itemBuilder: (BuildContext context, int index) {
                                        return pageItem[index];
                                    },
                                    itemCount: pageItem.length,
                                    viewportFraction: 1,
                                    loop: false,
                                    scale: 1,
                                ),
                            ),
                        ],
                    );
                },
            ),
            
        );
    }
    



    Widget _titulosForm(String titulo, double ancho){
        return Flexible(
            child: Container(
                width: ancho,
                child: Text(titulo, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                .copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
        );
    }
    
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

    Widget _rowData( String tituloRow, double salida, double entrada ){
        return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                _titulosForm(tituloRow, size.width * 0.4),
                Flexible(
                    child: Container(
                        width: size.width * 0.4,
                        child: Text(salida.toStringAsFixed(1), textAlign: TextAlign.center)
                    ),
                ),
                Flexible(
                    child: Container(
                        width: size.width * 0.4,
                        child: Text(entrada.toStringAsFixed(1), textAlign: TextAlign.center)
                    ),
                ),
                Flexible(
                    child: Container(
                        width: size.width * 0.4,
                        child: Text((entrada - salida).toStringAsFixed(1) == '-0.0' ? '0.0' : (entrada - salida).toStringAsFixed(1) , textAlign: TextAlign.center)
                    ),
                ),
                
            ],
        );
    }

    
    
    //Balance neto SAF y Disponibilidada de nutrientes
    Widget _rowDisponibilidad( String tituloRow, double salida, double entrada, double suelo){

        double balance = (entrada + suelo) - salida;

        return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                _titulosForm(tituloRow, size.width * 0.2),
                Flexible(
                    child: Container(
                        width: size.width * 0.2,
                        child: Text(salida.toStringAsFixed(1), textAlign: TextAlign.center)
                    ),
                ),
                Flexible(
                    child: Container(
                        width: size.width * 0.2,
                        child: Text(entrada.toStringAsFixed(1), textAlign: TextAlign.center)
                    ),
                ),
                Flexible(
                    child: Container(
                        width: size.width * 0.2,
                        child: Text(suelo.toStringAsFixed(1) == '-0.0' ? '0.0' : suelo.toStringAsFixed(1) , textAlign: TextAlign.center)
                    ),
                ),
                Flexible(
                    child: Container(
                        width: size.width * 0.2,
                        child: Text(balance.toStringAsFixed(1) == '-0.0' ? '0.0' : balance.toStringAsFixed(1) , textAlign: TextAlign.center)
                    ),
                ),
                
            ],
        );
    }

    Widget _disponibilidad(String tituloBalance, String tituloDisponibilidad, Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas, SueloNutriente sueloNutriente){
    
        return Container(
            decoration: BoxDecoration(
                
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                    Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                                 margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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
                                        _tituloPregunta(tituloBalance),
                                        Column(
                                            children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                        _titulosForm('Kg/año', size.width * 0.4),
                                                        _titulosForm('Salida', size.width * 0.4),
                                                        _titulosForm('Entrada', size.width * 0.4),
                                                        _titulosForm('Balance', size.width * 0.4),
                                                    ],
                                                ),
                                                Divider(),
                                                _rowData(
                                                    'Nitrogeno', 
                                                    calculos.salidaElemeto(salidaNutriente, 'N'),                                                        
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'N', parcela)
                                                ),
                                                Divider(),
                                                _rowData(
                                                    'Fósforo', 
                                                    calculos.salidaElemeto(salidaNutriente, 'P'),
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'P', parcela)
                                                ),
                                                Divider(),
                                                _rowData(
                                                    'Potasio',
                                                    calculos.salidaElemeto(salidaNutriente, 'K'),
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'K', parcela)
                                                ),
                                                Divider(),
                                                _rowData(
                                                    'Calcio', 
                                                    calculos.salidaElemeto(salidaNutriente, 'Ca'),
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'Ca', parcela)
                                                ),
                                                Divider(),
                                                _rowData(
                                                    'Magnesio', 
                                                    calculos.salidaElemeto(salidaNutriente, 'Mg'),
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'Mg', parcela)
                                                ),
                                                Divider(),
                                                _rowData(
                                                    'Azufre', 
                                                    calculos.salidaElemeto(salidaNutriente, 'S'), 
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'S', parcela)
                                                ),
                                                Divider(),
                                                
                                            ],
                                        ),
                                    
                                        _tituloPregunta(tituloDisponibilidad),
                                        Column(
                                            children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                        _titulosForm('Kg/año', size.width * 0.2),
                                                        _titulosForm('Salida', size.width * 0.2),
                                                        _titulosForm('Entrada', size.width * 0.2),
                                                        _titulosForm('Suelo', size.width * 0.2),
                                                        _titulosForm('Balance', size.width * 0.2),
                                                    ],
                                                ),
                                                Divider(),
                                                _rowDisponibilidad(
                                                    'N', 
                                                    calculos.salidaElemeto(salidaNutriente, 'N'),                                                        
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'N', parcela),
                                                    calculos.nutrienteSuelo(sueloNutriente, 'N'),
                                                ),
                                                Divider(),
                                                _rowDisponibilidad(
                                                    'P', 
                                                    calculos.salidaElemeto(salidaNutriente, 'P'),
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'P', parcela),
                                                    calculos.nutrienteSuelo(sueloNutriente, 'P'),
                                                ),
                                                Divider(),
                                                _rowDisponibilidad(
                                                    'K',
                                                    calculos.salidaElemeto(salidaNutriente, 'K'),
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'K', parcela),
                                                    calculos.nutrienteSuelo(sueloNutriente, 'K'),
                                                ),
                                                Divider(),
                                                _rowDisponibilidad(
                                                    'Ca', 
                                                    calculos.salidaElemeto(salidaNutriente, 'Ca'),
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'Ca', parcela),
                                                    calculos.nutrienteSuelo(sueloNutriente, 'Ca'),
                                                ),
                                                Divider(),
                                                _rowDisponibilidad(
                                                    'Mg', 
                                                    calculos.salidaElemeto(salidaNutriente, 'Mg'),
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'Mg', parcela),
                                                    calculos.nutrienteSuelo(sueloNutriente, 'Mg'),
                                                ),
                                                Divider(),
                                                _rowDisponibilidad(
                                                    'S', 
                                                    calculos.salidaElemeto(salidaNutriente, 'S'), 
                                                    calculos.entradaElemento(entradas, sueloNutriente, 'S', parcela),
                                                    calculos.nutrienteSuelo(sueloNutriente, 'S'),
                                                ),
                                                Divider(),
                                                
                                            ],
                                        ),
                                        
                                        
                                        
                                    ],
                                ),
                            ),
                        ),
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
                            style: Theme.of(context).textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.w600, fontSize: 17)
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

    //Acciones
    Widget _accionesMeses(List<Acciones> listAcciones){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add( _tituloPregunta('Nueva propuesta de manejo de suelo'));
        
        
        for (var item in listAcciones) {

                List<String> meses = [];
                String label= listSoluciones.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];
                List listaMeses = jsonDecode(item.repuesta);
                if (listaMeses.length==0) {
                    meses.add('Sin aplicar');
                }
                for (var item in listaMeses) {
                    String mes = _meses.firstWhere((e) => e['value'] == '$item', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    meses.add(mes);
                }
                

                listPrincipales.add(

                    ListTile(
                        title: Text('$label',
                            style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                        subtitle: Text(meses.join(","+" ")),
                    )                 
                    
                );
            
            
            
            
        }
        return SingleChildScrollView(
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
                child: Column(children:listPrincipales,)
            ),
        );
    }



}

