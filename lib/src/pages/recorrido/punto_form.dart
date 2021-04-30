
import 'package:app_suelo/src/models/decisiones_model.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';

import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'dart:math' as math;
import 'package:uuid/uuid.dart';

class AgregarPunto extends StatefulWidget {
    
  @override
  _AgregarPuntoState createState() => _AgregarPuntoState();
}

class _AgregarPuntoState extends State<AgregarPunto> {
    
    
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
 
    Finca finca = new Finca();
    final fincasBloc = new FincasBloc();

    final List<Map<String, dynamic>>  itemErosion = selectMap.erosion();
    final List<Map<String, dynamic>>  itemConservacion = selectMap.conservacion();
    
    final Map checkErosion = {};
    final Map checkConservacion = {};

    void checkKeys(){

        for(int i = 0 ; i < itemErosion.length ; i ++){
            checkErosion[itemErosion[i]['value']] = '-1';
        }
        for(int i = 0 ; i < itemConservacion.length ; i ++){
            checkConservacion[itemConservacion[i]['value']] = '-1';
        }
       

    }

    bool _guardando = false;
    var uuid = Uuid();
    Punto punto = Punto();
    List<Punto> listaPuntos = [];
    String idTestSuelo;   
    int variableVacia;
    
    @override
    void initState() {
        super.initState();
        checkKeys();
    }

