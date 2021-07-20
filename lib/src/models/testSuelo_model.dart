import 'dart:convert';

TestSuelo testSueloFromJson(String str) => TestSuelo.fromJson(json.decode(str));

String testSueloToJson(TestSuelo data) => json.encode(data.toJson());

class TestSuelo {
    TestSuelo({
        this.id,
        this.idFinca = '',
        this.idLote = '',
        this.estaciones = 3,
        this.fechaTest,
    });

    String? id;
    String? idFinca;
    String? idLote;
    int? estaciones;
    String? fechaTest;

    factory TestSuelo.fromJson(Map<String, dynamic> json) => TestSuelo(
        id: json["id"],
        idFinca: json["idFinca"],
        idLote: json["idLote"],
        estaciones: json["estaciones"],
        fechaTest: json["fechaTest"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idFinca": idFinca,
        "idLote": idLote,
        "estaciones": estaciones,
        "fechaTest": fechaTest,
    };
}