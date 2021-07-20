import 'dart:io';


import 'package:app_suelo/src/models/acciones_model.dart';
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


import 'package:app_suelo/src/models/finca_model.dart';
export 'package:app_suelo/src/models/finca_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';

import '../models/punto_model.dart';
export 'package:app_suelo/src/models/parcela_model.dart';

class DBProvider {

    static Database? _database; 
    static final DBProvider db = DBProvider._();

    DBProvider._();

    Future<Database?> get database async {

        if ( _database != null ) return _database;

        _database = await initDB();
        return _database;
    }

    initDB() async {

        Directory documentsDirectory = await getApplicationDocumentsDirectory();

        final path = join( documentsDirectory.path, 'sueloHerramienta.db' );

        print(path);

        return await openDatabase(
            path,
            version: 2,
            onOpen: (db) {},
            onConfigure: _onConfigure,
            onCreate: ( Database db, int version ) async {
                await db.execute(
                    'CREATE TABLE Finca ('
                    ' id TEXT PRIMARY KEY,'
                    ' nombreFinca TEXT,'
                    ' nombreProductor TEXT,'
                    ' areaFinca REAL,'
                    ' tipoMedida INTEGER,'
                    ' nombreTecnico TEXT'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE Parcela ('
                    ' id TEXT PRIMARY KEY,'
                    ' idFinca TEXT,'
                    ' nombreLote TEXT,'
                    ' areaLote REAL,'
                    ' variedadCacao INTEGER,'
                    ' numeroPlanta INTEGER,'
                    'CONSTRAINT fk_parcela FOREIGN KEY(idFinca) REFERENCES Finca(id) ON DELETE CASCADE'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE TestSuelo ('
                    ' id TEXT PRIMARY KEY,'
                    ' idFinca TEXT,'
                    ' idLote TEXT,'
                    ' estaciones INTEGER,'
                    ' fechaTest TEXT,'
                    ' CONSTRAINT fk_fincaTest FOREIGN KEY(idFinca) REFERENCES Finca(id) ON DELETE CASCADE,'
                    ' CONSTRAINT fk_parcelaTest FOREIGN KEY(idLote) REFERENCES Parcela(id) ON DELETE CASCADE'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE Punto ('
                    'id TEXT PRIMARY KEY,'
                    ' idTest TEXT,'
                    ' nPunto INTEGER,'
                    ' idPregunta INTEGER,'
                    ' idItem INTEGER,'
                    ' repuesta INTEGER,'
                    ' CONSTRAINT fk_punto FOREIGN KEY(idTest) REFERENCES TestSuelo(id) ON DELETE CASCADE'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE salidaNutriente ('
                    'id TEXT PRIMARY KEY,'
                    ' idTest TEXT,'
                    ' cacao REAL,'
                    ' lena REAL,'
                    ' fruta REAL,'
                    ' musacea REAL,'
                    ' madera REAL,'
                    ' cascaraCacao REAL,'
                    ' CONSTRAINT fk_punto FOREIGN KEY(idTest) REFERENCES TestSuelo(id) ON DELETE CASCADE'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE entradaNutriente ('
                    'id TEXT PRIMARY KEY,'
                    ' idTest TEXT,'
                    ' idAbono INTEGER,'
                    ' humedad REAL,'
                    ' cantidad REAL,'
                    ' frecuencia INTEGER,'
                    ' unidad INTEGER,'
                    ' tipo INTEGER,'
                    ' CONSTRAINT fk_punto FOREIGN KEY(idTest) REFERENCES TestSuelo(id) ON DELETE CASCADE'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE sueloNutriente ('
                    'id TEXT PRIMARY KEY,'
                    ' idTest TEXT,'
                    ' ph REAL,'
                    ' densidadAparente REAL,'
                    ' materiaOrganica REAL,'
                    ' nitrogeno REAL,'
                    ' fosforo REAL,'
                    ' potasio REAL,'
                    ' azufre REAL,'
                    ' calcio REAL,'
                    ' magnesio REAL,'
                    ' hierro REAL,'
                    ' manganeso REAL,'
                    ' cadmio REAL,'
                    ' zinc REAL,'
                    ' boro REAL,'
                    ' acidez REAL,'
                    ' textura INTEGER,'
                    ' tipoSuelo INTEGER,'
                    ' CONSTRAINT fk_punto FOREIGN KEY(idTest) REFERENCES TestSuelo(id) ON DELETE CASCADE'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE Acciones ('
                    'id TEXT PRIMARY KEY,'
                    ' idItem INTEGER,'
                    ' repuesta TEXT,'
                    ' idTest TEXT,'
                    ' CONSTRAINT fk_acciones FOREIGN KEY(idTest) REFERENCES TestSuelo(id) ON DELETE CASCADE'
                    ')'
                );



               
            }
        
        );

    }

    static Future _onConfigure(Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
    }

    

    //ingresar Registros
    nuevoFinca( Finca nuevaFinca ) async {
        final db  = await (database);
        final res = await db!.insert('Finca',  nuevaFinca.toJson() );
        return res;
    }

    nuevoParcela( Parcela nuevaParcela ) async {
        final db  = await (database);
        final res = await db!.insert('Parcela',  nuevaParcela.toJson() );
        return res;
    }

    nuevoTestSuelo( TestSuelo nuevaPlaga ) async {
        final db  = await (database);
        final res = await db!.insert('TestSuelo',  nuevaPlaga.toJson() );
        return res;
    }
    
    nuevoPunto( Punto nuevaPunto ) async {
        final db  = await (database);
        final res = await db!.insert('Punto',  nuevaPunto.toJson() );
        return res;
    }
    
    nuevoSalida( SalidaNutriente nuevaSalida ) async {
        final db  = await (database);
        final res = await db!.insert('salidaNutriente',  nuevaSalida.toJson() );
        return res;
    }
    
    nuevoSueloAnalisis( SueloNutriente nuevaSuelo ) async {
        final db  = await (database);
        final res = await db!.insert('sueloNutriente',  nuevaSuelo.toJson() );
        return res;
    }

    nuevoEntrada( EntradaNutriente nuevoEntrada ) async {
        final db  = await (database);
        final res = await db!.insert('entradaNutriente',  nuevoEntrada.toJson() );
        return res;
    }

    nuevaAccion( Acciones acciones ) async {
        final db  = await (database);
        final res = await db!.insert('Acciones',  acciones.toJson() );
        return res;
    }






    
    
    //Obtener registros
    Future<List<Finca>> getTodasFincas() async {

        final db  = await (database);
        final res = await db!.query('Finca');

        List<Finca> list = res.isNotEmpty 
                                ? res.map( (c) => Finca.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<Parcela>> getTodasParcelas() async {

        final db  = await (database);
        final res = await db!.query('Parcela');

        List<Parcela> list = res.isNotEmpty 
                                ? res.map( (c) => Parcela.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<TestSuelo>> getTodasTestSuelo() async {

        final db  = await (database);
        final res = await db!.query('TestSuelo');

        List<TestSuelo> list = res.isNotEmpty 
                                ? res.map( (c) => TestSuelo.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<Acciones>> getTodasAcciones() async {

        final db  = await (database);
        final res = await db!.rawQuery('SELECT DISTINCT idTest FROM Acciones');

        List<Acciones> list = res.isNotEmpty 
                                ? res.map( (c) => Acciones.fromJson(c) ).toList()
                                : [];

        
        
        return list;
    }
    
    
    
    //REgistros por id
    Future<Finca?> getFincaId(String? id) async{
        final db = await (database);
        final res = await db!.query('Finca', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? Finca.fromJson(res.first) : null;
    }

    Future<Parcela?> getParcelaId(String? id) async{
        final db = await (database);
        final res = await db!.query('Parcela', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? Parcela.fromJson(res.first) : null;
    }

    Future<TestSuelo?> getTestId(String? id) async{
        final db = await (database);
        final res = await db!.query('TestSuelo', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? TestSuelo.fromJson(res.first) : null;
    }

    Future<List<Parcela>> getTodasParcelasIdFinca(String? idFinca) async{

        final db = await (database);
        final res = await db!.query('Parcela', where: 'idFinca = ?', whereArgs: [idFinca]);
        List<Parcela> list = res.isNotEmpty 
                    ? res.map( (c) => Parcela.fromJson(c) ).toList() 
                    : [];
        
        return list;            
    }

    Future<List<Punto>> getPuntosIdTest(String? idTest) async{

        final db = await (database);
        final res = await db!.rawQuery("SELECT * FROM Punto WHERE idTest = '$idTest' group by nPunto");
        List<Punto> list = res.isNotEmpty 
                    ? res.map( (c) => Punto.fromJson(c) ).toList() 
                    : [];
        return list;            
    }

    Future<SalidaNutriente> getSalidaNutrientes(String? idTest) async{
        SalidaNutriente salidaNutriente = SalidaNutriente();
        final db = await (database);
        final res = await db!.query('salidaNutriente', where: 'idTest = ?', whereArgs: [idTest]);
        return res.isNotEmpty ? SalidaNutriente.fromJson(res.first) : salidaNutriente;           
    }

    Future<SueloNutriente> getSueloNutrientes(String? idTest) async{
        SueloNutriente suelo = SueloNutriente();
        final db = await (database);
        final res = await db!.query('sueloNutriente', where: 'idTest = ?', whereArgs: [idTest]);
        return res.isNotEmpty ? SueloNutriente.fromJson(res.first) : suelo;          
    }

    Future<List<EntradaNutriente>> getEntradas(String? idTest, int? tipo) async{
        final db = await (database);
        final res = await db!.query('entradaNutriente', where: 'idTest = ? AND tipo = ?', whereArgs: [idTest, tipo]);
        List<EntradaNutriente> list = res.isNotEmpty 
                    ? res.map( (c) => EntradaNutriente.fromJson(c) ).toList() 
                    : [];
        
        return list;         
    }

    Future<List<Acciones>> getAccionesIdTest(String? idTest) async{
        final db = await (database);
        final res = await db!.query('Acciones', where: 'idTest = ?', whereArgs: [idTest]);
        List<Acciones> list = res.isNotEmpty 
                                ? res.map( (c) => Acciones.fromJson(c) ).toList()
                                : [];
        return list;
    }


    


    //List Select
    Future<List<Map<String, dynamic>>> getSelectFinca() async {
       
        final db  = await (database);
        final res = await db!.rawQuery(
            "SELECT id AS value, nombreFinca AS label FROM Finca"
        );
        List<Map<String, dynamic>> list = res.isNotEmpty ? res : [];

        //print(list);

        return list; 
    }
    
    Future<List<Map<String, dynamic>>> getSelectParcelasIdFinca(String idFinca) async{
        final db = await (database);
        final res = await db!.rawQuery(
            "SELECT id AS value, nombreLote AS label FROM Parcela WHERE idFinca = '$idFinca'"
        );
        List<Map<String, dynamic>> list = res.isNotEmpty ? res : [];

        return list;
                    
    }


    // Actualizar Registros
    Future<int> updateFinca( Finca nuevaFinca ) async {

        final db  = await (database);
        final res = await db!.update('Finca', nuevaFinca.toJson(), where: 'id = ?', whereArgs: [nuevaFinca.id] );
        return res;

    }

    Future<int> updateParcela( Parcela nuevaParcela ) async {

        final db  = await (database);
        final res = await db!.update('Parcela', nuevaParcela.toJson(), where: 'id = ?', whereArgs: [nuevaParcela.id] );
        return res;

    }

    Future<int> updateTestSuelo( TestSuelo nuevaPlaga ) async {

        final db  = await (database);
        final res = await db!.update('TestSuelo', nuevaPlaga.toJson(), where: 'id = ?', whereArgs: [nuevaPlaga.id] );
        return res;

    }

    Future<int> updateSalidaNutriente( SalidaNutriente nuevaSalida ) async {

        final db  = await (database);
        final res = await db!.update('salidaNutriente', nuevaSalida.toJson(), where: 'id = ?', whereArgs: [nuevaSalida.id] );
        return res;

    }

    Future<int> updateSueloNutriente( SueloNutriente nuevaSuelo ) async {

        final db  = await (database);
        final res = await db!.update('sueloNutriente', nuevaSuelo.toJson(), where: 'id = ?', whereArgs: [nuevaSuelo.id] );
        return res;

    }


    //Conteos analisis
    Future<double> countPunto( String? idTest,int idPregunta,int idItem, int repuesta ) async {


        final db = await (database);
        String query =  "SELECT COUNT(*) FROM Punto WHERE idTest = '$idTest' AND idPregunta = '$idPregunta' AND idItem = '$idItem' AND repuesta = '$repuesta'";
        double res = Sqflite.firstIntValue(await db!.rawQuery(query))! * 1.0;
        
        return res;

    }


   
    // Eliminar registros
    Future<int> deleteFinca( String? idFinca ) async {

        final db  = await (database);
        final res = await db!.delete('Finca', where: 'id = ?', whereArgs: [idFinca]);
        return res;
    }
    
    Future<int> deleteParcela( String? idParcela ) async {

        final db  = await (database);
        final res = await db!.delete('Parcela', where: 'id = ?', whereArgs: [idParcela]);
        return res;
    }

    Future<int> deleteTestSuelo( String? idTest ) async {

        final db  = await (database);
        final res = await db!.delete('TestSuelo', where: 'id = ?', whereArgs: [idTest]);
        return res;
    }

    Future<int> deletePunto( String? idTest, int? nPunto ) async {

        final db  = await (database);
        final res = await db!.delete('Punto', where: 'idTest = ? AND nPunto = ?', whereArgs: [idTest, nPunto]);
        return res;
    }

    Future<int> deleteEntrada( String? id) async {

        final db  = await (database);
        final res = await db!.delete('entradaNutriente', where: 'id = ?', whereArgs: [id]);
        return res;
    }


    Future<int> monitoreo( String? idTest ) async {
        int validacion = 0;
        final db  = await (database);
        final salidaNutriente = await db!.query('salidaNutriente', where: 'idTest = ?', whereArgs: [idTest]);
        final sueloNutriente = await db.query('sueloNutriente', where: 'idTest = ?', whereArgs: [idTest]);
        final entradaNutriente = await db.query('entradaNutriente', where: 'idTest = ? AND tipo = ?', whereArgs: [idTest, 1]);

        if (salidaNutriente.length > 0 && sueloNutriente.length > 0 && entradaNutriente.length > 0) {
            validacion = 1;
        }

        //print(validacion);
        return validacion;
    }

    Future<int> activateFerti( String? idTest ) async {
        int validacion = 0;
        final db  = await (database);
        final salidaNutriente = await db!.query('salidaNutriente', where: 'idTest = ?', whereArgs: [idTest]);
        final sueloNutriente = await db.query('sueloNutriente', where: 'idTest = ?', whereArgs: [idTest]);
        final entradaNutriente = await db.query('entradaNutriente', where: 'idTest = ? AND tipo = ?', whereArgs: [idTest, 1]);
        final puntos = await db.rawQuery("SELECT * FROM Punto WHERE idTest = '$idTest' group by nPunto");

        if (salidaNutriente.length > 0 && sueloNutriente.length > 0 && entradaNutriente.length > 0 && puntos.length > 4  ) {
            validacion = 1;
        }

        return validacion;
    }






}