import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/decisiones_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/dialogDelete.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';

class RecorridoPage extends StatefulWidget {
  RecorridoPage({Key key}) : super(key: key);

  @override
  _RecorridoPageState createState() => _RecorridoPageState();
}

class _RecorridoPageState extends State<RecorridoPage> {

    final fincasBloc = new FincasBloc();
    

    @override
    Widget build(BuildContext context) {
        
        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        List<Punto> puntos = [];
        fincasBloc.obtenerPuntos(suelo.id);

        return Scaffold(
            appBar: AppBar(),
            body: StreamBuilder<List<Punto>>(
                stream: fincasBloc.puntoStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    print(snapshot.data);
                    puntos = snapshot.data;

                    if (puntos.length == 0) {
                        return Column(
                            children: [
                                TitulosPages(titulo: 'Titulo'),
                                Divider(), 
                                Expanded(child: Center(
                                    child: Text('No hay datos: \nIngrese datos de pasos', 
                                    textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.headline6,
                                        )
                                    )
                                )
                            ],
                        );
                    }
                    
                    return Column(
                        children: [
                            TitulosPages(titulo: 'Titulo'),
                            Divider(),                            
                            Expanded(
                                child: SingleChildScrollView(
                                    child: _listaDePisos(puntos, context)
                                    
                                )
                            ),
                        ],
                    );
                },
            ),
            bottomNavigationBar: BottomAppBar(
                child: Container(
                    color: kBackgroundColor,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _countPiso(puntos, suelo)
                    ),
                ),
            ),
        );
    }

    Widget  _listaDePisos(List<Punto> puntos, BuildContext context){

        return ListView.builder(
            itemBuilder: (context, index) {

                return Dismissible(
                    key: UniqueKey(),
                    child: GestureDetector(
                        child:Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.5),
                                    boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF3A5160)
                                                .withOpacity(0.05),
                                            offset: const Offset(1.1, 1.1),
                                            blurRadius: 17.0),
                                        ],
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        
                                        Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                            child: Text(
                                                "Punto ${index+1}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.headline6,
                                            ),
                                        ),
                                    ],
                                ),
                        )
                    ),
                    confirmDismiss: (direction) => confirmacionUser(direction, context),
                    direction: DismissDirection.endToStart,
                    background: backgroundTrash(context),
                    movementDuration: Duration(milliseconds: 500),
                    //onDismissed: (direction) => fincasBloc.borrarPaso(paso[index]),
                );
                
            },
            shrinkWrap: true,
            itemCount: puntos.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget  _countPiso(List<Punto> puntos, TestSuelo suelo){
                
                int value = puntos.length;
                
                if (value < 5) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Text('Puntos: $value / 5',
                                style: Theme.of(context).textTheme
                                        .headline6
                                        .copyWith(fontWeight: FontWeight.w600)
                            ),
                            _addPaso(suelo ),
                        ],
                    );
                }else{
                    
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Container(
                                child: Text('Pasos: $value / 20',
                                    style: Theme.of(context).textTheme
                                            .headline6
                                            .copyWith(fontWeight: FontWeight.w600)
                                ),
                            ),
                            RaisedButton.icon(
                                icon:Icon(Icons.navigate_next_rounded),                               
                                label: Text('Siguiente caminata',
                                    style: Theme.of(context).textTheme
                                        .headline6
                                        .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16)
                                ),
                                padding:EdgeInsets.all(13),
                                onPressed:() => Navigator.popAndPushNamed(context, 'pasos',),
                            )
                        ],
                    );
                }

            
    }

    Widget  _addPaso(TestSuelo suelo){
        return RaisedButton.icon(
            
            icon:Icon(Icons.add_circle_outline_outlined),
            
            label: Text('Agregar punto',
                style: Theme.of(context).textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16)
            ),
            padding:EdgeInsets.all(13),
            onPressed:() => Navigator.pushNamed(context, 'agregarPunto', arguments: suelo.id),
        );
    }
    
}