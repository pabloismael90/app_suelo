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

class DecisionesPage extends StatefulWidget {
  DecisionesPage({Key key}) : super(key: key);

  @override
  _DecisionesPageState createState() => _DecisionesPageState();
}

Future<double> _count(String idTest,int idPregunta, int idItem, int repuesta) async{
    double countPalga = await DBProvider.db.countPunto(idTest,idPregunta, idItem, repuesta);

    return (countPalga/5)*100;
}

class _DecisionesPageState extends State<DecisionesPage> {

    Size size;

    @override
    Widget build(BuildContext context) {

        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        size = MediaQuery.of(context).size;

        Future _getdataFinca() async{
            Finca finca = await DBProvider.db.getFincaId(suelo.idFinca);
            Parcela parcela = await DBProvider.db.getParcelaId(suelo.idLote);
            List<Punto> puntos = await DBProvider.db.getPuntosIdTest(suelo.id);
            SalidaNutriente salidaNutriente = await DBProvider.db.getSalidaNutrientes(suelo.id);
            List<EntradaNutriente> entradas = await DBProvider.db.getEntradas(suelo.id);
            SueloNutriente sueloNutriente = await DBProvider.db.getSueloNutrientes(suelo.id);
            return [finca, parcela, salidaNutriente, entradas, sueloNutriente, puntos];
        }


        return Scaffold(
            appBar: AppBar(),
            body: FutureBuilder(
            future:  _getdataFinca(),
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

                    pageItem.add(_balanceNeto(finca, parcela, salidaNutriente, entradas, sueloNutriente));
                    pageItem.add(_disponibilidad(finca, parcela, salidaNutriente, entradas, sueloNutriente));
                    pageItem.add(_recorrido(suelo, puntos));

                    return Column(
                        children: [
                            Container(
                                child: Column(
                                    children: [
                                        TitulosPages(titulo: 'Toma de Decisiones'),
                                        Divider(),
                                        Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: Row(
                                          
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                    Container(
                                                        width: 200,
                                                        child: Text(
                                                                "Deslice hacia la derecha para continuar con el formulario",
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
                .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
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



    Widget _balanceNeto(Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas, SueloNutriente sueloNutriente){
    
        return Container(
            decoration: BoxDecoration(
                
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                    _dataFincas( context, finca, parcela),

                    Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                                color: Colors.white,
                                child: Column(
                                    children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: InkWell(
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                        Container(                                                                    
                                                            child: Text(
                                                                "Balance neto del Sistema SAF",
                                                                textAlign: TextAlign.center,
                                                                style: Theme.of(context).textTheme
                                                                    .headline5
                                                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                                                            ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.only(left: 10),
                                                            child: Icon(
                                                                Icons.info_outline_rounded,
                                                                color: Colors.green,
                                                                size: 22.0,
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                onTap: () => _dialogText(context),
                                            ),
                                        ),
                                        
                                        Container(
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
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'N')
                                                    ),
                                                    Divider(),
                                                    _rowData(
                                                        'Fósforo', 
                                                        calculos.salidaElemeto(salidaNutriente, 'P'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'P')
                                                    ),
                                                    Divider(),
                                                    _rowData(
                                                        'Potasio',
                                                        calculos.salidaElemeto(salidaNutriente, 'K'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'K')
                                                    ),
                                                    Divider(),
                                                    _rowData(
                                                        'Calcio', 
                                                        calculos.salidaElemeto(salidaNutriente, 'Ca'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'Ca')
                                                    ),
                                                    Divider(),
                                                    _rowData(
                                                        'Magnesio', 
                                                        calculos.salidaElemeto(salidaNutriente, 'Mg'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'Mg')
                                                    ),
                                                    Divider(),
                                                    _rowData(
                                                        'Azufre', 
                                                        calculos.salidaElemeto(salidaNutriente, 'S'), 
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'S')
                                                    ),
                                                    Divider(),
                                                    
                                                ],
                                            ),
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



    Widget _disponibilidad(Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas, SueloNutriente sueloNutriente){
    
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
                                child: Column(
                                    children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: InkWell(
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                        Container(                                                                    
                                                            child: Text(
                                                                "Disponibilidad de nutriente",
                                                                textAlign: TextAlign.center,
                                                                style: Theme.of(context).textTheme
                                                                    .headline5
                                                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                                                            ),
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.only(left: 10),
                                                            child: Icon(
                                                                Icons.info_outline_rounded,
                                                                color: Colors.green,
                                                                size: 22.0,
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                onTap: () => _dialogText(context),
                                            ),
                                        ),
                                        
                                        Container(
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
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'N'),
                                                        calculos.nutrienteSuelo(sueloNutriente, 'N'),
                                                    ),
                                                    Divider(),
                                                    _rowDisponibilidad(
                                                        'P', 
                                                        calculos.salidaElemeto(salidaNutriente, 'P'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'P'),
                                                        calculos.nutrienteSuelo(sueloNutriente, 'P'),
                                                    ),
                                                    Divider(),
                                                    _rowDisponibilidad(
                                                        'K',
                                                        calculos.salidaElemeto(salidaNutriente, 'K'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'K'),
                                                        calculos.nutrienteSuelo(sueloNutriente, 'K'),
                                                    ),
                                                    Divider(),
                                                    _rowDisponibilidad(
                                                        'Ca', 
                                                        calculos.salidaElemeto(salidaNutriente, 'Ca'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'Ca'),
                                                        calculos.nutrienteSuelo(sueloNutriente, 'Ca'),
                                                    ),
                                                    Divider(),
                                                    _rowDisponibilidad(
                                                        'Mg', 
                                                        calculos.salidaElemeto(salidaNutriente, 'Mg'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'Mg'),
                                                        calculos.nutrienteSuelo(sueloNutriente, 'Mg'),
                                                    ),
                                                    Divider(),
                                                    _rowDisponibilidad(
                                                        'S', 
                                                        calculos.salidaElemeto(salidaNutriente, 'S'), 
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'S'),
                                                        calculos.nutrienteSuelo(sueloNutriente, 'S'),
                                                    ),
                                                    Divider(),
                                                    
                                                ],
                                            ),
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
                                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
                        Container(
                            width: 60,
                            child: Text('No', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600,) ),
                        ),
                        Container(
                            width: 60,
                            child: Text(tipo == 1 ? 'Algo' : 'Mala', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600,) ),
                        ),
                        Container(
                            width: 60,
                            child: Text(tipo == 1 ? 'Severo' : 'Buena', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
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
                                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
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
                                            
                                            _rowRecorrido(suelo.id, 2, 'Obras de conservación de suelo', 2, selectMap.conservacion())
                                            
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


Future<void> _dialogText(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Titulo'),
                content: SingleChildScrollView(
                    child: ListBody(
                        children: <Widget>[
                        Text('Texto para breve explicacion'),
                        ],
                    ),
                ),
                actions: <Widget>[
                    TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                        Navigator.of(context).pop();
                        },
                    ),
                ],
            );
        },
    );
}