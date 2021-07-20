import 'package:app_suelo/src/models/acciones_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportPage extends StatelessWidget {
    const ReportPage({Key? key}) : super(key: key);

    
    Future getRegistros() async{
        
        List<Acciones> listAcciones= await DBProvider.db.getTodasAcciones();

        return listAcciones;
    }

    Future getDatos(String? id) async{
        
        TestSuelo? suelo = await (DBProvider.db.getTestId(id));

        Finca? finca = await DBProvider.db.getFincaId(suelo!.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(suelo.idLote);

        return [suelo, finca, parcela];
    }

    @override
    Widget build(BuildContext context) {
        
        return Scaffold(
            appBar: AppBar(),
            body: FutureBuilder(
                future: getRegistros(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    return Column(
                        children: [
                            TitulosPages(titulo: 'Reportes'),
                            Divider(),
                            Expanded(child: _listaDePlagas(snapshot.data, context))
                        ],
                    );

                },
            ),
        );
    }

    Widget  _listaDePlagas(List acciones, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return GestureDetector(
                    child : FutureBuilder(
                        future: getDatos(acciones[index].idTest),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                            }
                            TestSuelo sueloData = snapshot.data[0];
                            Finca fincadata = snapshot.data[1];
                            Parcela parceladata = snapshot.data[2];

                            return _cardDesiciones(sueloData,fincadata,parceladata, context);
                        },
                    ),
                    
                    onTap: () => Navigator.pushNamed(context, 'reportDetalle', arguments: acciones[index].idTest),
                    //onTap: () => print (acciones[index].idTest),
                );
               
            },
            shrinkWrap: true,
            itemCount: acciones.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget _cardDesiciones(TestSuelo suelo, Finca finca, Parcela parcela, BuildContext context){
        return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
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
                            padding: EdgeInsets.only(right: 20),
                            child: SvgPicture.asset('assets/icons/report.svg', height:80,),
                        ),
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
                                    
                                    Padding(
                                        padding: EdgeInsets.only( bottom: 10.0),
                                        child: Text(
                                            'Toma de datos: ${suelo.fechaTest}',
                                            style: TextStyle(color: kLightBlackColor),
                                        ),
                                    ),
                                ],  
                            ),
                        ),
                        
                        
                        
                    ],
                ),
        );
    }
   
}