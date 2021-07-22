class SalidaNutriente {
    SalidaNutriente({
        this.id,
        this.idTest,
        this.cacao,
        this.lena,
        this.fruta,
        this.musacea,
        this.madera,
        this.cascaraCacao = 0,
    });

    String? id;
    String? idTest;
    double? cacao;
    double? lena;
    double? fruta;
    double? musacea;
    double? madera;
    int? cascaraCacao;

    factory SalidaNutriente.fromJson(Map<String, dynamic> json) => SalidaNutriente(
        id: json["id"],
        idTest: json["idTest"],
        cacao: json["cacao"].toDouble(),
        lena: json["lena"].toDouble(),
        fruta: json["fruta"].toDouble(),
        musacea: json["musacea"].toDouble(),
        madera: json["madera"].toDouble(),
        cascaraCacao: json["cascaraCacao"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "cacao": cacao,
        "lena": lena,
        "fruta": fruta,
        "musacea": musacea,
        "madera": madera,
        "cascaraCacao": cascaraCacao,
    };
}