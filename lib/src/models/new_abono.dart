class NewAbono {
    NewAbono({
        this.id,
        this.idTest,
        this.idAbono = 0,
        this.humedad = 0.0,
        this.cantidad = 0.0,
        this.frecuencia = 0,
        this.unidad = 0,
        this.tipo = 0,
    });

    String id;
    String idTest;
    int idAbono;
    double humedad;
    double cantidad;
    int frecuencia;
    int unidad;
    int tipo;

    factory NewAbono.fromJson(Map<String, dynamic> json) => NewAbono(
        id: json["id"],
        idTest: json["idTest"],
        idAbono: json["idAbono"],
        humedad: json["humedad"].toDouble(),
        cantidad: json["cantidad"].toDouble(),
        frecuencia: json["frecuencia"],
        unidad: json["unidad"],
        tipo: json["tipo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "idAbono": idAbono,
        "humedad": humedad,
        "cantidad": cantidad,
        "frecuencia": frecuencia,
        "unidad": unidad,
        "tipo": tipo,
    };
}