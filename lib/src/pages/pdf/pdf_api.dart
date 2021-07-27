
import 'dart:convert';
import 'dart:io';

import 'package:app_suelo/src/models/acciones_model.dart';
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:app_suelo/src/utils/calculos.dart' as calculos;
import 'package:pdf/widgets.dart' as pw;

import 'package:pdf/widgets.dart';

class PdfApi {
    

    static Future<File> generateCenteredText(
        TestSuelo? suelo,
        Map? recorrido,
    
    ) async {
        final pdf = pw.Document();
        final font = pw.Font.ttf(await rootBundle.load('assets/fonts/Museo/Museo300.ttf'));
        Finca? finca = await DBProvider.db.getFincaId(suelo!.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(suelo.idLote);
        List<EntradaNutriente> abonosActual = await DBProvider.db.getEntradas(suelo.id, 1);
        List<EntradaNutriente> abonosPropuesto = await DBProvider.db.getEntradas(suelo.id, 2);
        SalidaNutriente salidaNutriente = await DBProvider.db.getSalidaNutrientes(suelo.id);
        SueloNutriente sueloNutriente = await DBProvider.db.getSueloNutrientes(suelo.id);
        List<Acciones> listAcciones= await DBProvider.db.getAccionesIdTest(suelo.id);

        String? labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca!.tipoMedida}')['label'];
        String? labelvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela!.variedadCacao}')['label'];

        
        final List<Map<String, dynamic>>?  _meses = selectMap.listMeses();
        final List<Map<String, dynamic>>?  listSoluciones = selectMap.solucionesXmes();

