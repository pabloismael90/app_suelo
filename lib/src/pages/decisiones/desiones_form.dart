import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/acciones_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:uuid/uuid.dart';

class DecisionesPage extends StatefulWidget {
  DecisionesPage({Key key}) : super(key: key);

  @override
  _DecisionesPageState createState() => _DecisionesPageState();
}



class _DecisionesPageState extends State<DecisionesPage> {

    Size size;
    var uuid = Uuid();
    bool _guardando = false;
    final fincasBloc = new FincasBloc();
    TestSuelo suelo ;
    List<Acciones> listaAcciones = [];

    final List<Map<String, dynamic>>  _meses = selectMap.listMeses();
    final List<Map<String, dynamic>>  listSoluciones = selectMap.solucionesXmes();

    final Map itemActividad = {};
    final Map itemResultado = {};

    void checkKeys(){

        for(int i = 0 ; i < listSoluciones.length ; i ++){
            itemActividad[i] = [];
            itemResultado[i] = '';
        }
    }

    @override
    void initState() {
        super.initState();
        checkKeys();
    }

    @override
    Widget build(BuildContext context) {

        suelo = ModalRoute.of(context).settings.arguments;
        size = MediaQuery.of(context).size;
                

        return Scaffold(
            appBar: AppBar(),
            body: Column(
                children: [
                    TitulosPages(titulo: 'Toma de Decisión'),
                    Expanded(
                        child: _accionesMeses(),
                    ),
                ],
            )
            
        );
    }
    

    Widget _accionesMeses(){

        List<Widget> listaAcciones = List<Widget>();
        listaAcciones.add(
            
            Column(
                children: [
                    Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                                "Nueva propuesta de manejo de suelo",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 16)
                            ),
                        )
                    ),
                    Divider(),
                ],
            )
            
        );
        for (var i = 0; i < listSoluciones.length; i++) {
            String labelSoluciones = listSoluciones.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            listaAcciones.add(
                Container(
                    padding: EdgeInsets.all(16),
                    child: MultiSelectFormField(
                        autovalidate: false,
                        chipBackGroundColor: Colors.deepPurple,
                        chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                        dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        checkBoxActiveColor: Colors.deepPurple,
                        checkBoxCheckColor: Colors.white,
                        dialogShapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))
                        ),
                        title: Text(
                            "$labelSoluciones",
                            style: TextStyle(fontSize: 16),
                        ),
                        validator: (value) {
                            if (value == null || value.length == 0) {
                            return 'Seleccione una o mas opciones';
                            }
                            return null;
                        },
                        dataSource: _meses,
                        textField: 'label',
                        valueField: 'value',
                        okButtonLabel: 'Aceptar',
                        cancelButtonLabel: 'Cancelar',
                        hintWidget: Text('Seleccione una o mas meses'),
                        initialValue: itemActividad[i],
                        onSaved: (value) {
                            if (value == null) return;
                                setState(() {
                                itemActividad[i] = value;
                            });
                        },
                    ),
                )
            );
        }

        listaAcciones.add(_botonsubmit());

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
                child: Column(children:listaAcciones,)
            ),
        );
    }

    Widget  _botonsubmit(){

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
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
        );
    }



    _listaAcciones(){

        //print(itemActividad);
        itemActividad.forEach((key, value) {
            final Acciones itemAcciones = Acciones();
            itemAcciones.id = uuid.v1();
            itemAcciones.idItem = key;
            itemAcciones.repuesta = value.toString();
            itemAcciones.idTest = suelo.id ;
            
            listaAcciones.add(itemAcciones);
        });
    }

    void _submit(){
        setState(() {_guardando = true;});
 

        _listaAcciones();
        
        listaAcciones.forEach((accion) {
            // print("Id item: ${accion.idItem}");
            // print("Id Respues: ${accion.repuesta}");
            // print("Id prueba: ${accion.idTest}");
            DBProvider.db.nuevaAccion(accion);
        });

        fincasBloc.obtenerAcciones(suelo.id);
        setState(() {_guardando = false;});

        Navigator.pop(context, 'salidaPage');
    }





}

