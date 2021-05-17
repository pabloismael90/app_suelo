import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/new_abono.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:uuid/uuid.dart';
import 'package:app_suelo/src/utils/validaciones.dart' as utils;
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';

class AddNewAbono extends StatefulWidget {
  AddNewAbono({Key key}) : super(key: key);

  @override
  _AddNewAbonoState createState() => _AddNewAbonoState();
}

class _AddNewAbonoState extends State<AddNewAbono> {

    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
 
    final fincasBloc = new FincasBloc();
    NewAbono entradaNutriente = NewAbono();

    bool _guardando = false;
    var uuid = Uuid();
    TestSuelo suelo;

    @override
    Widget build(BuildContext context) {

        suelo = ModalRoute.of(context).settings.arguments ;
        String tituloBtn = 'Guardar';

        entradaNutriente.idTest = suelo.id;

        
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            body: SingleChildScrollView(
                child: Column(
                    children: [
                        TitulosPages(titulo: 'Agregar nuevo abono'),
                        Divider(),
                        Container(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                                key: formKey,
                                child: Column(
                                    children: <Widget>[
                                        _selectAbono(),
                                        SizedBox(height: 30.0,),
                                        _humedadAbono(),
                                        SizedBox(height: 30.0,),
                                        Row(
                                            children: <Widget>[
                                                Flexible(
                                                    child: _cantidadAbono(),
                                                ),
                                                SizedBox(width: 20.0,),
                                                Flexible(
                                                    child: _frecuenciaAbono(),
                                                ),
                                            ],
                                        ),
                                        SizedBox(height: 30.0,),
                                        _selectUnidad(),
                                        SizedBox(height: 60.0,),
                                        _botonsubmit(tituloBtn)
                                    ],
                                ),
                            ),
                        ),
                    ],
                )
            ),
        );
    }

    Widget _selectAbono(){
        return SelectFormField(
            initialValue: entradaNutriente.idAbono.toString(),
            type: SelectFormFieldType.dialog,
            labelText: 'Selecione abono',
            dialogTitle: 'Seleccione abono',
            dialogCancelBtn: 'Cerrar',
            enableSearch: true,
            dialogSearchHint: 'Buscar abono',
            items: selectMap.listAbonos(),
            validator: (value){
                final isDigitsOnly = int.tryParse(value);
                if (isDigitsOnly == null) {
                    return 'Solo números enteros';
                }
                if (isDigitsOnly <= 0) {
                    return 'Valor invalido';
                }else{
                    return null;
                }
            },
            onSaved: (value) => entradaNutriente.idAbono = int.parse(value),
        );
    }



    Widget _humedadAbono(){

        return TextFormField(
            initialValue: entradaNutriente.humedad.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Humedad (%)'
            ),
            validator: (value) {
                
                if (utils.isNumeric(value)){
                    return null;
                }else{
                    return 'Solo números';
                }
            },
            onSaved: (value) => entradaNutriente.humedad = double.parse(value),
        );
    }

    Widget _cantidadAbono(){

        return TextFormField(
            initialValue: entradaNutriente.cantidad.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Cantidad'
            ),
            validator: (value) {
                
                if (utils.isNumeric(value)){
                    return null;
                }else{
                    return 'Solo números';
                }
            },
            onSaved: (value) => entradaNutriente.cantidad = double.parse(value),
        );
    }

    Widget _frecuenciaAbono(){

        return TextFormField(
            initialValue: entradaNutriente.frecuencia.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Frecuencia'
            ),
            validator: (value) {
                
                final isDigitsOnly = int.tryParse(value);
                if (isDigitsOnly == null) {
                    return 'Solo números enteros';
                }
                if (isDigitsOnly <= 0) {
                    return 'Valor invalido';
                }else{
                    return null;
                }
            },
            onSaved: (value) => entradaNutriente.frecuencia = int.parse(value),
        );
    }

    Widget _selectUnidad(){
        return SelectFormField(
            initialValue: entradaNutriente.unidad.toString(),
            labelText: 'Selecione Unidad',
            items: selectMap.unidadAbono(),
            validator: (value){
                if(value.length < 1){
                    return 'Selecione un elemento';
                }else{
                    return null;
                } 
            },

            onSaved: (value) => entradaNutriente.unidad = int.parse(value),
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

        
        entradaNutriente.id = uuid.v1();
        fincasBloc.addNewEntrada(entradaNutriente);
        

        setState(() {_guardando = false;});
        


        Navigator.pop(context, 'tomaDatos');
       
        
    }


    
}

