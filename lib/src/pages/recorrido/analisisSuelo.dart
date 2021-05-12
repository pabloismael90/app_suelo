import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';

import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:app_suelo/src/utils/validaciones.dart' as utils;
import 'package:select_form_field/select_form_field.dart';
import 'package:uuid/uuid.dart';

class AnalisiSuelo extends StatefulWidget {
  AnalisiSuelo({Key key}) : super(key: key);

  @override
  _AnalisiSueloState createState() => _AnalisiSueloState();
}

class _AnalisiSueloState extends State<AnalisiSuelo> {
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    FincasBloc fincasBloc = FincasBloc();
    SueloNutriente sueloNutriente = SueloNutriente();
    bool _guardando = false;
    var uuid = Uuid();
    TestSuelo suelo;

    String tituloBtn;


    @override
    Widget build(BuildContext context) {

        Size size = MediaQuery.of(context).size;
        List data = ModalRoute.of(context).settings.arguments;
        
        suelo = data[0];
        sueloNutriente = data[1];

        sueloNutriente.idTest = suelo.id;

        if (sueloNutriente.id == null) {
            sueloNutriente.idTest = suelo.id;
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
                        TitulosPages(titulo: 'Análisis de suelo'),
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
                                                        width: size.width * 0.25,
                                                        child: _titulosForm('Nombre'),
                                                    ),
                                                ),
                                                
                                                Expanded(
                                                    child: _titulosForm('Valor'),
                                                ),
                                                Flexible(
                                                    child: Container(
                                                        width: size.width * 0.25,
                                                        child: _titulosForm('Unidad'),
                                                    ),
                                                ),
                                            ],
                                        ),
                                        Divider(),
                                        _ph(size),
                                        Divider(),
                                        _densidad(size),
                                        Divider(),
                                        _materialOrganica(size),
                                        Divider(),
                                        _nitrogeno(size),
                                        Divider(),
                                        _fosforo(size),
                                        Divider(),
                                        _potasio(size),
                                        Divider(),
                                        _calcio(size),
                                        Divider(),
                                        _magnesio(size),
                                        Divider(),
                                        _azufre(size),
                                        Divider(),
                                        _hierro(size),
                                        Divider(),
                                        _manganeso(size),
                                        Divider(),
                                        _cadmio(size),
                                        Divider(),
                                        _zinc(size),
                                        Divider(),
                                        _boro(size),
                                        Divider(),
                                        _acidez(size),
                                        Divider(),
                                        _textura(size),
                                        Divider(),
                                        _tipoSuelo(size),
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
            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
        );
    }

    Widget _ph(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('pH'),
                    ),
                ),
        
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.ph.toString(),
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
                        onSaved: (value) => sueloNutriente.ph = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm(''),
                    ),
                ),
                
                
            ],
        );
        
    }

    Widget _densidad(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Densidad Aparente'),
                    ),
                ),                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.densidadAparente.toString(),
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
                        onSaved: (value) => sueloNutriente.densidadAparente = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('g/cm3'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _materialOrganica(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Materia orgánica'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.materiaOrganica.toString(),
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
                        onSaved: (value) => sueloNutriente.materiaOrganica = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('%'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _nitrogeno(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Nitrógeno total'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.nitrogeno.toString(),
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
                        onSaved: (value) => sueloNutriente.nitrogeno = double.parse(value),
                    ),
                ),
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('%'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _fosforo(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Fósforo'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.fosforo.toString(),
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
                        onSaved: (value) => sueloNutriente.fosforo = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('ppm'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _potasio(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Potasio'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.potasio.toString(),
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
                        onSaved: (value) => sueloNutriente.potasio = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('meq/100g'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _azufre(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Azufre'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.azufre.toString(),
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
                        onSaved: (value) => sueloNutriente.azufre = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('ppm'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _calcio(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Calcio'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.calcio.toString(),
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
                        onSaved: (value) => sueloNutriente.calcio = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('meq/100g'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _magnesio(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Magnesio'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.magnesio.toString(),
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
                        onSaved: (value) => sueloNutriente.magnesio = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('meq/100g'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _hierro(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Hierro'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.hierro.toString(),
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
                        onSaved: (value) => sueloNutriente.hierro = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('ppm'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _manganeso(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Manganeso'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.manganeso.toString(),
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
                        onSaved: (value) => sueloNutriente.manganeso = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('ppm'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _cadmio(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Cadmio'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.cadmio.toString(),
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
                        onSaved: (value) => sueloNutriente.cadmio = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('ppm'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _zinc(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Zinc'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.zinc.toString(),
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
                        onSaved: (value) => sueloNutriente.zinc = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('ppm'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _boro(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Boro'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.boro.toString(),
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
                        onSaved: (value) => sueloNutriente.boro = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('ppm'),
                    ),
                ),
                
            ],
        );
        
    }
    
    Widget _acidez(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Acidez intercambiable'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.acidez.toString(),
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
                        onSaved: (value) => sueloNutriente.acidez = double.parse(value),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Cmol+/kg'),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _textura(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Textura'),
                    ),
                ),
                
                Expanded(
                    child: SelectFormField(
                        initialValue: sueloNutriente.textura.toString(),
                        items: selectMap.texturasSuelo(),
                        validator: (value){
                            if(value.length < 1){
                                return 'Selecione un elemento';
                            }else{
                                return null;
                            } 
                        },

                        //onChanged: (val) => print(val),
                        onSaved: (value) => sueloNutriente.textura = int.parse(value),
                    ),
                ),
                
            ],
        );
        
    }

    Widget _tipoSuelo(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: _titulosForm('Tipo de suelo'),
                    ),
                ),
                
                Expanded(
                    child: SelectFormField(
                        initialValue: sueloNutriente.tipoSuelo.toString(),
                        items: selectMap.tiposSuelo(),
                        validator: (value){
                            if(value.length < 1){
                                return 'Selecione un elemento';
                            }else{
                                return null;
                            } 
                        },

                        //onChanged: (val) => print(val),
                        onSaved: (value) => sueloNutriente.tipoSuelo = int.parse(value),
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

        if(sueloNutriente.id == null){
            sueloNutriente.id = uuid.v1();
            fincasBloc.addSuelo(sueloNutriente);
            
        }else{
            fincasBloc.actualizarSuelo(sueloNutriente);
        }

        setState(() {_guardando = false;});
        


        Navigator.pop(context, 'fincas');
       
        
    }



}