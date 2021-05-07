class SalidaNutriente {
    SalidaNutriente({
        this.id,
        this.idTest,
        this.cacao = 0.0,
        this.lena = 0.0,
        this.fruta = 0.0,
        this.musacea = 0.0,
        this.madera = 0.0,
        this.cascaraCacao = 0.0,
    });

    String id;
    String idTest;
    double cacao;
    double lena;
    double fruta;
    double musacea;
    double madera;
    double cascaraCacao;

    factory SalidaNutriente.fromJson(Map<String, dynamic> json) => SalidaNutriente(
        id: json["id"],
        idTest: json["idTest"],
        cacao: json["cacao"].toDouble(),
        lena: json["lena"].toDouble(),
        fruta: json["fruta"].toDouble(),
        musacea: json["musacea"].toDouble(),
        madera: json["madera"].toDouble(),
        cascaraCacao: json["cascaraCacao"].toDouble(),
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