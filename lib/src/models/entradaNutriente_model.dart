class SalidaNutriente {
    SalidaNutriente({
        this.id,
        this.idTest,
        this.idAbono = 0,
        this.densidad = 0,
        this.humedad = 0.0,
        this.cantidad = 0.0,
        this.frecuencia = 0,
        this.unidad = 0,
    });

    String id;
    String idTest;
    int idAbono;
    int densidad;
    double humedad;
    double cantidad;
    int frecuencia;
    int unidad;

    factory SalidaNutriente.fromJson(Map<String, dynamic> json) => SalidaNutriente(
        id: json["id"],
        idTest: json["idTest"],
        idAbono: json["idAbono"],
        densidad: json["densidad"],
        humedad: json["humedad"].toDouble(),
        cantidad: json["cantidad"].toDouble(),
        frecuencia: json["frecuencia"],
        unidad: json["unidad"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "idAbono": idAbono,
        "densidad": densidad,
        "humedad": humedad,
        "cantidad": cantidad,
        "frecuencia": frecuencia,
        "unidad": unidad,
    };
}