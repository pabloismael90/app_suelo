import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/finca_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
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

class _DecisionesPageState extends State<DecisionesPage> {

    Size size;

    @override
    Widget build(BuildContext context) {

        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        size = MediaQuery.of(context).size;

        Future _getdataFinca() async{
            Finca finca = await DBProvider.db.getFincaId(suelo.idFinca);
            Parcela parcela = await DBProvider.db.getParcelaId(suelo.idLote);
            SalidaNutriente salidaNutriente = await DBProvider.db.getSalidaNutrientes(suelo.id);
            List<EntradaNutriente> entradas = await DBProvider.db.getEntradas(suelo.id);
            return [finca, parcela, salidaNutriente, entradas];
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

                    pageItem.add(_salidaData(finca, parcela, salidaNutriente, entradas));

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
    
    Widget _titulosForm(String titulo){
        return Flexible(
            child: Container(
                width: size.width * 0.4,
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

    Widget _salidaData(Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas){
    
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
                                                                "Porcentaje de cobertura",
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
                                                            _titulosForm('Kg/año'),
                                                            _titulosForm('Salida'),
                                                            _titulosForm('Entrada'),
                                                            _titulosForm('Balance'),
                                                        ],
                                                    ),
                                                    Divider(),
                                                    _rowData('Nitrogeno', calculos.salidaNitrogeno(salidaNutriente), calculos.entradaNitrogeno(entradas)),
                                                    Divider(),
                                                    _rowData('Fósforo', calculos.salidaFosforo(salidaNutriente), 0),
                                                    Divider(),
                                                    _rowData('Potasio', calculos.salidaPotasio(salidaNutriente), 0),
                                                    Divider(),
                                                    _rowData('Calcio', calculos.salidaCalcio(salidaNutriente), 0),
                                                    Divider(),
                                                    _rowData('Magnesio', calculos.salidaMagnesio(salidaNutriente), 0),
                                                    Divider(),
                                                    _rowData('Azufre', calculos.salidaAzufre(salidaNutriente), 0),
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
                _titulosForm(tituloRow),
                Flexible(
                    child: Container(
                        width: size.width * 0.4,
                        child: Text(salida.toStringAsFixed(1), textAlign: TextAlign.center)
                    ),
                ),
                Flexible(
                    child: Container(
                        width: size.width * 0.4,
                        child: Text('0.0', textAlign: TextAlign.center)
                    ),
                ),
                Flexible(
                    child: Container(
                        width: size.width * 0.4,
                        child: Text('0.0', textAlign: TextAlign.center)
                    ),
                ),
                
            ],
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