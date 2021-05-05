import 'package:app_suelo/src/models/testSuelo_model.dart';
import 'package:app_suelo/src/utils/constants.dart';
import 'package:app_suelo/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';

class BalancePage extends StatefulWidget {
  BalancePage({Key key}) : super(key: key);

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
    @override
    Widget build(BuildContext context) {

        TestSuelo suelo = ModalRoute.of(context).settings.arguments;
        print(suelo.idFinca);
        
        return Scaffold(
            appBar: AppBar(),
            body: Column(
                children: [
                    TitulosPages(titulo: 'Balance de nutrientes'),
                    Divider(), 
                    Expanded(child: Center(
                        child: Text('No hay datos: \nIngrese datos de pasos', 
                        textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                            )
                        )
                    )
                ],
            ),
            // bottomNavigationBar: BottomAppBar(
            //     child: Container(
            //         color: kBackgroundColor,
            //         child: Padding(
            //             padding: EdgeInsets.symmetric(vertical: 10),
            //             child: Container()
            //         ),
            //     ),
            // ),
        );
    }
}