    @override
    Widget build(BuildContext context) {

        idTestSuelo = ModalRoute.of(context).settings.arguments;

        List<Widget> pageItem = List<Widget>();
        
        pageItem.add(_pageErosion());
        pageItem.add(_pageConservacion());

        pageItem.add(_botonsubmit(idTestSuelo)); 

        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            body: Column(
                children: [
                    Container(
                        child: Column(
                            children: [
                                TitulosPages(titulo: 'Punto'),
                                Divider(),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                    
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                            Container(
                                                width: 200,
                                                child: Text(
                                                        "Deslice hacia la derecha para continuar con el formulario",
                                                        textAlign: TextAlign.center,
                                                        style: Theme.of(context).textTheme
                                                            .headline5
                                                            .copyWith(fontWeight: FontWeight.w600, fontSize: 14)
                                                    )
                                            
                                            ),
                                            
                                            
                                            Transform.rotate(
                                                angle: 90 * math.pi / 180,
                                                child: Icon(
                                                    Icons.arrow_circle_up_rounded,
                                                    size: 25,
                                                ),
                                                
                                            ),
                                        ],
                                    ),
                                ),
                            ],
                        )
                    ),
                    Expanded(
                        
                        child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                                return pageItem[index];
                            },
                            itemCount: pageItem.length,
                            viewportFraction: 1,
                            loop: false,
                            scale: 1,
                        ),
                    ),
                ],
            )
        );
        
    }

    Widget _tituloPregunta(String titulo){
        
        return  Column(
            children: [
                Container(
                    child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                            titulo,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                        ),
                    )
                ),
                Divider(),
                
            ],
        );
    }


    Widget _labelTipo(int tipo){
        
        return  Column(
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Text('', style: Theme.of(context).textTheme.headline6
                                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
                        Container(
                            width: 60,
                            child: Text('No', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600,) ),
                        ),
                        Container(
                            width: 60,
                            child: Text(tipo == 1 ? 'Algo' : 'Mala', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600,) ),
                        ),
                        Container(
                            width: 60,
                            child: Text(tipo == 1 ? 'Severo' : 'Buena', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6
                                            .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                    ],
                ),
                Divider(),
            ],
        );
    }


    Widget _pageErosion(){
        List<Widget> _pageQuestion = List<Widget>();

        _pageQuestion.add(
            _tituloPregunta('Observaciones de erosión')
            
        );
        _pageQuestion.add(
           _labelTipo(1)
        );
        

        _pageQuestion.add(

            ListView.builder(
                
                itemBuilder: (BuildContext context, int index) {
                    
                    String labelPlaga = itemErosion.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    return Column(
                        children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    Expanded(child: Text('$labelPlaga', style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value: '1',
                                                groupValue: checkErosion[itemErosion[index]['value']],
                                                onChanged: (value){
                                                    setState(() {
                                                        checkErosion[itemErosion[index]['value']] = value;
                                                    });
                                                },
                                                activeColor: Colors.teal[900],
                                            ),
                                        ),
                                    ),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value:'2',
                                                groupValue: checkErosion[itemErosion[index]['value']],
                                                onChanged: (value){
                                                    setState(() {
                                                        checkErosion[itemErosion[index]['value']] = value;
                                                    });
                                                },
                                                activeColor: Colors.teal[900],
                                            ),
                                        ),
                                    ),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value:'3',
                                                groupValue: checkErosion[itemErosion[index]['value']],
                                                onChanged: (value){
                                                    setState(() {
                                                        checkErosion[itemErosion[index]['value']] = value;
                                                    });
                                                },
                                                activeColor: Colors.teal[900],
                                            ),
                                        ),
                                    ),
                                

                                ],
                            ),
                            Divider()
                        ],
                    );
            
                },
                shrinkWrap: true,
                itemCount: itemErosion.length,
                physics: NeverScrollableScrollPhysics(),
            )
        );
        
        return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                                color: Color(0xFF3A5160)
                                    .withOpacity(0.05),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 17.0),
                        ],
                ),
                child: Column(children:_pageQuestion,)
            ),
        );
    }

    Widget _pageConservacion(){
        List<Widget> _pageQuestion = List<Widget>();

        _pageQuestion.add(
            _tituloPregunta('Obras de conservación de suelo')
            
        );
        _pageQuestion.add(
           _labelTipo(2)
        );
        

        _pageQuestion.add(

            ListView.builder(
                
                itemBuilder: (BuildContext context, int index) {
                    
                    String labelPlaga = itemConservacion.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    return Column(
                        children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    Expanded(child: Text('$labelPlaga', style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value: '1',
                                                groupValue: checkConservacion[itemConservacion[index]['value']],
                                                onChanged: (value){
                                                    setState(() {
                                                        checkConservacion[itemConservacion[index]['value']] = value;
                                                    });
                                                },
                                                activeColor: Colors.teal[900],
                                            ),
                                        ),
                                    ),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value:'2',
                                                groupValue: checkConservacion[itemConservacion[index]['value']],
                                                onChanged: (value){
                                                    setState(() {
                                                        checkConservacion[itemConservacion[index]['value']] = value;
                                                    });
                                                },
                                                activeColor: Colors.teal[900],
                                            ),
                                        ),
                                    ),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value:'3',
                                                groupValue: checkConservacion[itemConservacion[index]['value']],
                                                onChanged: (value){
                                                    setState(() {
                                                        checkConservacion[itemConservacion[index]['value']] = value;
                                                    });
                                                },
                                                activeColor: Colors.teal[900],
                                            ),
                                        ),
                                    ),
                                

                                ],
                            ),
                            Divider()
                        ],
                    );
            
                },
                shrinkWrap: true,
                itemCount: itemConservacion.length,
                physics: NeverScrollableScrollPhysics(),
            )
        );
        
        return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                                color: Color(0xFF3A5160)
                                    .withOpacity(0.05),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 17.0),
                        ],
                ),
                child: Column(children:_pageQuestion,)
            ),
        );
    }


    Widget  _botonsubmit(String idpoda){

        return SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                                color: Color(0xFF3A5160)
                                    .withOpacity(0.05),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 17.0),
                        ],
                ),
                child: Column(
                    children: [
                        Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 30),
                            child: Text(
                                "¿Ha Terminado todos los formularios de toma de desición?",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w600)
                            ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: RaisedButton.icon(
                                icon:Icon(Icons.save),
                                label: Text('Guardar',
                                    style: Theme.of(context).textTheme
                                        .headline6
                                        .copyWith(fontWeight: FontWeight.w600, color: Colors.white)
                                ),
                                padding:EdgeInsets.all(13),
                                onPressed:(_guardando) ? null : _submit,
                                
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    _listaPuntos(Map checksPregunta, int pregunta){
       
        checksPregunta.forEach((key, value) {
            final Punto itemPunto = Punto();
            itemPunto.id = uuid.v1();
            itemPunto.idPregunta = pregunta;
            itemPunto.idItem = int.parse(key);
            itemPunto.repuesta = int.parse(value);
            itemPunto.idTest = idTestSuelo;
            if (itemPunto.repuesta == -1) {
                variableVacia ++;
            }
            listaPuntos.add(itemPunto);
        });
    }



    void _submit(){
        variableVacia = 0;
        setState(() {_guardando = true;});

        _listaPuntos(checkErosion, 1);
        _listaPuntos(checkConservacion, 2);


        if  ( variableVacia !=  0){
            mostrarSnackbar(variableVacia);
            return null;
        }

        listaPuntos.forEach((punto) {
            DBProvider.db.nuevoPunto(punto);
        });
        
        fincasBloc.obtenerPuntos(idTestSuelo);
        setState(() {_guardando = false;});

        Navigator.pop(context, 'estaciones');
    }

    void mostrarSnackbar(int variableVacias){
        final snackbar = SnackBar(
            content: Text('Hay $variableVacias Campos Vacios, Favor llene todo los campos',
                style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
        );
        setState(() {_guardando = false;});
        scaffoldKey.currentState.showSnackBar(snackbar);
    }

   
    // Widget  _botonsubmit(tituloBtn){
    //     return RaisedButton.icon(
            
    //         icon:Icon(Icons.save, color: Colors.white,),
            
    //         label: Text(tituloBtn,
    //             style: Theme.of(context).textTheme
    //                 .headline6
    //                 .copyWith(fontWeight: FontWeight.w600, color: Colors.white)
    //         ),
    //         padding:EdgeInsets.symmetric(vertical: 13, horizontal: 50),
    //         onPressed:(_guardando) ? null : _submit,
    //     );
    // }

    
    


    // void _submit(){

    //     if  ( !formKey.currentState.validate() ){
    //         //Cuendo el form no es valido
    //         return null;
    //     }

    //     formKey.currentState.save();

    //     setState(() {_guardando = true;});

    //     // print(finca.id);
    //     // print(finca.userid);
    //     // print(finca.nombreFinca);
    //     // print(finca.areaFinca);
    //     // print(finca.tipoMedida);
    //     if(finca.id == null){
    //         finca.id = uuid.v1();
    //         //print(finca.id);
    //         fincasBloc.addFinca(finca);
    //     }else{
    //         //print(finca.id);
    //         fincasBloc.actualizarFinca(finca);
    //     }

    //     setState(() {_guardando = false;});
    //     mostrarSnackbar('Registro Guardado');


    //     Navigator.pop(context, 'fincas');
       
        
    // }

    
    // void mostrarSnackbar(String mensaje){
    //     final snackbar = SnackBar(
    //         content: Text(mensaje),
    //         duration: Duration(microseconds: 1500),
    //     );

    //     scaffoldKey.currentState.showSnackBar(snackbar);
    // }
}