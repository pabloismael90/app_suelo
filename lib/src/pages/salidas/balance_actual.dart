
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/calculos.dart' as calculos;
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
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
            appBar: AppBar(title: Text(titulo)),
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

    Widget _balanceNeto(Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas, SueloNutriente? sueloNutriente){
    
        return Container(
            decoration: BoxDecoration(
                
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                    _dataFincas(finca, parcela),

                    Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                    children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: InkWell(
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                        Container(                                                                    
                                                            child: Text(
                                                                "Balance neto del Sistema SAF",
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                                                            ),
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets.only(left: 10),
                                                            child: Icon(
                                                                Icons.info_outline_rounded,
                                                                color: Colors.green,
                                                                size: 20,
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                onTap: () => _dialogText(context),
                                            ),
                                        ),
                                        Divider(),
                                        Column(
                                            children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                        Expanded(
                                                            child: textList('lb/año'),
                                                        ),
                                                        Container(
                                                            width: 70,
                                                            child: titleList('Salida'),
                                                        ),
                                                        Container(
                                                            width: 70,
                                                            child: titleList('Entrada'),
                                                        ),
                                                        Container(
                                                            width: 70,
                                                            child: titleList('Balance'),
                                                        ),
                                                    ],
                                                ),
                                                Divider(),
                                                _rowBalance(
                                                    'Nitrógeno', 
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
                Expanded(
                    child:textList(tituloRow), 
                ),
                Container(
                    width: 70,
                    child: Text(salida.toStringAsFixed(1), textAlign: TextAlign.center,),
                ),
                Container(
                    width: 70,
                    child: Text(entrada.toStringAsFixed(1), textAlign: TextAlign.center,),
                ),
                Container(
                    width: 70,
                    child: Text((entrada - salida).toStringAsFixed(1) == '-0.0' ? '0.0' : (entrada - salida).toStringAsFixed(1), textAlign: TextAlign.center,),
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
                                padding: EdgeInsets.all(15),
                                child: Column(
                                    children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: InkWell(
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                        Container(                                                                    
                                                            child: Text(
                                                                titulo,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                                                            ),
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets.only(left: 10),
                                                            child: Icon(
                                                                Icons.info_outline_rounded,
                                                                color: Colors.green,
                                                                size: 20,
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                onTap: () => _dialogText(context),
                                            ),
                                        ),
                                        Column(
                                            children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                        Expanded(
                                                            child: textList('lb/año'),
                                                        ),
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
                                                    'Nitrógeno', 
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
                Expanded(
                    child:textList(tituloRow), 
                ),
                Container(
                    width: 65,
                    child: Text(salida.toStringAsFixed(1), textAlign: TextAlign.center,),
                ),
                Container(
                    width: 65,
                    child: Text(entrada.toStringAsFixed(1), textAlign: TextAlign.center,),
                ),
                Container(
                    width: 65,
                    child: Text(suelo.toStringAsFixed(1) == '-0.0' ? '0.0' : suelo.toStringAsFixed(1), textAlign: TextAlign.center,),
                ),
                Container(
                    width: 65,
                    child: Text(balance.toStringAsFixed(1) == '-0.0' ? '0.0' : balance.toStringAsFixed(1), textAlign: TextAlign.center,),
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