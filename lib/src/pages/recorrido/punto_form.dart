
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';

import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
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
    
    final Map checkErosion = {};

    void checkKeys(){

        for(int i = 0 ; i < itemErosion.length ; i ++){
            checkErosion[itemErosion[i]['value']] = '-1';
        }
       

    }

    //bool _guardando = false;
    var uuid = Uuid();
        

    
    @override
    void initState() {
        super.initState();
        checkKeys();
    }

    @override
    Widget build(BuildContext context) {

        final String idTestSuelo = ModalRoute.of(context).settings.arguments;
        List<Widget> pageItem = List<Widget>();
        
        pageItem.add(_pageErosion());
        return Scaffold(
            appBar: AppBar(),
            body: Column(
                children: [
                    Container(
                        child: Column(
                            children: [
                                TitulosPages(titulo: 'Toma de Decisiones'),
                                Divider(),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                        "Deslice hacia la derecha para continuar con el formulario",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme
                                            .headline5
                                            .copyWith(fontWeight: FontWeight.w600, fontSize: 16)
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
        List<Widget> listHierbaProblema = List<Widget>();

        listHierbaProblema.add(
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "Observaciones de erosión",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18)
                            ),
                        )
                    ),
                    Divider(),
                    
                ],
            )
            
        );
        listHierbaProblema.add(
           _labelTipo(1)
        );
        

        listHierbaProblema.add(

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
                                                groupValue: checkErosion[itemErosion[index]],
                                                onChanged: (value){
                                                    setState(() {
                                                        checkErosion[itemErosion[index]] = value;
                                                        print(checkErosion[itemErosion[index]]);
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
                                                groupValue: checkErosion[itemErosion[index]],
                                                onChanged: (value){
                                                    setState(() {
                                                        checkErosion[itemErosion[index]] = value;
                                                        print(checkErosion[itemErosion[index]]);
                                                    });
                                                },
                                                activeColor: Colors.red[900],
                                            ),
                                        ),
                                    ),
                                    Container(
                                        width: 60,
                                        child: Transform.scale(
                                            scale: 1.2,
                                            child: Radio(
                                                value:'3',
                                                groupValue: checkErosion[itemErosion[index]],
                                                onChanged: (value){
                                                    setState(() {
                                                        checkErosion[itemErosion[index]] = value;
                                                        print(checkErosion[itemErosion[index]]);
                                                    });
                                                },
                                                activeColor: Colors.red[900],
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
                child: Column(children:listHierbaProblema,)
            ),
        );
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