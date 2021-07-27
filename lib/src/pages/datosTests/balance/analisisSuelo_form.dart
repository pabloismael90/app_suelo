import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/sueloNutriente_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:app_suelo/src/utils/validaciones.dart' as utils;
import 'package:select_form_field/select_form_field.dart';
import 'package:uuid/uuid.dart';

class AnalisiSuelo extends StatefulWidget {
  AnalisiSuelo({Key? key}) : super(key: key);

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
    late TestSuelo suelo;

    late String tituloBtn;


    @override
    Widget build(BuildContext context) {

        Size size = MediaQuery.of(context).size;
        List data = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
        
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
            appBar: AppBar(title: Text('Análisis de suelo')),
            body: SingleChildScrollView(
                child: Column(
                    children: [
                        SizedBox(height: 10),
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
                                                        child: textList('Nombre'),
                                                    ),
                                                ),
                                                
                                                Expanded(
                                                    child: textList('Valor'),
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


    Widget _ph(Size size){

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('pH'),
                    ),
                ),
        
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.ph == null ? '' : sueloNutriente.ph.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.ph = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList(''),
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
                        child: textList('Densidad Aparente'),
                    ),
                ),                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.densidadAparente == null ? '' : sueloNutriente.densidadAparente.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.densidadAparente = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('g/cm3'),
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
                        child: textList('Materia orgánica'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.materiaOrganica == null ? '' : sueloNutriente.materiaOrganica.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.materiaOrganica = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('%'),
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
                        child: textList('Nitrógeno'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.nitrogeno == null ? '' : sueloNutriente.nitrogeno.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.nitrogeno = double.parse(value!),
                    ),
                ),
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('%'),
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
                        child: textList('Fósforo'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.fosforo == null ? '' : sueloNutriente.fosforo.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.fosforo = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('ppm'),
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
                        child: textList('Potasio'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.potasio == null ? '' : sueloNutriente.potasio.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.potasio = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('meq/100g'),
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
                        child: textList('Azufre'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.azufre == null ? '' : sueloNutriente.azufre.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.azufre = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('ppm'),
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
                        child: textList('Calcio'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.calcio == null ? '' : sueloNutriente.calcio.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.calcio = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('meq/100g'),
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
                        child: textList('Magnesio'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.magnesio == null ? '' : sueloNutriente.magnesio.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.magnesio = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('meq/100g'),
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
                        child: textList('Hierro'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.hierro == null ? '' : sueloNutriente.hierro.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.hierro = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('ppm'),
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
                        child: textList('Manganeso'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.manganeso == null ? '' : sueloNutriente.manganeso.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.manganeso = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('ppm'),
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
                        child: textList('Cadmio'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.cadmio == null ? '' : sueloNutriente.cadmio.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.cadmio = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('ppm'),
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
                        child: textList('Zinc'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.zinc == null ? '' : sueloNutriente.zinc.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.zinc = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('ppm'),
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
                        child: textList('Boro'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.boro == null ? '' : sueloNutriente.boro.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.boro = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('ppm'),
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
                        child: textList('Acidez intercambiable'),
                    ),
                ),
                
                Expanded(
                    child: TextFormField(
                        initialValue: sueloNutriente.acidez == null ? '' : sueloNutriente.acidez.toString(),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        validator: (value) => utils.floatSiCero(value),
                        onSaved: (value) => sueloNutriente.acidez = double.parse(value!),
                    ),
                ),
                
                Flexible(child: Container(
                        width: size.width * 0.25,
                        child: textList('Cmol+/kg'),
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
                        child: textList('Textura'),
                    ),
                ),
                
                Expanded(
                    child: SelectFormField(
                        initialValue: sueloNutriente.textura.toString(),
                        items: selectMap.texturasSuelo(),
                        validator: (value){
                            if(value!.length < 1){
                                return 'Selecione un elemento';
                            }else{
                                return null;
                            } 
                        },
                        onSaved: (value) => sueloNutriente.textura = int.parse(value!),
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
                        child: textList('Tipo de suelo'),
                    ),
                ),
                
                Expanded(
                    child: SelectFormField(
                        initialValue: sueloNutriente.tipoSuelo.toString(),
                        items: selectMap.tiposSuelo(),
                        validator: (value){
                            if(value!.length < 1){
                                return 'Selecione un elemento';
                            }else{
                                return null;
                            } 
                        },
                        onSaved: (value) => sueloNutriente.tipoSuelo = int.parse(value!),
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

        if(sueloNutriente.id == null){
            sueloNutriente.id = uuid.v1();
            fincasBloc.addSuelo(sueloNutriente);
            mostrarSnackbar('Análisis de suelo guardado', context);
            
        }else{
            fincasBloc.actualizarSuelo(sueloNutriente);
            mostrarSnackbar('Análisis de suelo actualizado', context);
        }

        setState(() {_guardando = false;});
        


        Navigator.pop(context, 'fincas');
       
        
    }



}