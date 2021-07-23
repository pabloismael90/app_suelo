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
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:app_suelo/src/utils/calculos.dart' as calculos;
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';

class ReportDetalle extends StatefulWidget {
  ReportDetalle({Key? key}) : super(key: key);

  @override
  _ReportDetalleState createState() => _ReportDetalleState();
}

Future<double> _count(String? idTest,int idPregunta, int idItem, int repuesta) async{
    double countPalga = await DBProvider.db.countPunto(idTest,idPregunta, idItem, repuesta);

    return (countPalga/5)*100;
}

class _ReportDetalleState extends State<ReportDetalle> {

    late Size size;
    final fincasBloc = new FincasBloc();
    String? idTest;

    final List<Map<String, dynamic>>  _meses = selectMap.listMeses();
    final List<Map<String, dynamic>>  listSoluciones = selectMap.solucionesXmes();

    Future _getdataFinca( String? idTest) async{

            TestSuelo? suelo = await (DBProvider.db.getTestId(idTest));
            Finca? finca = await DBProvider.db.getFincaId(suelo!.idFinca);
            Parcela? parcela = await DBProvider.db.getParcelaId(suelo.idLote);
            List<Punto> puntos = await DBProvider.db.getPuntosIdTest(suelo.id);
            SalidaNutriente salidaNutriente = await DBProvider.db.getSalidaNutrientes(suelo.id);
            List<EntradaNutriente> entradas = await DBProvider.db.getEntradas(suelo.id, 1);
            SueloNutriente sueloNutriente = await DBProvider.db.getSueloNutrientes(suelo.id);
            List<EntradaNutriente> fertilizacion = await DBProvider.db.getEntradas(suelo.id, 2);
            List<Acciones> listAcciones = await DBProvider.db.getAccionesIdTest(suelo.id);
            
            return [finca, parcela, salidaNutriente, entradas, sueloNutriente,
                    puntos, fertilizacion, suelo, listAcciones];
    }

