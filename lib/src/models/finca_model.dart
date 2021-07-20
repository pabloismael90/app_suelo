class Finca {
    Finca({
        this.id,
        this.nombreFinca,
        this.nombreProductor,
        this.areaFinca,
        this.tipoMedida = 1,
        this.nombreTecnico = '',
    });

    String? id;
    String? nombreFinca;
    String? nombreProductor;
    double? areaFinca;
    int? tipoMedida;
    String? nombreTecnico;

    factory Finca.fromJson(Map<String, dynamic> json) => Finca(
        id: json["id"],
        nombreFinca: json["nombreFinca"],
        nombreProductor: json["nombreProductor"],
        areaFinca: json["areaFinca"].toDouble(),
        tipoMedida: json["tipoMedida"],
        nombreTecnico: json["nombreTecnico"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombreFinca": nombreFinca,
        "nombreProductor": nombreProductor,
        "areaFinca": areaFinca,
        "tipoMedida": tipoMedida,
        "nombreTecnico": nombreTecnico,
    };
}