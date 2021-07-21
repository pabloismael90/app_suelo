
import 'package:app_suelo/src/models/punto_model.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';

import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
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
    final List<Map<String, dynamic>>  itemObservacion = selectMap.drenaje();
    final List<Map<String, dynamic>>  itemObras = selectMap.obrasDrenaje();
    final List<Map<String, dynamic>>  itemRaiz = selectMap.raiz();
    
    final Map checkErosion = {};
    final Map checkConservacion = {};
    final Map checkObservacion = {};
    final Map checkObras = {};
    final Map checkRaiz = {};

    void checkKeys(){

        for(int i = 0 ; i < itemErosion.length ; i ++){
            checkErosion[itemErosion[i]['value']] = '-1';
        }
        for(int i = 0 ; i < itemConservacion.length ; i ++){
            checkConservacion[itemConservacion[i]['value']] = '-1';
        }
        for(int i = 0 ; i < itemObservacion.length ; i ++){
            checkObservacion[itemObservacion[i]['value']] = '-1';
        }
        for(int i = 0 ; i < itemObras.length ; i ++){
            checkObras[itemObras[i]['value']] = '-1';
        }
        for(int i = 0 ; i < itemRaiz.length ; i ++){
            checkRaiz[itemRaiz[i]['value']] = '-1';
        }
       

    }

    bool _guardando = false;
    var uuid = Uuid();
    Punto punto = Punto();
    List<Punto> listaPuntos = [];
    String? idTestSuelo;
    int? numeroPunto;   
    int? variableVacia;
    
    @override
    void initState() {
        super.initState();
        checkKeys();
    }

    @override
    Widget build(BuildContext context) {

        List dataPuntos = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
        idTestSuelo = dataPuntos[0];
        numeroPunto = dataPuntos[1]+1;
        
        List<Widget> pageItem =  [];
        
        pageItem.add(_pageErosion());
        pageItem.add(_pageConservacion());
        pageItem.add(_pageObservacion());
        pageItem.add(_pageObras());
        pageItem.add(_pageRaiz());

        pageItem.add(_botonsubmit()); 

        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text('Toma de punto'),),
            body: Column(
                children: [
                    mensajeSwipe('Deslice hacia la izquierda para continuar con el formulario'),
                    Expanded(
                        
                        child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(15),
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
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
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
                        Expanded(child: textList('')),
                        Container(
                            width: 60,
                            child: titleList('No'),
                        ),
                        Container(
                            width: 60,
                            child: titleList(tipo == 1 ? 'Algo' : 'Mala'),
                        ),
                        Container(
                            width: 60,
                            child: titleList(tipo == 1 ? 'Severo' : 'Buena'),
                        ),
                    ],
                ),
                Divider(),
            ],
        );
    }

    Widget _pageErosion(){
        List<Widget> _pageQuestion =  [];

        _pageQuestion.add(
            _tituloPregunta('Observaciones de erosión')
            
        );
        _pageQuestion.add(
           _labelTipo(1)
        );
        

        _pageQuestion.add(

            ListView.builder(
                
                itemBuilder: (BuildContext context, int index) {
                    
                    String? labelPlaga = itemErosion.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    return Column(
                        children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    Expanded(
                                        child: textList('$labelPlaga')
                                    ),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value: '1',
                                                groupValue: checkErosion[itemErosion[index]['value']],
                                                onChanged: (dynamic value){
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
                                                onChanged: (dynamic value){
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
                                                onChanged: (dynamic value){
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
            child: Column(children:_pageQuestion,),
        );
    }

    Widget _pageConservacion(){
        List<Widget> _pageQuestion =  [];

        _pageQuestion.add(
            _tituloPregunta('Obras de conservación de suelo')
            
        );
        _pageQuestion.add(
           _labelTipo(2)
        );
        

        _pageQuestion.add(

            ListView.builder(
                
                itemBuilder: (BuildContext context, int index) {
                    
                    String? labelPlaga = itemConservacion.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    return Column(
                        children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    Expanded(child: textList('$labelPlaga')),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value: '1',
                                                groupValue: checkConservacion[itemConservacion[index]['value']],
                                                onChanged: (dynamic value){
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
                                                onChanged: (dynamic value){
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
                                                onChanged: (dynamic value){
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
            child: Column(children:_pageQuestion,),
        );
    }

    Widget _pageObservacion(){
        List<Widget> _pageQuestion =  [];

        _pageQuestion.add(
            _tituloPregunta('Observaciones de drenaje')
            
        );
        _pageQuestion.add(
           _labelTipo(1)
        );
        

        _pageQuestion.add(

            ListView.builder(
                
                itemBuilder: (BuildContext context, int index) {
                    
                    String? labelPlaga = itemObservacion.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    return Column(
                        children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    Expanded(child: textList('$labelPlaga')),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value: '1',
                                                groupValue: checkObservacion[itemObservacion[index]['value']],
                                                onChanged: (dynamic value){
                                                    setState(() {
                                                        checkObservacion[itemObservacion[index]['value']] = value;
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
                                                groupValue: checkObservacion[itemObservacion[index]['value']],
                                                onChanged: (dynamic value){
                                                    setState(() {
                                                        checkObservacion[itemObservacion[index]['value']] = value;
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
                                                groupValue: checkObservacion[itemObservacion[index]['value']],
                                                onChanged: (dynamic value){
                                                    setState(() {
                                                        checkObservacion[itemObservacion[index]['value']] = value;
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
                itemCount: itemObservacion.length,
                physics: NeverScrollableScrollPhysics(),
            )
        );
        
        return SingleChildScrollView(
            child: Column(children:_pageQuestion,),
        );
    }

    Widget _pageObras(){
        List<Widget> _pageQuestion =  [];

        _pageQuestion.add(
            _tituloPregunta('Obras de drenaje')
            
        );
        _pageQuestion.add(
           _labelTipo(2)
        );
        

        _pageQuestion.add(

            ListView.builder(
                
                itemBuilder: (BuildContext context, int index) {
                    
                    String? labelPlaga = itemObras.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    return Column(
                        children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    Expanded(child: textList('$labelPlaga')),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value: '1',
                                                groupValue: checkObras[itemObras[index]['value']],
                                                onChanged: (dynamic value){
                                                    setState(() {
                                                        checkObras[itemObras[index]['value']] = value;
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
                                                groupValue: checkObras[itemObras[index]['value']],
                                                onChanged: (dynamic value){
                                                    setState(() {
                                                        checkObras[itemObras[index]['value']] = value;
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
                                                groupValue: checkObras[itemObras[index]['value']],
                                                onChanged: (dynamic value){
                                                    setState(() {
                                                        checkObras[itemObras[index]['value']] = value;
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
                itemCount: itemObras.length,
                physics: NeverScrollableScrollPhysics(),
            )
        );
        
        return SingleChildScrollView(
            child: Column(children:_pageQuestion,),
        );
    }

    Widget _pageRaiz(){
        List<Widget> _pageQuestion =  [];

        _pageQuestion.add(
            _tituloPregunta('Enfermedades de raíz')
            
        );
        _pageQuestion.add(
           _labelTipo(1)
        );
        

        _pageQuestion.add(

            ListView.builder(
                
                itemBuilder: (BuildContext context, int index) {
                    
                    String? labelPlaga = itemRaiz.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    return Column(
                        children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    Expanded(child: textList('$labelPlaga')),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value: '1',
                                                groupValue: checkRaiz[itemRaiz[index]['value']],
                                                onChanged: (dynamic value){
                                                    setState(() {
                                                        checkRaiz[itemRaiz[index]['value']] = value;
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
                                                groupValue: checkRaiz[itemRaiz[index]['value']],
                                                onChanged: (dynamic value){
                                                    setState(() {
                                                        checkRaiz[itemRaiz[index]['value']] = value;
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
                                                groupValue: checkRaiz[itemRaiz[index]['value']],
                                                onChanged: (dynamic value){
                                                    setState(() {
                                                        checkRaiz[itemRaiz[index]['value']] = value;
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
                itemCount: itemRaiz.length,
                physics: NeverScrollableScrollPhysics(),
            )
        );
        
        return SingleChildScrollView(
            child: Column(children:_pageQuestion,),
        );
    }

    Widget  _botonsubmit(){
        return SingleChildScrollView(
            child: Container(
                child: Column(
                    children: [
                        Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 30),
                            child: Text(
                                "¿Ha Terminado todos los formularios del punto?",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: ButtonMainStyle(
                                title: 'Guardar',
                                icon: Icons.save,
                                press: (_guardando) ? null : _submit,
                            )
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
            itemPunto.idTest = idTestSuelo;
            itemPunto.nPunto = numeroPunto;
            itemPunto.idPregunta = pregunta;
            itemPunto.idItem = int.parse(key);
            itemPunto.repuesta = int.parse(value);
            if (itemPunto.repuesta == -1) {
                variableVacia = variableVacia!+1;
            }
            listaPuntos.add(itemPunto);
        });
    }



    void _submit(){
        variableVacia = 0;
        listaPuntos = [];
        setState(() {_guardando = true;});

        _listaPuntos(checkErosion, 1);
        _listaPuntos(checkConservacion, 2);
        _listaPuntos(checkObservacion, 3);
        _listaPuntos(checkObras, 4);
        _listaPuntos(checkRaiz, 5);


        if  ( variableVacia !=  0){
            mostrarSnackbar('Hay $variableVacia Campos Vacios, Favor llene todo los campos', context);
            setState(() {_guardando = false;});
            return null;
        }

        listaPuntos.forEach((punto) {
            DBProvider.db.nuevoPunto(punto);
        });
        
        fincasBloc.obtenerPuntos(idTestSuelo);
        setState(() {_guardando = false;});
        mostrarSnackbar('Registro punto guardado', context);
        Navigator.pop(context, 'estaciones');
    }


   

}