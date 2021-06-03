import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';

import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_suelo/src/utils/validaciones.dart' as utils;
import 'package:uuid/uuid.dart';

class CosechaAnual extends StatefulWidget {
  CosechaAnual({Key key}) : super(key: key);

  @override
  _CosechaAnualState createState() => _CosechaAnualState();
}

class _CosechaAnualState extends State<CosechaAnual> {
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    FincasBloc fincasBloc = FincasBloc();
    SalidaNutriente salidaNutriente = SalidaNutriente();
    bool _guardando = false;
    var uuid = Uuid();
    TestSuelo suelo;

    String tituloBtn;


    @override
    Widget build(BuildContext context) {

        Size size = MediaQuery.of(context).size;
        List data = ModalRoute.of(context).settings.arguments;

        suelo = data[0];
        salidaNutriente = data[1];

        if (salidaNutriente.id == null) {
            salidaNutriente.idTest = suelo.id;
            tituloBtn = 'Guardar';
            
        } else {
            tituloBtn = 'Actualizar';
        }
        

        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            body: SingleChildScrollView(
                child: Column(
                    children: [
                        TitulosPages(titulo: 'Cosecha anual'),
                        Divider(),
                        Container(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                                key: formKey,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [                                                
                                                Flexible(
                                                    child: Container(
                                                        width: size.width * 0.2,
                                                        child: _titulosForm('Nombre'),
                                                    ),
                                                ),
                                                
                                                Expanded(
                                                    child: _titulosForm('Cantidad'),
                                                ),
                                                Flexible(
                                                    child: Container(
                                                        width: size.width * 0.2,
                                                        child: _titulosForm('Unidad'),
                                                    ),
                                                ),
                                            ],
                                        ),
                                        Divider(),
                                        _cacao(size),
                                        Divider(),
                                        _cascaraCacao(size),
                                        Divider(),
                                        _lena(size),
                                        Divider(),
                                        _musaceas(size),
                                        Divider(),
                                        _frutas(size),
                                        Divider(),
                                        _madera(size),
                                        Divider(),
                                        SizedBox(height: 40,),
                                        _botonsubmit(tituloBtn),
                                    ],
                                ),
                            ),
                        ),
                    ],
                )
            ),
        );
    }

    Widget _titulosForm(String titulo){
        return Container(
            child: Text(titulo, textAlign: TextAlign.start, style: Theme.of(context).textTheme.headline6
            .copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
        );
    }

    Widget _cacao(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Cacao'),
                    ),
                ),
        
                Expanded(
                    child: TextFormField(
                        initialValue: salidaNutriente.cacao == null ? '' : salidaNutriente.cacao.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value){
                            if (utils.isNumeric(value)){
                                return null;
                            }else{
                                return 'Solo números';
                            }
                            
                        },
                        onSaved: (value) => salidaNutriente.cacao = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('QQ seco'),
                    ),
                ),
                
                
            ],
        );
        
    }

    Widget _cascaraCacao(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Cascara de Cacao'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: salidaNutriente.cascaraCacao == null ? '' : salidaNutriente.cascaraCacao.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value){
                            if (utils.isNumeric(value)){
                                return null;
                            }else{
                                return 'Solo números';
                            }
                        },
                        onSaved: (value) => salidaNutriente.cascaraCacao = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('QQ seco'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _lena(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Leña'),
                    ),
                ),                
                Expanded(
                    child: TextFormField(
                        initialValue: salidaNutriente.lena == null ? '' : salidaNutriente.lena.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value){
                            if (utils.isNumeric(value)){
                                return null;
                            }else{
                                return 'Solo números';
                            }
                        },
                        onSaved: (value) => salidaNutriente.lena = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Carga'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _musaceas(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Musaceas'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: salidaNutriente.musacea == null ? '' : salidaNutriente.musacea.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value){
                            if (utils.isNumeric(value)){
                                return null;
                            }else{
                                return 'Solo números';
                            }
                        },
                        onSaved: (value) => salidaNutriente.musacea = double.parse(value),
                    ),
                ),
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Cabezas'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _frutas(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Frutas'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: salidaNutriente.fruta == null ? '' : salidaNutriente.fruta.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value){
                            if (utils.isNumeric(value)){
                                return null;
                            }else{
                                return 'Solo números';
                            }
                        },
                        onSaved: (value) => salidaNutriente.fruta = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Sacos'),
                    ),
                ),
                
            ],
        );
        
    }
    
    Widget _madera(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Madera'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: salidaNutriente.madera == null ? '' : salidaNutriente.madera.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value){
                            if (utils.isNumeric(value)){
                                return null;
                            }else{
                                return 'Solo números';
                            }
                        },
                        onSaved: (value) => salidaNutriente.madera = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.2,
                        child: _titulosForm('Pie tablar'),
                    ),
                ),
                
            ],
        );
        
    }

    

    Widget  _botonsubmit(String tituloBtn){
        return RaisedButton.icon(
            
            icon:Icon(Icons.save, color: Colors.white,),
            
            label: Text(tituloBtn,
                style: Theme.of(context).textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.white)
            ),
            padding:EdgeInsets.symmetric(vertical: 13, horizontal: 50),
            onPressed:(_guardando) ? null : _submit,
        );
    }

    void _submit( ){

        

        if  ( !formKey.currentState.validate() ){
            //Cuendo el form no es valido
            return null;
        }
        

        formKey.currentState.save();

        setState(() {_guardando = true;});


        if(salidaNutriente.id == null){
            salidaNutriente.id = uuid.v1();
            fincasBloc.addSalida(salidaNutriente);
            
        }else{
            fincasBloc.actualizarSalida(salidaNutriente);
        }
        
        //DBProvider.db.nuevoParcela(parcela);

        setState(() {_guardando = false;});
        


        Navigator.pop(context, 'salidaPage');
       
        
    }



}