    @override
    Widget build(BuildContext context) {

        TestSuelo? suelo = ModalRoute.of(context)!.settings.arguments as TestSuelo;
        size = MediaQuery.of(context).size;
                

        return Scaffold(
            appBar: AppBar(title: Text('Reporte'),),
            body: FutureBuilder(
            future:  _getdataFinca(suelo.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }

                    

                    List<Widget> pageItem =  [];
                    Finca finca = snapshot.data[0];
                    Parcela parcela = snapshot.data[1];
                    SalidaNutriente salidaNutriente = snapshot.data[2];
                    List<EntradaNutriente> entradas = snapshot.data[3];
                    SueloNutriente? sueloNutriente  = snapshot.data[4];
                    List<Punto>? puntos = snapshot.data[5];
                    List<EntradaNutriente> fertilizacion = snapshot.data[6];
                    TestSuelo suelo = snapshot.data[7];
                    List<Acciones> listAcciones = snapshot.data[8];

                    String? labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}')['label'];

                    pageItem.add(_paginaUno(finca, parcela, salidaNutriente, labelMedidaFinca, entradas, 1), );
                    pageItem.add(_balance('Balance neto del Sistema SAF actual', 'Disponibilidad de nutriente actual', finca, parcela, salidaNutriente, entradas, sueloNutriente));
                    pageItem.add(_paginaUno(finca, parcela, salidaNutriente, labelMedidaFinca, fertilizacion, 3), );
                    pageItem.add(_balance('Propuesta Balance neto del Sistema SAF', 'Propuesta disponibilidad de nutriente', finca, parcela, salidaNutriente, fertilizacion, sueloNutriente));
                    pageItem.add(_recorrido(suelo, puntos));
                    pageItem.add(_accionesMeses(listAcciones));

                    return Column(
                        children: [
                            mensajeSwipe('Deslice hacia la derecha para continuar con el reporte'),
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
    
    //Pagina Uno
    Widget _paginaUno(Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, String? labelMedidaFinca, List<EntradaNutriente> listAbonosActual, int pagina){
        return Container(
            padding: EdgeInsets.all(15),
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
                    children: [
                        pagina == 1 ?
                        _dataFincas(finca, parcela, labelMedidaFinca!)
                        :
                        Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                    textoCardBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)'),
                                    textoCardBody('N de plantas: ${parcela.numeroPlanta}'),
                                ],
                            ),
                        ),
                        tituloDivider('Cosecha anual'),
                        _cosechaAnual(salidaNutriente),
                        tituloDivider('Uso de abono actual'),
                        _abonosList(listAbonosActual, parcela)
                    ],
                ),
            ),
        );
    }
    
    Widget _dataFincas(Finca finca, Parcela parcela, String labelMedidaFinca ){
        String? labelvariedad;
        labelvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela.variedadCacao}')['label'];

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                encabezadoCard('${finca.nombreFinca}','Parcela: ${parcela.nombreLote}', ''),
                textoCardBody('Productor: ${finca.nombreProductor}'),
                tecnico('${finca.nombreTecnico}'),
                textoCardBody('Variedad: $labelvariedad'),
                Wrap(
                    spacing: 20,
                    children: [
                        textoCardBody('Área Finca: ${finca.areaFinca} ($labelMedidaFinca)'),
                        textoCardBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)'),
                        textoCardBody('N de plantas: ${parcela.numeroPlanta}'),
                    ],
                ),
            ],  
        );

    }
    
    Widget _cosechaAnual(SalidaNutriente salidaNutriente){
        

        return Container(
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    textoCardBody('Cacao baba: ${salidaNutriente.cacao} QQ / año'),
                    textoCardBody('Cascara de cacao: ${salidaNutriente.cascaraCacao == 0 ? salidaNutriente.cacao : 0} QQ de grano'),
                    textoCardBody('Leña: ${salidaNutriente.lena} Carga'),
                    textoCardBody('Frutas: ${salidaNutriente.fruta} Sacos'),
                    textoCardBody('Madera: ${salidaNutriente.madera} Pie tablar'),
                    
                    
                    
                ],
            ),
        );

    }

    Widget _abonosList(List<EntradaNutriente> listAbonos, Parcela parcela){
        
        return ListView.builder(
            itemBuilder: (context, index) {
                String labelAbono = selectMap.listAbonos().firstWhere((e) => e['value'] == '${listAbonos[index].idAbono}', orElse: () => {"value": "1","label": "No data"})['label'];
                String? unidad = selectMap.unidadAbono().firstWhere((e) => e['value'] == '${listAbonos[index].unidad}', orElse: () => {"value": "1","label": "No data"})['label'];
                String montoUnidad = unidad!.split("/")[0];
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        
                        tituloCard(labelAbono),
                        Wrap(
                            spacing: 20,
                            children: [
                                textoCardBody('Humedad (%) : ${listAbonos[index].humedad} % '),
                                textoCardBody('Cantidad: ${listAbonos[index].cantidad} $unidad'),
                                textoCardBody('Frecuencia: ${listAbonos[index].frecuencia}'),
                                textoCardBody('Monto total: ${listAbonos[index].cantidad! * listAbonos[index].frecuencia! * parcela.numeroPlanta!} $montoUnidad'),

                            ],
                        ),
                        
                        Divider(color: Colors.black54,)
                    ],
                );
                
            },
            shrinkWrap: true,
            itemCount: listAbonos.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }
    

    //Pagina 2 Balance neto SAF y Disponibilidada de nutrientes
    Widget _rowData( String tituloRow, double salida, double entrada ){
        return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Expanded(child: textList(tituloRow)),
                Container(
                    width: 65,
                    child: Text(salida.toStringAsFixed(1), textAlign: TextAlign.center)
                ),
                Container(
                    width: 65,
                    child: Text(entrada.toStringAsFixed(1), textAlign: TextAlign.center)
                ),
                Container(
                    width: 65,
                    child: Text((entrada - salida).toStringAsFixed(1) == '-0.0' ? '0.0' : (entrada - salida).toStringAsFixed(1) , textAlign: TextAlign.center)
                ),
                
            ],
        );
    }

    Widget _rowDisponibilidad( String tituloRow, double salida, double entrada, double suelo){

        double balance = (entrada + suelo) - salida;

        return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Expanded(child: textList(tituloRow)),
                Container(
                    width: 65,
                    child: Text(salida.toStringAsFixed(1), textAlign: TextAlign.center)
                ),
                Container(
                    width: 65,
                    child: Text(entrada.toStringAsFixed(1), textAlign: TextAlign.center)
                ),
                Container(
                    width: 65,
                    child: Text(suelo.toStringAsFixed(1) == '-0.0' ? '0.0' : suelo.toStringAsFixed(1) , textAlign: TextAlign.center)
                ),
                Container(
                    width: 65,
                    child: Text(balance.toStringAsFixed(1) == '-0.0' ? '0.0' : balance.toStringAsFixed(1) , textAlign: TextAlign.center)
                ),
                
            ],
        );
    }

    Widget _balance(String tituloBalance, String tituloDisponibilidad, Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas, SueloNutriente? sueloNutriente){
    
        return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                color: Colors.white,
                child: Column(
                    children: [
                        tituloDivider(tituloBalance),
                        Column(
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Expanded(child: textList('lb/año')),
                                        Container(
                                            width: 65,
                                            child: titleList('Salida'),
                                        ),
                                        Container(
                                            width: 65,
                                            child: titleList('Entrada'),
                                        ),
                                        Container(
                                            width: 65,
                                            child: titleList('Balance'),
                                        ),
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
                        SizedBox(height: 10,),
                        tituloDivider(tituloDisponibilidad),
                        Column(
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Expanded(child: textList('lb/año')),
                                        Container(
                                            width: 65,
                                            child: titleList('Salida'),
                                        ),
                                        Container(
                                            width: 65,
                                            child: titleList('Entrada'),
                                        ),
                                        Container(
                                            width: 65,
                                            child: titleList('Suelo'),
                                        ),
                                        Container(
                                            width: 65,
                                            child: titleList('Balance'),
                                        ),
                                    ],
                                ),
                                Divider(),
                                _rowDisponibilidad(
                                    'Nitrogeno', 
                                    calculos.salidaElemeto(salidaNutriente, 'N'),                                                        
                                    calculos.entradaElemento(entradas, sueloNutriente, 'N', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'N'),
                                ),
                                Divider(),
                                _rowDisponibilidad(
                                    'Fósforo', 
                                    calculos.salidaElemeto(salidaNutriente, 'P'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'P', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'P'),
                                ),
                                Divider(),
                                _rowDisponibilidad(
                                    'Potasio',
                                    calculos.salidaElemeto(salidaNutriente, 'K'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'K', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'K'),
                                ),
                                Divider(),
                                _rowDisponibilidad(
                                    'Calcio', 
                                    calculos.salidaElemeto(salidaNutriente, 'Ca'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'Ca', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'Ca'),
                                ),
                                Divider(),
                                _rowDisponibilidad(
                                    'Magnesio', 
                                    calculos.salidaElemeto(salidaNutriente, 'Mg'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'Mg', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'Mg'),
                                ),
                                Divider(),
                                _rowDisponibilidad(
                                    'Azufre', 
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
        );
            
    }

    
    //Pagina de Conteo de puntos
    Widget _labelTipo(int tipo){
        
        return  Column(
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: titleList('')),
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

        prueba.add(tituloDivider(titulo));
        prueba.add(_labelTipo(tipo));

        for (var item in preguntaItem) {
            
            prueba.add(
                 Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Text(item['label'], style: Theme.of(context).textTheme.headline6!
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

    Widget _recorrido(TestSuelo suelo,List<Punto>? puntos){
    
        return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15),
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
        );
            
    }


    //Pagina de Acciones
    Widget _accionesMeses(List<Acciones> listAcciones){
        List<Widget> listPrincipales =  [];

        listPrincipales.add( tituloDivider('Nueva propuesta de manejo de suelo'));
        
        
        for (var item in listAcciones) {

                List<String?> meses = [];
                String? label= listSoluciones.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];
                List listaMeses = jsonDecode(item.repuesta!);
                if (listaMeses.length==0) {
                    meses.add('Sin aplicar');
                }
                for (var item in listaMeses) {
                    String? mes = _meses.firstWhere((e) => e['value'] == '$item', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    meses.add(mes);
                }
                

                listPrincipales.add(

                    ListTile(
                        title: textList('$label'),
                        subtitle: Text(meses.join(","+" ")),
                    )                 
                    
                );
            
            
            
            
        }
        return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                color: Colors.white,
                child: Column(children:listPrincipales,)
            ),
        );
    }



}

