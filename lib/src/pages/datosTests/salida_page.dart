import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/pages/datosTests/balance_recorrido.dart' as balancePage;
import 'package:app_suelo/src/pages/datosTests/fertilizacion.dart' as nuevoBalance;
import 'package:flutter/material.dart';


class SalidaPage extends StatefulWidget{
    @override
    SalidaPageState createState() => new SalidaPageState();
}

class SalidaPageState extends State<SalidaPage> with SingleTickerProviderStateMixin{
    
    TabController controller;
    final fincasBloc = new FincasBloc();

    Future _getdataFinca(TestSuelo textSuelo) async{
        Finca finca = await DBProvider.db.getFincaId(textSuelo.idFinca);
        Parcela parcela = await DBProvider.db.getParcelaId(textSuelo.idLote);

        DBProvider.db.monitoreo(textSuelo.id);
        
        return [finca, parcela];
    }

    @override
    void initState(){
        super.initState();
        controller = TabController(vsync: this, length: 2);
    }

    @override
    void dispose(){
        controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context){
        
        TestSuelo suelo = ModalRoute.of(context).settings.arguments;

        return Scaffold(
            appBar: AppBar(),
            bottomNavigationBar: Material(
                //color: Colors.deepOrange,
                child: TabBar(
                    isScrollable: false,
                    controller: controller,
                    
                    tabs: <Tab>[
                        Tab(
                            text: 'Balance de\nNutrientes',
                        ),
                        Tab(
                            text: 'Propuesta\nfertilización',
                        ),
                    ]
                )
            ),
            body: Column(
                children: [
                    escabezadoEstacion( context, suelo ),
                    Expanded(
                        
                        child:TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: controller,
                            children: <Widget>[
                                balancePage.BalanceRecorrido(),
                                nuevoBalance.NuevoBalance()
                            ]
                        ),
                    ),
                    
                ],
            ),
            
            
        );
    }

    Widget escabezadoEstacion( BuildContext context, TestSuelo suelo ){

        return FutureBuilder(
            future: _getdataFinca(suelo),
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


}