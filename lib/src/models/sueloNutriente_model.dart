class SueloNutriente {
    SueloNutriente({
        this.id,
        this.idTest,
        this.ph,
        this.densidadAparente,
        this.materiaOrganica,
        this.nitrogeno,
        this.fosforo,
        this.potasio,
        this.azufre,
        this.calcio,
        this.magnesio,
        this.hierro,
        this.manganeso,
        this.cadmio,
        this.zinc,
        this.boro,
        this.acidez,
        this.textura = 0,
        this.tipoSuelo = 0,
    });

    String id;
    String idTest;
    double ph;
    double densidadAparente;
    double materiaOrganica;
    double nitrogeno;
    double fosforo;
    double potasio;
    double azufre;
    double calcio;
    double magnesio;
    double hierro;
    double manganeso;
    double cadmio;
    double zinc;
    double boro;
    double acidez;
    int textura;
    int tipoSuelo;

    factory SueloNutriente.fromJson(Map<String, dynamic> json) => SueloNutriente(
        id: json["id"],
        idTest: json["idTest"],
        ph: json["ph"].toDouble(),
        densidadAparente: json["densidadAparente"].toDouble(),
        materiaOrganica: json["materiaOrganica"].toDouble(),
        nitrogeno: json["nitrogeno"].toDouble(),
        fosforo: json["fosforo"].toDouble(),
        potasio: json["potasio"].toDouble(),
        azufre: json["azufre"].toDouble(),
        calcio: json["calcio"].toDouble(),
        magnesio: json["magnesio"].toDouble(),
        hierro: json["hierro"].toDouble(),
        manganeso: json["manganeso"].toDouble(),
        cadmio: json["cadmio"].toDouble(),
        zinc: json["zinc"].toDouble(),
        boro: json["boro"].toDouble(),
        acidez: json["acidez"].toDouble(),
        textura: json["textura"],
        tipoSuelo: json["tipoSuelo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTest": idTest,
        "ph": ph,
        "densidadAparente": densidadAparente,
        "materiaOrganica": materiaOrganica,
        "nitrogeno": nitrogeno,
        "fosforo": fosforo,
        "potasio": potasio,
        "azufre": azufre,
        "calcio": calcio,
        "magnesio": magnesio,
        "hierro": hierro,
        "manganeso": manganeso,
        "cadmio": cadmio,
        "zinc": zinc,
        "boro": boro,
        "acidez": acidez,
        "textura": textura,
        "tipoSuelo": tipoSuelo,
    };
}