        pdf.addPage(
            
            pw.MultiPage(
                pageFormat: PdfPageFormat.a4,
                build: (context) => <pw.Widget>[
                    _encabezado('Datos de finca', font),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                    _textoBody('Finca: ${finca!.nombreFinca}', font),
                                    _textoBody('Parcela: ${parcela!.nombreLote}', font),
                                    _textoBody('Productor: ${finca.nombreProductor}', font),
                                    finca.nombreTecnico != '' ?
                                    _textoBody('Técnico: ${finca.nombreTecnico}', font)
                                    : pw.Container(),

                                    _textoBody('Variedad: $labelvariedad', font),


                                ]
                            ),
                            pw.Container(
                                padding: pw.EdgeInsets.only(left: 40),
                                child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                        _textoBody('Área Finca: ${finca.areaFinca} ($labelMedidaFinca)', font),
                                        _textoBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)', font),
                                        _textoBody('N de plantas: ${parcela.numeroPlanta}', font),                    
                                        _textoBody('Fecha: ${suelo.fechaTest}', font),                    
                                    ]
                                ),
                            )
                        ]
                    ),
                    pw.SizedBox(height: 20),
                    _datosSueloCosecha(salidaNutriente, sueloNutriente, font),
                    pw.SizedBox(height: 20),
                    _listaAbonos('Uso de abono actual', abonosActual, parcela, font),
                    pw.SizedBox(height: 20),
                    _balance('Balance neto del Sistema SAF actual', 'Disponibilidad de nutriente actual',finca,parcela,salidaNutriente,abonosActual,sueloNutriente, font),
                    pw.SizedBox(height: 20),
                    _listaAbonos('Propuesta de fertilización', abonosPropuesto, parcela, font),
                    pw.SizedBox(height: 20),
                    _balance('Propuesta Balance neto del Sistema SAF', 'Propuesta disponibilidad de nutriente',finca,parcela,salidaNutriente,abonosPropuesto,sueloNutriente, font),
                    pw.SizedBox(height: 20),
                    _filasRecorrido(recorrido, font),              
                    pw.SizedBox(height: 20),
                    _accionesMeses(listAcciones, listSoluciones, _meses, font) 
                    
                ],
                footer: (context) {
                    final text = 'Page ${context.pageNumber} of ${context.pagesCount}';

                    return Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(top: 1 * PdfPageFormat.cm),
                        child: Text(
                            text,
                            style: TextStyle(color: PdfColors.black, font: font),
                        ),
                    );
                },
            )
        
        );

        return saveDocument(name: 'Reporte ${finca!.nombreFinca} ${suelo.fechaTest}.pdf', pdf: pdf);
    }

    static Future<File> saveDocument({
        required String name,
        required pw.Document pdf,
    }) async {
        final bytes = await pdf.save();

        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$name');

        await file.writeAsBytes(bytes);

        return file;
    }

    static Future openFile(File file) async {
        final url = file.path;

        await OpenFile.open(url);
    }

    static pw.Widget _encabezado(String? titulo, pw.Font fuente){
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
                pw.Text(
                    titulo as String,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: fuente)
                ),
                pw.Divider(color: PdfColors.black),
            
            ]
        );

    }

    static pw.Widget _textoBody(String? contenido, pw.Font fuente){
        return pw.Container(
            padding: pw.EdgeInsets.symmetric(vertical: 3),
            child: pw.Text(contenido as String,style: pw.TextStyle(fontSize: 12, font: fuente))
        );

    }
 
    static pw.TableRow _crearFila(List data, Font font, bool fondo){
        List<Widget> celdas = [];

        for (var item in data) {
            celdas.add(_cellText('$item', font));
        }
        
        return pw.TableRow(children: celdas,decoration: pw.BoxDecoration(color: fondo ? PdfColors.grey300 : PdfColors.white));

    }

    static pw.Widget _cellText( String texto, pw.Font font){
        return pw.Container(
            padding: pw.EdgeInsets.all(5),
            child: pw.Text(texto,
                style: pw.TextStyle(font: font,)
            )
        );
    }

    static pw.Widget _datosSueloCosecha( SalidaNutriente salidaNutriente, SueloNutriente sueloNutriente, pw.Font font ){

        String? textura = selectMap.texturasSuelo().firstWhere((e) => e['value'] == '${sueloNutriente.textura}')['label'];
        String? tipoSuelo = selectMap.tiposSuelo().firstWhere((e) => e['value'] == '${sueloNutriente.tipoSuelo}')['label'];
        
        return pw.Column(
            children: [
                _encabezado('Análisis de suelo', font),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                                _textoBody('pH: ${sueloNutriente.ph} QQ / año',font ),
                                _textoBody('Densidad Aparente: ${sueloNutriente.densidadAparente} g/cm3',font ),
                                _textoBody('Materia orgánica: ${sueloNutriente.materiaOrganica} %',font ),
                                _textoBody('Nitrógeno: ${sueloNutriente.nitrogeno} %',font ),
                                _textoBody('Fósforo: ${sueloNutriente.fosforo} ppm',font ),
                                _textoBody('Potasio: ${sueloNutriente.potasio} meq/100g',font ),
                                _textoBody('Azufre: ${sueloNutriente.calcio} Carga',font ),
                                _textoBody('Calcio: ${sueloNutriente.magnesio} meq/100g',font ),
                                _textoBody('Magnesio: ${sueloNutriente.azufre} meq/100g',font ), 
                                


                            ]
                        ),
                        pw.Container(
                            padding: pw.EdgeInsets.only(left: 40),
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                    _textoBody('Hierro: ${sueloNutriente.hierro} ppm',font ),              
                                    _textoBody('Manganeso: ${sueloNutriente.manganeso} ppm',font ),              
                                    _textoBody('Cadmio: ${sueloNutriente.cadmio} ppm',font ),              
                                    _textoBody('Zinc: ${sueloNutriente.zinc} ppm',font ),              
                                    _textoBody('Boro: ${sueloNutriente.boro} ppm',font ),              
                                    _textoBody('Acidez intercambiable: ${sueloNutriente.acidez} Cmol+/kg',font ),              
                                    _textoBody('Leña: $textura',font ),             
                                    _textoBody('Leña: $tipoSuelo',font ),             
                                ]
                            ),
                        )
                    ]
                ),
                pw.SizedBox(height: 20),
                _encabezado('Cosecha anual', font),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                                _textoBody('Cacao baba: ${salidaNutriente.cacao} QQ / año',font ),
                                _textoBody('Cascara de cacao: ${salidaNutriente.cascaraCacao == 0 ? salidaNutriente.cacao : 0} QQ de grano',font ),
                                _textoBody('Leña: ${salidaNutriente.lena} Carga',font ),
                                


                            ]
                        ),
                        pw.Container(
                            padding: pw.EdgeInsets.only(left: 40),
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                    _textoBody('Frutas: ${salidaNutriente.fruta} Sacos',font ),
                                    _textoBody('Madera: ${salidaNutriente.madera} Pie tablar',font ),                 
                                ]
                            ),
                        )
                    ]
                ),
                
                
            ]
        );
    }


    //Lista de abonos
    static pw.Widget _listaAbonos( String titulo, List<EntradaNutriente> listAbonos,Parcela parcela, pw.Font font){
        List<pw.Widget> listaColumnas = [];


        listAbonos.forEach((abono) {
            String labelAbono = selectMap.listAbonos().firstWhere((e) => e['value'] == '${abono.idAbono}', orElse: () => {"value": "1","label": "No data"})['label'];
            String? unidad = selectMap.unidadAbono().firstWhere((e) => e['value'] == '${abono.unidad}', orElse: () => {"value": "1","label": "No data"})['label'];
            String montoUnidad = unidad!.split("/")[0];
            listaColumnas.add(_encabezado(titulo,font));
            listaColumnas.add(
                pw.Container(
                    padding: pw.EdgeInsets.symmetric(vertical: 5),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                            _textoBody('Nombre abono: $labelAbono', font),
                            pw.Wrap(
                                spacing: 20,
                                children: [
                                    _textoBody('Humedad (%) : ${abono.humedad} % ', font),
                                    _textoBody('Cantidad: ${abono.cantidad} $unidad', font),
                                    _textoBody('Frecuencia: ${abono.frecuencia}', font),
                                    _textoBody('Monto total: ${abono.cantidad! * abono.frecuencia! * parcela.numeroPlanta!} $montoUnidad', font),

                                ],
                            ),
                            pw.Divider(color: PdfColors.grey200)
                        ] 
                    )
                )
            );
        });

        return pw.Column(
            children: listaColumnas
        );
    }


    //Balances
    static pw.TableRow _crearFilaBalance(String titulo, double? salida, double? entrada, Font font){
        List<Widget> celdas = [];
        double? balance = entrada! - salida!;

        celdas.add(_cellText('$titulo', font));
        celdas.add(_cellText('${salida.toStringAsFixed(1)}', font));
        celdas.add(_cellText('${entrada.toStringAsFixed(1)}', font));
        celdas.add(_cellText('${balance.toStringAsFixed(1)}', font));
        
        
        return pw.TableRow(children: celdas);

    }

    static pw.TableRow _crearFilaDisponibilidad(String titulo, double? salida, double? entrada, double? suelo, Font font){
        List<Widget> celdas = [];
        double balance = (entrada! + suelo!) - salida!;

        celdas.add(_cellText('$titulo', font));
        celdas.add(_cellText('${salida.toStringAsFixed(1)}', font));
        celdas.add(_cellText('${entrada.toStringAsFixed(1)}', font));
        celdas.add(_cellText('${suelo.toStringAsFixed(1)}', font));
        celdas.add(_cellText('${balance.toStringAsFixed(1)}', font));
        
        
        return pw.TableRow(children: celdas);

    }

    static pw.Widget _balance(String tituloBalance, String tituloDisponibilidad, Finca finca, Parcela parcela, SalidaNutriente salidaNutriente, List<EntradaNutriente> entradas, SueloNutriente? sueloNutriente, Font font){

        return Column(
                    children: [
                        _encabezado(tituloBalance, font),
                        pw.Table(
                            columnWidths: const <int, TableColumnWidth>{
                                0: FlexColumnWidth(),
                                1:FixedColumnWidth(65),
                                2:FixedColumnWidth(65),
                                3:FixedColumnWidth(65),
                            },
                            border: TableBorder.all(),
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                                _crearFila(['lb/año', 'Salida', 'Entrada', 'Balance'], font, true),
                                _crearFilaBalance(
                                    'Nitrogeno',
                                    calculos.salidaElemeto(salidaNutriente, 'N'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'N', parcela),
                                    font
                                ),
                                _crearFilaBalance(
                                    'Fósforo',
                                    calculos.salidaElemeto(salidaNutriente, 'P'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'P', parcela),
                                    font
                                ),
                                _crearFilaBalance(
                                    'Potasio',
                                    calculos.salidaElemeto(salidaNutriente, 'K'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'K', parcela),
                                    font
                                ),
                                _crearFilaBalance(
                                    'Calcio',
                                    calculos.salidaElemeto(salidaNutriente, 'Ca'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'Ca', parcela),
                                    font
                                ),
                                _crearFilaBalance(
                                    'Magnesio',
                                    calculos.salidaElemeto(salidaNutriente, 'Mg'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'Mg', parcela),
                                    font
                                ),
                                _crearFilaBalance(
                                    'Azufre',
                                    calculos.salidaElemeto(salidaNutriente, 'S'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'S', parcela),
                                    font
                                ),

                            ]   
                        ),
                        SizedBox(height: 10,),
                        _encabezado(tituloDisponibilidad, font),
                        pw.Table(
                            columnWidths: const <int, TableColumnWidth>{
                                0: FlexColumnWidth(),
                                1:FixedColumnWidth(65),
                                2:FixedColumnWidth(65),
                                3:FixedColumnWidth(65),
                                4:FixedColumnWidth(65),
                            },
                            border: TableBorder.all(),
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                                _crearFila(['lb/año', 'Salida', 'Entrada', 'Suelo',  'Balance'], font, true),
                                _crearFilaDisponibilidad(
                                    'Nitrogeno',
                                    calculos.salidaElemeto(salidaNutriente, 'N'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'N', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'N'),
                                    font,
                                ),
                                _crearFilaDisponibilidad(
                                    'Fósforo',
                                    calculos.salidaElemeto(salidaNutriente, 'P'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'P', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'P'),
                                    font,
                                ),
                                _crearFilaDisponibilidad(
                                    'Potasio',
                                    calculos.salidaElemeto(salidaNutriente, 'K'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'K', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'K'),
                                    font,
                                ),
                                _crearFilaDisponibilidad(
                                    'Calcio',
                                    calculos.salidaElemeto(salidaNutriente, 'Ca'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'Ca', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'Ca'),
                                    font,
                                ),
                                _crearFilaDisponibilidad(
                                    'Magnesio',
                                    calculos.salidaElemeto(salidaNutriente, 'Mg'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'Mg', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'Mg'),
                                    font,
                                ),
                                _crearFilaDisponibilidad(
                                    'Azufre',
                                    calculos.salidaElemeto(salidaNutriente, 'S'),
                                    calculos.entradaElemento(entradas, sueloNutriente, 'S', parcela),
                                    calculos.nutrienteSuelo(sueloNutriente, 'S'),
                                    font,
                                ),

                            ]   
                        ),
                    ],
                );
            
    }


    //Conteo de puntos
    static pw.TableRow _labelTipo(String titulo, int tipo, Font font){
        
        return  _crearFila([titulo, 'No', tipo == 1 ? 'Algo' : 'Mala', tipo == 1 ? 'Severo' : 'Buena'], font, true);
    }

    static pw.Widget _filasRecorrido(Map? recorrido, Font font){
        List<pw.Widget> listaColumnas = [];
        listaColumnas.add(_encabezado('Recorrido de parcela',font));
        
        recorrido!.forEach((key, value) {
            List<pw.TableRow> filas = [];
            filas.add(_labelTipo(key,1,font));
            
            for (var item in value) {
                filas.add(_crearFila(item,font,false));
            }
            listaColumnas.add(
                pw.Table(
                    columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1:FixedColumnWidth(65),
                        2:FixedColumnWidth(65),
                        3:FixedColumnWidth(65),
                    },
                    border: TableBorder.all(),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: filas   
                )
            );
            listaColumnas.add(pw.SizedBox(height: 20));

        });
        
        return pw.Column(
            children: listaColumnas
        );

    }


    static pw.Widget _accionesMeses( List<Acciones>? listAcciones, List<Map<String, dynamic>>?  listSoluciones, List<Map<String, dynamic>>?  _meses, Font font){
        List<pw.Widget> listPrincipales = [];

        listPrincipales.add(_encabezado('¿Qué acciones vamos a realizar y cuando?', font));
        
        
        for (var item in listAcciones!) {

                List<String?> meses = [];
                
                String? label= listSoluciones!.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];
                List listaMeses = jsonDecode(item.repuesta!);
                if (listaMeses.length==0) {
                    meses.add('Sin aplicar');
                }
                for (var item in listaMeses) {
                    String? mes = _meses!.firstWhere((e) => e['value'] == '$item', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    meses.add(mes);
                }
                

                listPrincipales.add(
                    pw.Column(
                        children: [
                            _textoBody('$label : ${meses.join(","+" ")}', font),
                            pw.SizedBox(height: 10)
                        ]
                    )
                                    
                    
                );
            
            
            
            
        }
        return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children:listPrincipales);
    }






}


