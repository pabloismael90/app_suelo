import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:uuid/uuid.dart';
import 'package:app_suelo/src/utils/validaciones.dart' as utils;
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';

class AddAbono extends StatefulWidget {
  AddAbono({Key key}) : super(key: key);

  @override
  _AddAbonoState createState() => _AddAbonoState();
}

class _AddAbonoState extends State<AddAbono> {

    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
 

    final fincasBloc = new FincasBloc();

    bool _guardando = false;
    var uuid = Uuid();

    @override
    Widget build(BuildContext context) {

        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        String tituloBtn = 'Guardar';

        
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
                                        Row(
                                            children: <Widget>[
                                                Flexible(
                                                    child: _densidadxPlanta(),
                                                ),
                                                SizedBox(width: 20.0,),
                                                Flexible(
                                                    child: _humedadAbono(),
                                                ),
                                            ],
                                        ),
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
            initialValue: '',
            type: SelectFormFieldType.dialog,
            labelText: 'Selecione abono',
            dialogTitle: 'Seleccione abono',
            dialogCancelBtn: 'Cerrar',
            enableSearch: true,
            dialogSearchHint: 'Buscar abono',
            items: selectMap.listAbonos(),
            validator: (value){
                if(value.length < 1){
                    return 'Selecione variedad';
                }else{
                    return null;
                } 
            },

            //onChanged: (val) => print(val),
            //onSaved: (value) => parcela.variedadCacao = int.parse(value),
        );
    }

    Widget _densidadxPlanta(){

        return TextFormField(
            initialValue: '0.0',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Plantas por manzana'
            ),
            validator: (value) {
                
                if (utils.isNumeric(value)){
                    return null;
                }else{
                    return 'Solo números';
                }
            },
            //onSaved: (value) => parcela.areaLote = double.parse(value),
        );
    }

    Widget _humedadAbono(){

        return TextFormField(
            initialValue: '0.0',
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
            //onSaved: (value) => parcela.areaLote = double.parse(value),
        );
    }

    Widget _cantidadAbono(){

        return TextFormField(
            initialValue: '0.0',
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
            //onSaved: (value) => parcela.areaLote = double.parse(value),
        );
    }

    Widget _frecuenciaAbono(){

        return TextFormField(
            initialValue: '0.0',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Frecuencia'
            ),
            validator: (value) {
                
                if (utils.isNumeric(value)){
                    return null;
                }else{
                    return 'Solo números';
                }
            },
            //onSaved: (value) => parcela.areaLote = double.parse(value),
        );
    }

    Widget _selectUnidad(){
        return SelectFormField(
            initialValue: '',
            labelText: 'Selecione Unidad',
            items: selectMap.unidadAbono(),
            validator: (value){
                if(value.length < 1){
                    return 'Selecione variedad';
                }else{
                    return null;
                } 
            },

            //onChanged: (val) => print(val),
            //onSaved: (value) => parcela.variedadCacao = int.parse(value),
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
           // onPressed: _submit,
        );
    }

    void _submit( ){

        

        if  ( !formKey.currentState.validate() ){
            
            //Cuendo el form no es valido
            return null;
        }
        

        formKey.currentState.save();

        setState(() {_guardando = true;});

        // print(parcela.id);
        // print(parcela.idFinca);
        // print(parcela.nombreLote);
        // print(parcela.areaLote);
        // if(parcela.id == null){
        //     parcela.id = uuid.v1();
        //     fincasBloc.addParcela(parcela, parcela.idFinca);
        // }else{
        //     fincasBloc.actualizarParcela(parcela, parcela.idFinca);
        // }
        //fincasBloc.addParcela(parcela);
        //DBProvider.db.nuevoParcela(parcela);

        setState(() {_guardando = false;});
        


        Navigator.pop(context, 'fincas');
       
        
    }


    
}

