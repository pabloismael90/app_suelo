import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/finca_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';

class TodaDatos extends StatefulWidget {
    const TodaDatos({Key key}) : super(key: key);

  @override
  _TodaDatosState createState() => _TodaDatosState();
}

class _TodaDatosState extends State<TodaDatos> {

    final fincasBloc = new FincasBloc();

    Future _getdataFinca(TestSuelo textPlaga) async{
        Finca finca = await DBProvider.db.getFincaId(textPlaga.idFinca);
        Parcela parcela = await DBProvider.db.getParcelaId(textPlaga.idLote);
        //List<Decisiones> desiciones = await DBProvider.db.getDecisionesIdTest(textPlaga.id);
        
        return [finca, parcela];
    }

    @override
    Widget build(BuildContext context) {
        
        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        

       return Scaffold(
            appBar: AppBar(),
            body: Column(
                children: [
                    escabezadoEstacion( context, suelo ),
                    TitulosPages(titulo: 'Estaciones'),
                    Divider(),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Text('no se'),
                        ),
                    ),
                ],
            ),
            // bottomNavigationBar: BottomAppBar(
            //     child: _tomarDecisiones(countEstaciones, poda)
            // ),
        );
    }



    Widget escabezadoEstacion( BuildContext context, TestSuelo poda ){


        return FutureBuilder(
            future: _getdataFinca(poda),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                }
                Finca finca = snapshot.data[0];
                Parcela parcela = snapshot.data[1];

                return Container(
                    
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                            
                            Flexible(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                    
                                        Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10.0),
                                            child: Text(
                                                "${finca.nombreFinca}",
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context).textTheme.headline6,
                                            ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only( bottom: 10.0),
                                            child: Text(
                                                "${parcela.nombreLote}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: kLightBlackColor),
                                            ),
                                        ),
                                        
                                    ],  
                                ),
                            ),
                        ],
                    ),
                );
            },
        );        
    }

    // Widget  _listaDeEstaciones( BuildContext context, TestPoda poda, List countEstaciones){
    //     return ListView.builder(
    //         itemBuilder: (context, index) {
    //             String estadoConteo;
    //             if (countEstaciones[index] >= 10){
    //                 estadoConteo =  'Completo';
    //             }else{
    //                estadoConteo =  'Incompleto'; 
    //             }
    //             return GestureDetector(
                    
    //                 child: _cardTest(index+1,countEstaciones[index], estadoConteo),
    //                 onTap: () => Navigator.pushNamed(context, 'plantas', arguments: [poda, index]),
    //             );
                
               
    //         },
    //         shrinkWrap: true,
    //         itemCount:  poda.estaciones,
    //         padding: EdgeInsets.only(bottom: 30.0),
    //         controller: ScrollController(keepScrollOffset: false),
    //     );

    // }

    // Widget _cardTest(int estacion, int numeroPlantas, String estado){
    //     return Container(
    //         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    //         width: double.infinity,
    //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(13),
    //                 boxShadow: [
    //                     BoxShadow(
    //                             color: Color(0xFF3A5160)
    //                                 .withOpacity(0.05),
    //                             offset: const Offset(1.1, 1.1),
    //                             blurRadius: 17.0),
    //                     ],
    //             ),
    //             child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
                        
    //                     Flexible(
    //                         child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: <Widget>[
                                
    //                                 Padding(
    //                                     padding: EdgeInsets.only(top: 10, bottom: 10.0),
    //                                     child: Text(
    //                                         "Estación $estacion",
    //                                         softWrap: true,
    //                                         overflow: TextOverflow.ellipsis,
    //                                         maxLines: 2,
    //                                         style: Theme.of(context).textTheme.headline6,
    //                                     ),
    //                                 ),
                                    
                                    
    //                                 Padding(
    //                                     padding: EdgeInsets.only( bottom: 10.0),
    //                                     child: Text(
    //                                         '$estado',
    //                                         style: TextStyle(color: kLightBlackColor),
    //                                     ),
    //                                 ),
    //                             ],  
    //                         ),
    //                     ),
    //                     Container(
    //                         child: CircularPercentIndicator(
    //                             radius: 70.0,
    //                             lineWidth: 5.0,
    //                             animation: true,
    //                             percent: numeroPlantas/10,
    //                             center: new Text("${(numeroPlantas/10)*100}%"),
    //                             progressColor: Color(0xFF498C37),
    //                         ),
    //                     )
                        
                        
                        
    //                 ],
    //             ),
    //     );
    // }
   

    // Widget  _tomarDecisiones(List countEstaciones, TestPoda poda){
        
    //     if(countEstaciones[0] >= 10 && countEstaciones[1] >= 10 && countEstaciones[2] >= 10){
            
    //         return StreamBuilder(
    //         stream: fincasBloc.decisionesStream ,
    //             builder: (BuildContext context, AsyncSnapshot snapshot) {
    //                 if (!snapshot.hasData) {
    //                     return Center(child: CircularProgressIndicator());
    //                 }
    //                 List<Decisiones> desiciones = snapshot.data;

    //                 //print(desiciones);

    //                 if (desiciones.length == 0){

    //                     return Container(
    //                         color: kBackgroundColor,
    //                         child: Padding(
    //                             padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
    //                             child: RaisedButton.icon(
    //                                 icon:Icon(Icons.add_circle_outline_outlined),
                                    
    //                                 label: Text('Toma de decisiones',
    //                                     style: Theme.of(context).textTheme
    //                                         .headline6
    //                                         .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
    //                                 ),
    //                                 padding:EdgeInsets.all(13),
    //                                 onPressed: () => Navigator.pushNamed(context, 'decisiones', arguments: poda),
    //                             )
    //                         ),
    //                     );
                        
    //                 }


    //                 return Container(
    //                     color: kBackgroundColor,
    //                     child: Padding(
    //                         padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
    //                         child: RaisedButton.icon(
    //                             icon:Icon(Icons.receipt_rounded),
                            
    //                             label: Text('Consultar decisiones',
    //                                 style: Theme.of(context).textTheme
    //                                     .headline6
    //                                     .copyWith(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14)
    //                             ),
    //                             padding:EdgeInsets.all(13),
    //                             onPressed: () => Navigator.pushNamed(context, 'reporte', arguments: poda.id),
    //                         )
    //                     ),
    //                 );
                                       
    //             },  
    //         );
    //     }
        

    //     return Container(
    //         color: kBackgroundColor,
    //         child: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //             child: Text(
    //                 "Complete las estaciones",
    //                 textAlign: TextAlign.center,
    //                 style: Theme.of(context).textTheme
    //                     .headline5
    //                     .copyWith(fontWeight: FontWeight.w900, color: kRedColor, fontSize: 22)
    //             ),
    //         ),
    //     );
    // }
}