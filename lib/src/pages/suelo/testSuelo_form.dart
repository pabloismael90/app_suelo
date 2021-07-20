//import 'dart:html';

import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';

import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AgregarTest extends StatefulWidget {

  @override
  _AgregarTestState createState() => _AgregarTestState();
}

class _AgregarTestState extends State<AgregarTest> {

    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();



    TestSuelo plaga = new TestSuelo();
    final fincasBloc = new FincasBloc();

    bool _guardando = false;
    var uuid = Uuid();
    String idFinca ='';

    //Configuracion de FEcha
    DateTime _dateNow = new DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    String _fecha = '';
    TextEditingController _inputfecha = new TextEditingController();

    List<TestSuelo>? mainlistplagas ;

    List? mainparcela;
    TextEditingController? _control;

    @mustCallSuper
    // ignore: must_call_super
    void initState(){
        _fecha = formatter.format(_dateNow);
        _inputfecha.text = _fecha;


    }




    @override
    Widget build(BuildContext context) {

        fincasBloc.selectFinca();



        return StreamBuilder(
            stream: fincasBloc.fincaSelect,
            //future: DBProvider.db.getSelectFinca(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                //print(snapshot.data);
                if (!snapshot.hasData) {
                    return Scaffold(body: CircularProgressIndicator(),);
                } else {

                    List<Map<String, dynamic>> _listitem = snapshot.data;
                    return Scaffold(
                        key: scaffoldKey,
                        appBar: AppBar(title: Text('Toma de datos'),),
                        body: SingleChildScrollView(
                            child: Column(
                                children: [
                                    Container(
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                                Flexible(
                                                    child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                        child:Text(
                                                            'Recorrido de parcela',
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                    ),
                                                ),
                                                Flexible(
                                                    child: Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                        child:Text(
                                                            '5 puntos',
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                    ),
                                                ),
                                            ],
                                        )
                                    ),
                                    Divider(),
                                    Container(
                                        padding: EdgeInsets.all(15.0),
                                        child: Form(
                                            key: formKey,
                                            child: Column(
                                                children: <Widget>[

                                                    _selectfinca(_listitem),
                                                    SizedBox(height: 40.0),
                                                    _selectParcela(),
                                                    SizedBox(height: 40.0),
                                                    _date(context),
                                                    SizedBox(height: 60.0),

                                                    _botonsubmit()
                                                ],
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    );
                }
            },
        );
    }

    Widget _selectfinca(List<Map<String, dynamic>> _listitem){

        bool _enableFinca = _listitem.isNotEmpty ? true : false;

        return SelectFormField(
            labelText: 'Seleccione la finca',
            items: _listitem,
            enabled: _enableFinca,
            validator: (value){
                if(value!.length < 1){
                    return 'No se selecciono una finca';
                }else{
                    return null;
                }
            },

            onChanged: (val){
                fincasBloc.selectParcela(val);
            },
            onSaved: (value) => plaga.idFinca = value,
        );
    }

    Widget _selectParcela(){

        return StreamBuilder(
            stream: fincasBloc.parcelaSelect,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return SelectFormField(
                        controller: _control,
                        initialValue: '',
                        enabled: false,
                        labelText: 'Seleccione la parcela',
                        items: [],
                    );
                }

                mainparcela = snapshot.data;
                return SelectFormField(
                    controller: _control,
                    initialValue: '',
                    labelText: 'Seleccione la parcela',
                    items: mainparcela as List<Map<String, dynamic>>,
                    validator: (value){
                        if(value!.length < 1){
                            return 'Selecione un elemento';
                        }else{
                            return null;
                        }
                    },

                    //onChanged: (val) => print(val),
                    onSaved: (value) => plaga.idLote = value,
                );
            },
        );

    }


    Widget _date(BuildContext context){
        return TextFormField(

            //autofocus: true,
            controller: _inputfecha,
            enableInteractiveSelection: false,
            decoration: InputDecoration(
                labelText: 'Fecha'
            ),
            onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDate(context);
            },
            //onChanged: (value) => print('hola: $value'),
            //validator: (value){},
            onSaved: (value){
                plaga.fechaTest = value;
            }
        );
    }

    _selectDate(BuildContext context) async{
        DateTime? picked = await showDatePicker(
            context: context,

            initialDate: new DateTime.now(),
            firstDate: new DateTime.now().subtract(Duration(days: 0)),
            lastDate:  new DateTime(2025),
            locale: Locale('es', 'ES')
        );
        if (picked != null){
            setState(() {
                _fecha = formatter.format(picked);
                _inputfecha.text = _fecha;
            });
        }

    }


    Widget  _botonsubmit(){
        fincasBloc.obtenerTest();
        
        return Row(
            children: [
                Spacer(),
                StreamBuilder(
                    stream: fincasBloc.testStream ,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                        if (!snapshot.hasData) {
                            return Container();
                        }
                        mainlistplagas = snapshot.data;
                        return ButtonMainStyle(
                            title: 'Guardar',
                            icon: Icons.save,
                            press: (_guardando) ? null : _submit,
                        );
                    },
                ),
                Spacer()
            ],
        );


    }





    void _submit(){
        bool checkRepetido = false;

        plaga.estaciones = 3;

        if  ( !formKey.currentState!.validate() ){
            //Cuendo el form no es valido
            return null;
        }
        formKey.currentState!.save();

        mainlistplagas!.forEach((e) {
            if (plaga.idFinca == e.idFinca && plaga.idLote == e.idLote && plaga.fechaTest == e.fechaTest) {
                checkRepetido = true;
            }
        });



        if (checkRepetido == true) {
            mostrarSnackbar('Ya existe un registros con los mismos valores', context);
            return null;
        }

        String? checkParcela = mainparcela!.firstWhere((e) => e['value'] == '${plaga.idLote}', orElse: () => {"value": "1","label": "No data"})['value'];



        if (checkParcela == '1') {
            mostrarSnackbar('La parcela selecionada no pertenece a esa finca', context);
            return null;
        }



        setState(() {_guardando = true;});

        if(plaga.id == null){
            plaga.id =  uuid.v1();
            fincasBloc.addTest(plaga);
        }

        setState(() {_guardando = false;});
        mostrarSnackbar('Registro Guardado', context);


        Navigator.pop(context, 'fincas');


    }


   
}