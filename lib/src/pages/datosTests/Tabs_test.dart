import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/pages/datosTests/balanceActual.dart' as balancePage;
import 'package:app_suelo/src/pages/datosTests/balancePropuesta.dart' as nuevoBalance;
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';


class SalidaPage extends StatefulWidget{
    @override
    SalidaPageState createState() => new SalidaPageState();
}

class SalidaPageState extends State<SalidaPage> with SingleTickerProviderStateMixin{
    
    TabController? controller;
    final fincasBloc = new FincasBloc();

    Future _getdataFinca(TestSuelo textSuelo) async{
        Finca? finca = await DBProvider.db.getFincaId(textSuelo.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(textSuelo.idLote);

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
        controller!.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context){
        
        TestSuelo suelo = ModalRoute.of(context)!.settings.arguments as TestSuelo;

        return Scaffold(
            appBar: AppBar(title: Text('Completar datos'),),
            bottomNavigationBar: Material(
                color: kbase,
                child: SafeArea(
                    
                    child: TabBar(
                        isScrollable: false,
                        controller: controller,
                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(width: 3.0,color: Color.fromARGB(27, 38, 69, 30)),
                            insets: EdgeInsets.symmetric(horizontal:16.0),
                        ),
                        indicatorColor: Color.fromARGB(42, 134, 145, 4),
                        labelColor: Colors.white,
                        tabs: <Tab>[
                            Tab(
                                text: 'Balance de\nNutrientes',
                            ),
                            Tab(
                                text: 'Propuesta\nfertilización',
                            ),
                        ]
                    ),
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
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            encabezadoCard('${finca.nombreFinca}','Parcela: ${parcela.nombreLote}', 'assets/icons/finca.svg'),
                            Wrap(
                                spacing: 20,
                                children: [
                                    textoCardBody('Productor: ${finca.nombreProductor}'),
                                    textoCardBody('Área finca: ${finca.areaFinca}'),
                                    textoCardBody('Área parcela: ${parcela.areaLote} ${finca.tipoMedida == 1 ? 'Mz': 'Ha'}'), 
                                ],
                            )
                        ],
                    ),
                );
            },
        );        
    }


}