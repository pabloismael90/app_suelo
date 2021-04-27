import 'dart:io';


import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


import 'package:app_suelo/src/models/finca_model.dart';
export 'package:app_suelo/src/models/finca_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';

import '../models/decisiones_model.dart';
export 'package:app_suelo/src/models/parcela_model.dart';

class DBProvider {

    static Database _database; 
    static final DBProvider db = DBProvider._();

    DBProvider._();

    Future<Database> get database async {

        if ( _database != null ) return _database;

        _database = await initDB();
        return _database;
    }

    initDB() async {

        Directory documentsDirectory = await getApplicationDocumentsDirectory();

        final path = join( documentsDirectory.path, 'herramienta.db' );

        //print(path);

        return await openDatabase(
            path,
            version: 1,
            onOpen: (db) {},
            onConfigure: _onConfigure,
            onCreate: ( Database db, int version ) async {
                await db.execute(
                    'CREATE TABLE Finca ('
                    ' id TEXT PRIMARY KEY,'
                    ' userid INTEGER,'
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
                    ' idPregunta INTEGER,'
                    ' idItem INTEGER,'
                    ' repuesta INTEGER,'
                    ' idTest TEXT,'
                    ' CONSTRAINT fk_punto FOREIGN KEY(idTest) REFERENCES TestSuelo(id) ON DELETE CASCADE'
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
        final db  = await database;
        final res = await db.insert('Finca',  nuevaFinca.toJson() );
        return res;
    }

    nuevoParcela( Parcela nuevaParcela ) async {
        final db  = await database;
        final res = await db.insert('Parcela',  nuevaParcela.toJson() );
        return res;
    }

    nuevoTestSuelo( TestSuelo nuevaPlaga ) async {
        final db  = await database;
        final res = await db.insert('TestSuelo',  nuevaPlaga.toJson() );
        return res;
    }
    nuevoPunto( Punto nuevaPunto ) async {
        final db  = await database;
        final res = await db.insert('Punto',  nuevaPunto.toJson() );
        return res;
    }



    
    
    //Obtener registros
    Future<List<Finca>> getTodasFincas() async {

        final db  = await database;
        final res = await db.query('Finca');

        List<Finca> list = res.isNotEmpty 
                                ? res.map( (c) => Finca.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<Parcela>> getTodasParcelas() async {

        final db  = await database;
        final res = await db.query('Parcela');

        List<Parcela> list = res.isNotEmpty 
                                ? res.map( (c) => Parcela.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<TestSuelo>> getTodasTestSuelo() async {

        final db  = await database;
        final res = await db.query('TestSuelo');

        List<TestSuelo> list = res.isNotEmpty 
                                ? res.map( (c) => TestSuelo.fromJson(c) ).toList()
                                : [];
        return list;
    }

    
    
    
    //REgistros por id
    Future<Finca> getFincaId(String id) async{
        final db = await database;
        final res = await db.query('Finca', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? Finca.fromJson(res.first) : null;
    }

    Future<Parcela> getParcelaId(String id) async{
        final db = await database;
        final res = await db.query('Parcela', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? Parcela.fromJson(res.first) : null;
    }

    Future<TestSuelo> getTestId(String id) async{
        final db = await database;
        final res = await db.query('TestSuelo', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? TestSuelo.fromJson(res.first) : null;
    }

    Future<List<Parcela>> getTodasParcelasIdFinca(String idFinca) async{

        final db = await database;
        final res = await db.query('Parcela', where: 'idFinca = ?', whereArgs: [idFinca]);
        List<Parcela> list = res.isNotEmpty 
                    ? res.map( (c) => Parcela.fromJson(c) ).toList() 
                    : [];
        
        return list;            
    }

    Future<List<Punto>> getPuntosIdTest(String idTest) async{

        final db = await database;
        final res = await db.query('Punto', where: 'idTest = ?', whereArgs: [idTest]);
        List<Punto> list = res.isNotEmpty 
                    ? res.map( (c) => Punto.fromJson(c) ).toList() 
                    : [];
        
        return list;            
    }

    


    //List Select
    Future<List<Map<String, dynamic>>> getSelectFinca() async {
       
        final db  = await database;
        final res = await db.rawQuery(
            "SELECT id AS value, nombreFinca AS label FROM Finca"
        );
        List<Map<String, dynamic>> list = res.isNotEmpty ? res : [];

        //print(list);

        return list; 
    }
    
    Future<List<Map<String, dynamic>>> getSelectParcelasIdFinca(String idFinca) async{
        final db = await database;
        final res = await db.rawQuery(
            "SELECT id AS value, nombreLote AS label FROM Parcela WHERE idFinca = '$idFinca'"
        );
        List<Map<String, dynamic>> list = res.isNotEmpty ? res : [];

        return list;
                    
    }


    // Actualizar Registros
    Future<int> updateFinca( Finca nuevaFinca ) async {

        final db  = await database;
        final res = await db.update('Finca', nuevaFinca.toJson(), where: 'id = ?', whereArgs: [nuevaFinca.id] );
        return res;

    }

    Future<int> updateParcela( Parcela nuevaParcela ) async {

        final db  = await database;
        final res = await db.update('Parcela', nuevaParcela.toJson(), where: 'id = ?', whereArgs: [nuevaParcela.id] );
        return res;

    }

    Future<int> updateTestSuelo( TestSuelo nuevaPlaga ) async {

        final db  = await database;
        final res = await db.update('TestSuelo', nuevaPlaga.toJson(), where: 'id = ?', whereArgs: [nuevaPlaga.id] );
        return res;

    }


    //Conteos analisis
   
    // Eliminar registros
    Future<int> deleteFinca( String idFinca ) async {

        final db  = await database;
        final res = await db.delete('Finca', where: 'id = ?', whereArgs: [idFinca]);
        return res;
    }
    Future<int> deleteParcela( String idParcela ) async {

        final db  = await database;
        final res = await db.delete('Parcela', where: 'id = ?', whereArgs: [idParcela]);
        return res;
    }

    Future<int> deleteTestSuelo( String idTest ) async {

        final db  = await database;
        final res = await db.delete('TestSuelo', where: 'id = ?', whereArgs: [idTest]);
        return res;
    }



}