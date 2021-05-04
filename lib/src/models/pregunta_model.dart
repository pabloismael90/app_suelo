class Punto {
    Punto({
        this.id,
        this.idPunto,
        this.idPregunta,
        this.idItem,
        this.repuesta,
    });

    String id;
    String idPunto;
    int idPregunta;
    int idItem;
    int repuesta;

    factory Punto.fromJson(Map<String, dynamic> json) => Punto(
        id: json["id"],
        idPunto: json["idPunto"],
        idPregunta: json["idPregunta"],
        idItem: json["idItem"],
        repuesta: json["repuesta"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idPunto": idPunto,
        "idPregunta": idPregunta,
        "idItem": idItem,
        "repuesta": repuesta,
    };
}