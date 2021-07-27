
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/calculos.dart' as calculos;
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
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
                    String? labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}')['label'];

                    pageItem.add(_paginaUno(finca, parcela, salidaNutriente, labelMedidaFinca, entradas, tipo), );
                    pageItem.add(_paginaDos(finca, parcela, salidaNutriente, entradas, sueloNutriente, tipo));

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


    //Datos cosecha y abono
    Widget _paginaUno(Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, String? labelMedidaFinca, List<EntradaNutriente> listAbonosActual, int tipo){
        return Container(
            padding: EdgeInsets.all(15),
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
                    children: [
                        _dataFincas(finca, parcela, labelMedidaFinca!),
                        tituloDivider('Cosecha anual'),
                        _cosechaAnual(salidaNutriente),
                        tipo == 1 ? 
                        tituloDivider('Uso de abono actual')
                        :tituloDivider('Propuesta de fertilización'),
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
    
    
    //Balances actuales
    Widget _paginaDos(Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas, SueloNutriente? sueloNutriente, int tipo){
    
        return Container(
            padding: EdgeInsets.all(15),
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
                    children: [
                        tipo == 1 ? 
                        tituloDivider('Balance neto del Sistema SAF actual')
                        :tituloDivider('Propuesta balance neto del Sistema SAF'),
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
                        tipo == 1 ? 
                        tituloDivider('Disponibilidad de nutriente actual')
                        :tituloDivider('Propuesta disponibilidad de nutriente'),
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

    
}