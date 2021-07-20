import 'package:flutter/material.dart';


Future<bool?> confirmacionUser(DismissDirection direction, BuildContext context) async {

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Confirmacion"),
                content: const Text("¿Está seguro de que quieres borrar el registro?. Se eliminaran los datos relacionados al elementos borrado."),
                actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("BORRAR")
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("CANCELAR"),
                    ),
                ],
            );
        },
    );
}

Widget backgroundTrash(BuildContext context){
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        color: Colors.red,
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    Icon(Icons.delete, color: Colors.white),
                    Text('Eliminar', style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
            ),
        )
    );
}

