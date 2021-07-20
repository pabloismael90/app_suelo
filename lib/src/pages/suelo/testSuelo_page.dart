import 'package:app_suelo/src/bloc/fincas_bloc.dart';
import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/providers/db_provider.dart';
import 'package:app_suelo/src/utils/widget/button.dart';
import 'package:app_suelo/src/utils/widget/dialogDelete.dart';
import 'package:app_suelo/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';


final fincasBloc = new FincasBloc();

class TestPage extends StatefulWidget {

    

  @override
  _TestPageState createState() => _TestPageState();
}


class _TestPageState extends State<TestPage> {

    
    Future _getdataFinca(TestSuelo textSuelo) async{
        Finca? finca = await DBProvider.db.getFincaId(textSuelo.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(textSuelo.idLote);
        return [finca, parcela];
    }

    @override
    Widget build(BuildContext context) {
        var size = MediaQuery.of(context).size;
        fincasBloc.obtenerTest();

        return Scaffold(
                appBar: AppBar(title: Text('Selecciona Parcelas'),),
                body: StreamBuilder<List<TestSuelo>>(
                    stream: fincasBloc.testStream,

                    
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());

                        }

                        List<TestSuelo> textSuelos= snapshot.data;
                        
                        return Column(
                            children: [
                                Expanded(
                                    child:
                                    textSuelos.length == 0
                                    ?
                                    textoListaVacio('Ingrese una toma de datos')
                                    :
                                    SingleChildScrollView(child: _listaDeSuelo(textSuelos, size, context))
                                ),
                            ],
                        );
                        
                        
                    },
                ),
                bottomNavigationBar: botonesBottom(_addtest(context)),
        );
        
    }

    Widget _addtest(BuildContext context){
        return Row(
            children: [
                Spacer(),
                ButtonMainStyle(
                    title: 'Escoger parcelas',
                    icon: Icons.post_add,
                    press: () => Navigator.pushNamed(context, 'addTest'),
                ),
                Spacer()
            ],
        );
    }

    Widget  _listaDeSuelo(List textSuelos, Size size, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return Dismissible(
                    key: UniqueKey(),
                    child: GestureDetector(
                        child: FutureBuilder(
                            future: _getdataFinca(textSuelos[index]),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                }
                                Finca finca = snapshot.data[0];
                                Parcela parcela = snapshot.data[1];

                                return _cardDesing(size, textSuelos[index], finca, parcela);
                            },
                        ),
                        onTap: () => Navigator.pushNamed(context, 'salidaPage', arguments: textSuelos[index]),
                    ),
                    confirmDismiss: (direction) => confirmacionUser(direction, context),
                    direction: DismissDirection.endToStart,
                    background: backgroundTrash(context),
                    movementDuration: Duration(milliseconds: 500),
                    onDismissed: (direction) => fincasBloc.borrarTestSuelo(textSuelos[index].id),
                );
               
            },
            shrinkWrap: true,
            itemCount: textSuelos.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget _cardDesing(Size size, TestSuelo textSuelo, Finca finca, Parcela parcela){
        
        return cardDefault(
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    encabezadoCard('${finca.nombreFinca}','${parcela.nombreLote}', 'assets/icons/test.svg'),
                    textoCardBody('Fecha: ${textSuelo.fechaTest}'),
                    iconTap(' Tocar para completar datos')
                ],
            )
        );
    }



}