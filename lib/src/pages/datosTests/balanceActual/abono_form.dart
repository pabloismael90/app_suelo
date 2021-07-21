import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:uuid/uuid.dart';
import 'package:app_suelo/src/utils/validaciones.dart' as utils;
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';

class AddAbono extends StatefulWidget {
  AddAbono({Key? key}) : super(key: key);

  @override
  _AddAbonoState createState() => _AddAbonoState();
}

class _AddAbonoState extends State<AddAbono> {

    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
 
    final fincasBloc = new FincasBloc();
    EntradaNutriente entradaNutriente = EntradaNutriente();

    bool _guardando = false;
    var uuid = Uuid();
    late TestSuelo suelo;

    @override
    Widget build(BuildContext context) {

        List dataRoute = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
        suelo = dataRoute[0];
        String tituloBtn = 'Guardar';


        entradaNutriente.idTest = suelo.id;
        entradaNutriente.tipo = dataRoute[1];
        print(entradaNutriente.tipo);

        
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text('Agregar nuevo abono')),
            body: SingleChildScrollView(
                child: Column(
                    children: [
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
            validator: (value) => utils.validateEntero(value),
            onSaved: (value) => entradaNutriente.idAbono = int.parse(value!),
        );
    }



    Widget _humedadAbono(){

        return TextFormField(
            initialValue: entradaNutriente.humedad == null ? '' : entradaNutriente.humedad.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Humedad (%)',
                hintText: 'ejem: 10'
            ),
            validator: (value) => utils.floatSiCero(value),
            onSaved: (value) => entradaNutriente.humedad = double.parse(value!),
        );
    }

    Widget _cantidadAbono(){

        return TextFormField(
            initialValue: entradaNutriente.cantidad == null ? '' : entradaNutriente.cantidad.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Cantidad',
                hintText: 'ejem: 2.5'
            ),
            validator: (value) => utils.floatSiCero(value),
            onSaved: (value) => entradaNutriente.cantidad = double.parse(value!),
        );
    }

    Widget _frecuenciaAbono(){

        return TextFormField(
            initialValue: entradaNutriente.frecuencia == null ? '' : entradaNutriente.frecuencia.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Frecuencia',
                hintText: 'ejem: 1'
            ),
            validator: (value) => utils.validateEntero(value),
            onSaved: (value) => entradaNutriente.frecuencia = int.parse(value!),
        );
    }

    Widget _selectUnidad(){
        return SelectFormField(
            initialValue: entradaNutriente.unidad.toString(),
            labelText: 'Selecione Unidad',
            items: selectMap.unidadAbono(),
            validator: (value){
                if(value!.length < 1){
                    return 'Selecione un elemento';
                }else{
                    return null;
                } 
            },

            onSaved: (value) => entradaNutriente.unidad = int.parse(value!),
        );
    }




    Widget  _botonsubmit(String tituloBtn){
        return ButtonMainStyle(
            title: tituloBtn,
            icon: Icons.save,
            press:(_guardando) ? null : _submit,
        );
    }

    void _submit( ){

        if  ( !formKey.currentState!.validate() ){
            return null;
        }
        
        formKey.currentState!.save();

        setState(() {_guardando = true;});

        
        entradaNutriente.id = uuid.v1();
        fincasBloc.addEntrada(entradaNutriente);
        mostrarSnackbar('Registro de abono guardado', context);
        

        setState(() {_guardando = false;});
        Navigator.pop(context, 'salidaPage');
       
        
    }


    
}

