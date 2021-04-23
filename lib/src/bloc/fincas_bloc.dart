
import 'dart:async';

import 'package:app_suelo/src/models/decisiones_model.dart';
import 'package:app_suelo/src/models/planta_model.dart';
import 'package:app_suelo/src/models/testplaga_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';

class FincasBloc {

    static final FincasBloc _singleton = new FincasBloc._internal();

    factory FincasBloc() {
        return _singleton;
        
    }

    FincasBloc._internal() {
        obtenerFincas();
        obtenerParcelas();
    }

    final _fincasController = StreamController<List<Finca>>.broadcast();
    final _parcelasController = StreamController<List<Parcela>>.broadcast();
    final _plagaController = StreamController<List<Testplaga>>.broadcast();
    final _plantaController = StreamController<List<Planta>>.broadcast();
    final _countPlantaControl = StreamController<List<Planta>>.broadcast();
    final _decisionesControl = StreamController<List<Decisiones>>.broadcast();
    

    final _fincasSelectControl = StreamController<List<Map<String, dynamic>>>.broadcast();
    final _parcelaSelectControl = StreamController<List<Map<String, dynamic>>>.broadcast();

    Stream<List<Finca>> get fincaStream => _fincasController.stream;
    Stream<List<Parcela>> get parcelaStream => _parcelasController.stream;
    Stream<List<Testplaga>> get plagaStream => _plagaController.stream;
    Stream<List<Planta>> get plantaStream => _plantaController.stream;
    Stream<List<Planta>> get countPlanta => _countPlantaControl.stream;
    Stream<List<Decisiones>> get decisionesStream => _decisionesControl.stream;


    Stream<List<Map<String, dynamic>>> get fincaSelect => _fincasSelectControl.stream;
    Stream<List<Map<String, dynamic>>> get parcelaSelect => _parcelaSelectControl.stream;

    
    //fincas
    obtenerFincas() async {
        _fincasController.sink.add( await DBProvider.db.getTodasFincas() );
    }

    addFinca( Finca finca ) async{
        await DBProvider.db.nuevoFinca(finca);
        obtenerFincas();
    }

    actualizarFinca( Finca finca ) async{
        await DBProvider.db.updateFinca(finca);
        obtenerFincas();
    }

    borrarFinca( String id ) async {
        await DBProvider.db.deleteFinca(id);
        obtenerFincas();
    }

    selectFinca() async{
        _fincasSelectControl.sink.add( await DBProvider.db.getSelectFinca());
    }
    

    //Parcelas
    obtenerParcelas() async {
        _parcelasController.sink.add( await DBProvider.db.getTodasParcelas() );
    }
    
    obtenerParcelasIdFinca(String idFinca) async {
        _parcelasController.sink.add( await DBProvider.db.getTodasParcelasIdFinca(idFinca) );
    }

    addParcela( Parcela parcela, String idFinca ) async{
        await DBProvider.db.nuevoParcela(parcela);
        obtenerParcelasIdFinca(idFinca);
    }

    actualizarParcela( Parcela parcela, String idFinca ) async{
        await DBProvider.db.updateParcela(parcela);
        obtenerParcelasIdFinca(idFinca);
    }
    
    borrarParcela( String id ) async {
        await DBProvider.db.deleteParcela(id);
        obtenerParcelas();
    }

    selectParcela(String idFinca) async{
        _parcelaSelectControl.sink.add( await DBProvider.db.getSelectParcelasIdFinca(idFinca));
    }

    //Plagas
    obtenerPlagas() async {
        _plagaController.sink.add( await DBProvider.db.getTodasTestPlaga() );
    }
    
    addPlaga( Testplaga nuevaPlaga) async{
        await DBProvider.db.nuevoTestPlaga(nuevaPlaga);
        obtenerPlagas();
        //obtenerParcelasIdFinca(idFinca);
    }

    borrarTestPlaga( String idTest) async{
        await DBProvider.db.deleteTestPlaga(idTest);
        obtenerPlagas();
    }


    //Plantas
    

    



    //deciones
   


    


    //Cerrar stream
    dispose() {
        _fincasController?.close();
        _parcelasController?.close();
        _fincasSelectControl?.close();
        _parcelaSelectControl?.close();
        _plagaController?.close();
        _plantaController?.close();
        _countPlantaControl?.close();
        _decisionesControl?.close();
    }

    

//   borrarScanTODOS() async {
    
//     await DBProvider.db.deleteAll();
//     obtenerScans();
//   }


}