
import 'dart:async';
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/punto_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
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
    final _plagaController = StreamController<List<TestSuelo>>.broadcast();
    final _puntosControl = StreamController<List<Punto>>.broadcast();
    final _salidaControl = StreamController<SalidaNutriente>.broadcast();
    final _sueloControl = StreamController<SueloNutriente>.broadcast();
    final _entradaControl = StreamController<List<EntradaNutriente>>.broadcast();
    final _monitoreoControl = StreamController<int>.broadcast();
    //final _decisionesControl = StreamController<List<Decisiones>>.broadcast();
    

    final _fincasSelectControl = StreamController<List<Map<String, dynamic>>>.broadcast();
    final _parcelaSelectControl = StreamController<List<Map<String, dynamic>>>.broadcast();

    Stream<List<Finca>> get fincaStream => _fincasController.stream;
    Stream<List<Parcela>> get parcelaStream => _parcelasController.stream;
    Stream<List<TestSuelo>> get plagaStream => _plagaController.stream;
    Stream<List<Punto>> get puntoStream => _puntosControl.stream;
    Stream<SalidaNutriente> get salidaStream => _salidaControl.stream;
    Stream<SueloNutriente> get sueloStream => _sueloControl.stream;
    Stream<List<EntradaNutriente>> get entradaStream => _entradaControl.stream;
    Stream<int> get monitoreoStream => _monitoreoControl.stream;

    //Stream<List<Decisiones>> get decisionesStream => _decisionesControl.stream;


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
        _plagaController.sink.add( await DBProvider.db.getTodasTestSuelo() );
    }
    
    addPlaga( TestSuelo nuevaTest) async{
        await DBProvider.db.nuevoTestSuelo(nuevaTest);
        obtenerPlagas();
        //obtenerParcelasIdFinca(idFinca);
    }

    borrarTestSuelo( String idTest) async{
        await DBProvider.db.deleteTestSuelo(idTest);
        obtenerPlagas();
    }


    //Puntos
    obtenerPuntos(String idTest) async {
        _puntosControl.sink.add( await DBProvider.db.getPuntosIdTest(idTest) );
    }

    addPunto( Punto nuevaPunto) async{
        await DBProvider.db.nuevoPunto(nuevaPunto);
        obtenerPuntos(nuevaPunto.idTest);
    }
    borrarPunto( Punto punto )async{
        await DBProvider.db.deletePunto(punto.idTest, punto.nPunto);
        obtenerPuntos(punto.idTest);
    }

    //Balance de Nutrientes
    obtenerSalida(String idTest) async {
        _salidaControl.sink.add( await DBProvider.db.getSalidaNutrientes(idTest) );
    }

    addSalida( SalidaNutriente nuevaSalida) async{
        await DBProvider.db.nuevoSalida(nuevaSalida);
        obtenerSalida(nuevaSalida.idTest);
    }

    actualizarSalida( SalidaNutriente nuevaSalida) async{
        await DBProvider.db.updateSalidaNutriente(nuevaSalida);
        obtenerSalida(nuevaSalida.idTest);
    }

    obtenerSuelo(String idTest) async {
        _sueloControl.sink.add( await DBProvider.db.getSueloNutrientes(idTest) );
    }

    addSuelo( SueloNutriente nuevaSuelo ) async{
        await DBProvider.db.nuevoSueloAnalisis(nuevaSuelo);
        obtenerSuelo(nuevaSuelo.idTest);
    }

    actualizarSuelo( SueloNutriente nuevaSuelo) async{
        await DBProvider.db.updateSueloNutriente(nuevaSuelo);
        obtenerSuelo(nuevaSuelo.idTest);
    }

    obtenerEntradas(String idTest, int tipo) async {
        _entradaControl.sink.add( await DBProvider.db.getEntradas(idTest, tipo) );
    }

    addEntrada( EntradaNutriente nuevaEntrada) async{
        await DBProvider.db.nuevoEntrada(nuevaEntrada);
        obtenerEntradas(nuevaEntrada.idTest, nuevaEntrada.tipo);
    }

    borrarEntrada( EntradaNutriente nuevaEntrada )async{
        await DBProvider.db.deleteEntrada(nuevaEntrada.id);
        obtenerEntradas(nuevaEntrada.idTest, nuevaEntrada.tipo);
    }


    //Monitoreo 
    monitoreoBalance( String idTest )async{
       _monitoreoControl.sink.add( await DBProvider.db.monitoreo(idTest));
    }




    //deciones
   


    


    //Cerrar stream
    dispose() {
        _fincasController?.close();
        _parcelasController?.close();
        _fincasSelectControl?.close();
        _parcelaSelectControl?.close();
        _plagaController?.close();
        //_decisionesControl?.close();
        _puntosControl?.close();
        _salidaControl?.close();
        _sueloControl?.close();
        _entradaControl?.close();
        _monitoreoControl?.close();
    }

    



}