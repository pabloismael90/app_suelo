import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_suelo/src/utils/validaciones.dart' as utils;
import 'package:uuid/uuid.dart';

class CosechaAnual extends StatefulWidget {
  CosechaAnual({Key? key}) : super(key: key);

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
    late TestSuelo suelo;
    

    late String tituloBtn;

    
    @override
    Widget build(BuildContext context) {

        Size size = MediaQuery.of(context).size;
        List data = ModalRoute.of(context)!.settings.arguments as List<dynamic>;

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
            appBar: AppBar(title: Text('Cosecha anual')),
            body: SingleChildScrollView(
                child: Column(
                    children: [
                        Container(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                                key: formKey,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                        SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [                                                
                                                Flexible(
                                                    child: Container(
                                                        width: size.width * 0.25,
                                                        child: textList('Nombre'),
                                                    ),
                                                ),
                                                
                                                Expanded(
                                                    child: textList('Cantidad'),
                                                ),
                                                Flexible(
                                                    child: Container(
                                                        width: size.width * 0.25,
                                                        child: textList('Unidad'),
                                                    ),
                                                ),
                                            ],
                                        ),
                                        Divider(),
                                        _cacao(size),
                                        Divider(),
                                        _lena(size),
                                        Divider(),
                                        _musaceas(size),
                                        Divider(),
                                        _frutas(size),
                                        Divider(),
                                        _madera(size),
                                        Divider(),
                                        _cascaraCacao(),
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


    Widget _cacao(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(
                    child: Container(
                        width: size.width * 0.25,
                        child: textList('Cacao baba'),
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
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => salidaNutriente.cacao = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('QQ'),
                    ),
                ),
                
                
            ],
        );
        
    }

    Widget _cascaraCacao(){

        // return Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //         Flexible(child: Container(
        //                 width: size.width * 0.25,
        //                 child: textList('Cascara de Cacao'),
        //             ),
        //         ),
                
        //         Expanded(
        //             child: TextFormField(
        //                 initialValue: salidaNutriente.cascaraCacao == null ? '' : salidaNutriente.cascaraCacao.toString(),
        //                 keyboardType: TextInputType.numberWithOptions(decimal: true),
        //                 decoration: InputDecoration(
        //                     border: OutlineInputBorder(),
        //                     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        //                 ),
        //                 validator: (value) => utils.floatSiCero(value),
        //                 onSaved: (value) => salidaNutriente.cascaraCacao = double.parse(value!),
        //             ),
        //         ),
                
        //         Flexible(child: Container(
        //                 width: size.width * 0.25,
        //                 child: textList('QQ seco'),
        //             ),
        //         ),
                
        //     ],
        // );
        
        return CheckboxListTile(
            title: textList('Regresa la cascara de cacao  a la plantación'),
            value: salidaNutriente.cascaraCacao != 0 , 
            onChanged: (value) {
                setState(() {
                    salidaNutriente.cascaraCacao = value! ? 1 : 0;
                });
            },
        );
        
    }

    Widget _lena(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('Leña'),
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
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => salidaNutriente.lena = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('Carga'),
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
                        width: size.width * 0.25,
                        child: textList('Musaceas'),
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
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => salidaNutriente.musacea = double.parse(value!),
                    ),
                ),
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('Cabezas'),
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
                        width: size.width * 0.25,
                        child: textList('Frutas'),
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
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => salidaNutriente.fruta = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('Sacos'),
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
                        width: size.width * 0.25,
                        child: textList('Madera'),
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
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => salidaNutriente.madera = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('Pie tablar'),
                    ),
                ),
                
            ],
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
            //Cuendo el form no es valido
            return null;
        }
        
        formKey.currentState!.save();

        setState(() {_guardando = true;});
        

        if(salidaNutriente.id == null){
            salidaNutriente.id = uuid.v1();
            fincasBloc.addSalida(salidaNutriente);
            mostrarSnackbar('Registro de cosecha guardado', context);
            
        }else{
            fincasBloc.actualizarSalida(salidaNutriente);
            mostrarSnackbar('Registro de cosecha actualizado', context);
        }

        setState(() {_guardando = false;});
        
        Navigator.pop(context, 'salidaPage');
       
        
    }



}