import 'package:app_suelo/src/models/testSuelo_model.dart';

import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
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

    bool _guardando = false;
    var uuid = Uuid();

    String tituloBtn;


    @override
    Widget build(BuildContext context) {

        Size size = MediaQuery.of(context).size;
        TestSuelo suelo = ModalRoute.of(context).settings.arguments;

        tituloBtn = 'Guardar';
        
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
                                        _azufre(size),
                                        Divider(),
                                        _calcio(size),
                                        Divider(),
                                        _magnesio(size),
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '0.0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
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
                        //onSaved: (value) => finca.nombreFinca = value,
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
                        initialValue: '',
                        items: selectMap.dimenciones(),
                        validator: (value){
                            if(value.length < 1){
                                return 'Selecione un elemento';
                            }else{
                                return null;
                            } 
                        },

                        //onChanged: (val) => print(val),
                        //onSaved: (value) => finca.tipoMedida = int.parse(value),
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
                        initialValue: '',
                        items: selectMap.dimenciones(),
                        validator: (value){
                            if(value.length < 1){
                                return 'Selecione un elemento';
                            }else{
                                return null;
                            } 
                        },

                        //onChanged: (val) => print(val),
                        //onSaved: (value) => finca.tipoMedida = int.parse(value),
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