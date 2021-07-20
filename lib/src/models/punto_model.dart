class Punto {
    Punto({
        this.id,
        this.idTest,
        this.nPunto,
        this.idPregunta,
        this.idItem,
        this.repuesta,
    });

    String? id;
    String? idTest;
    int? nPunto;
    int? idPregunta;
    int? idItem;
    int? repuesta;

    factory Punto.fromJson(Map<String, dynamic> json) => Punto(
        id: json["id"],
        idTest: json["idTest"],
        nPunto: json["nPunto"],
        idPregunta: json["idPregunta"],
        idItem: json["idItem"],
        repuesta: json["repuesta"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "nPunto": nPunto,
        "idPregunta": idPregunta,
        "idItem": idItem,
        "repuesta": repuesta,
    };
}