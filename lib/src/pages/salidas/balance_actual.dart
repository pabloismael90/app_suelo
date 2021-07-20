
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:app_suelo/src/utils/calculos.dart' as calculos;
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class BalanceActual extends StatefulWidget {
  BalanceActual({Key? key}) : super(key: key);

  @override
  _BalanceActualState createState() => _BalanceActualState();
}

class _BalanceActualState extends State<BalanceActual> {

    late Size size;

    Future _getdataFinca( TestSuelo suelo, int tipo ) async{
            

            Finca? finca = await DBProvider.db.getFincaId(suelo.idFinca);
            Parcela? parcela = await DBProvider.db.getParcelaId(suelo.idLote);
            SalidaNutriente salidaNutriente = await DBProvider.db.getSalidaNutrientes(suelo.id);
            List<EntradaNutriente> entradas = await DBProvider.db.getEntradas(suelo.id, tipo);
            SueloNutriente sueloNutriente = await DBProvider.db.getSueloNutrientes(suelo.id);
            
            return [finca, parcela, salidaNutriente, entradas, sueloNutriente];
        }

    @override
    Widget build(BuildContext context) {

        List dataRoute = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
        TestSuelo suelo = dataRoute[0];
        String titulo = dataRoute[1];
        int tipo = dataRoute[2];

        size = MediaQuery.of(context).size;

        return Scaffold(
            appBar: AppBar(),
            body: FutureBuilder(
            future:  _getdataFinca(suelo, tipo),
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

                    pageItem.add(_balanceNeto(finca, parcela, salidaNutriente, entradas, sueloNutriente));
                    pageItem.add(_disponibilidad('Disponibilidad de nutriente', finca, parcela, salidaNutriente, entradas, sueloNutriente));

                    return Column(
                        children: [
                            Container(
                                child: TitulosPages(titulo: titulo),
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


    //Balance neto SAF
    Widget _titulosForm(String titulo, double ancho){
        return Flexible(
            child: Container(
                width: ancho,
                child: Text(titulo, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6!
                .copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
        );
    }

    Widget _dataFincas( BuildContext context, Finca finca, Parcela parcela ){
        String? labelMedidaFinca;
        String? labelvariedad;

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

    Widget _balanceNeto(Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas, SueloNutriente? sueloNutriente){
    
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
                                                                    .headline5!
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
                                                            _titulosForm('lb/año', size.width * 0.4),
                                                            _titulosForm('Salida', size.width * 0.4),
                                                            _titulosForm('Entrada', size.width * 0.4),
                                                            _titulosForm('Balance', size.width * 0.4),
                                                        ],
                                                    ),
                                                    Divider(),
                                                    _rowBalance(
                                                        'Nitrogeno', 
                                                        calculos.salidaElemeto(salidaNutriente, 'N'),                                                        
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'N', parcela)
                                                    ),
                                                    Divider(),
                                                    _rowBalance(
                                                        'Fósforo', 
                                                        calculos.salidaElemeto(salidaNutriente, 'P'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'P', parcela)
                                                    ),
                                                    Divider(),
                                                    _rowBalance(
                                                        'Potasio',
                                                        calculos.salidaElemeto(salidaNutriente, 'K'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'K', parcela)
                                                    ),
                                                    Divider(),
                                                    _rowBalance(
                                                        'Calcio', 
                                                        calculos.salidaElemeto(salidaNutriente, 'Ca'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'Ca', parcela)
                                                    ),
                                                    Divider(),
                                                    _rowBalance(
                                                        'Magnesio', 
                                                        calculos.salidaElemeto(salidaNutriente, 'Mg'),
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'Mg', parcela)
                                                    ),
                                                    Divider(),
                                                    _rowBalance(
                                                        'Azufre', 
                                                        calculos.salidaElemeto(salidaNutriente, 'S'), 
                                                        calculos.entradaElemento(entradas, sueloNutriente, 'S', parcela)
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

    Widget _rowBalance( String tituloRow, double salida, double entrada ){
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


    //Disponibilidada de nutrientes
    Widget _disponibilidad(String titulo, Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas, SueloNutriente? sueloNutriente){
    
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
                                                                titulo,
                                                                textAlign: TextAlign.center,
                                                                style: Theme.of(context).textTheme
                                                                    .headline5!
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
                                                            _titulosForm('lb/año', size.width * 0.2),
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