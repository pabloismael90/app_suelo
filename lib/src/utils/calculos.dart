
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/parcela_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;
import 'package:app_suelo/src/models/sueloNutriente_model.dart';





//Salida
salidaElemeto(SalidaNutriente salidaNutriente, String elemento){
    double totalElemeto;
    double factorCacaoBaba = 3.0;
    
    double valorCacao =  salidaNutriente.cacao!;
    double valorCascara=  salidaNutriente.cascaraCacao == 1 ? 0.0 : valorCacao;
    double valorLena =  salidaNutriente.lena!;
    double valorMusacea =  salidaNutriente.musacea!;
    double valorFruta =  salidaNutriente.fruta!;
    double valorMadera =  salidaNutriente.madera!;

    final factorCacao = selectMap.valoresSalida().firstWhere((e) => e['value'] == 1)[elemento];
    final factorCascara = selectMap.valoresSalida().firstWhere((e) => e['value'] == 2)[elemento];
    final factorLena = selectMap.valoresSalida().firstWhere((e) => e['value'] == 3)[elemento];
    final factorMusacea = selectMap.valoresSalida().firstWhere((e) => e['value'] == 4)[elemento];
    final factorFrutas = selectMap.valoresSalida().firstWhere((e) => e['value'] == 5)[elemento];
    final factorMadera = selectMap.valoresSalida().firstWhere((e) => e['value'] == 6)[elemento];

    totalElemeto =((valorCacao * factorCacao)/factorCacaoBaba) + (( valorCascara * factorCascara)/factorCacaoBaba) 
    + (valorLena * factorLena) + (valorMusacea * factorMusacea) + (valorFruta * factorFrutas) + (valorMadera * factorMadera);
    
    return totalElemeto;
    
}



//Entrada
entradaElemento(List<EntradaNutriente> entradas, SueloNutriente? sueloNutriente, String elemento, Parcela parcela){
    double totalElemento = 0;
    int elementoSuelo = selectMap.tiposSuelo().firstWhere((e) => e['value'] == '${sueloNutriente!.tipoSuelo}')[elemento];
    

    for (var entrada in entradas) {
        totalElemento = totalElemento+selectFuncionElemento(entrada, elemento, parcela.numeroPlanta);
    }
    
    

    return totalElemento * (elementoSuelo/100);
}

selectFuncionElemento(EntradaNutriente entrada, String label, int? densidad) { 
    switch(entrada.unidad.toString()) { 
        case '0': { return totalOzPlanta(entrada, label, densidad!);  } 
        
        case '1': { return totalLbPlanta(entrada, label, densidad!); } 
        
        case '2': { return totalGPlanta(entrada, label, densidad!); } 
        
        case '3': { return totalKgMz(entrada, label); }

        case '4': { return totalLbMz(entrada, label); } 

        case '5': { return totalLMz(entrada, label); } 
    }
} 

double totalOzPlanta(EntradaNutriente entrada, String label, int densidad){
    double total;
    double b13 = entrada.cantidad!;
    double b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')[label] * 1.0;
    double h10 = entrada.humedad!;
    int b16 = entrada.frecuencia!;
    int d5 = densidad;

    total = ((b13/16)*((100-h10)/100)*(b10/100)*d5)*b16;

    return total;
}

double totalLbPlanta(EntradaNutriente entrada, String label, int densidad){
    double total;
    double b13 = entrada.cantidad!;
    double b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')[label] * 1.0;
    double h10 = entrada.humedad!;
    int b16 = entrada.frecuencia!;
    int d5 = densidad;

    total = (b13*((100-h10)/100)*(b10/100)*d5)*b16;
    
    return total;
}

double totalGPlanta(EntradaNutriente entrada, String label, int densidad){
    double total;
    double b13 = entrada.cantidad!;
    double b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')[label] * 1.0;
    double h10 = entrada.humedad!;
    int b16 = entrada.frecuencia!;
    int d5 = densidad;

    total = ((b13/456)*((100-h10)/100)*(b10/100)*d5)*b16;

    return total;
}

double totalKgMz(EntradaNutriente entrada, String label){
    double total;
    double b13 = entrada.cantidad!;
    double b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')[label] * 1.0;
    double h10 = entrada.humedad!;
    int b16 = entrada.frecuencia!;

    total = ((b13*2.2)*((100-h10)/100)*(b10/100))*b16;

    return total;
}

double totalLbMz(EntradaNutriente entrada, String label){
    double total;
    double b13 = entrada.cantidad!;
    double b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')[label] * 1.0;
    double h10 = entrada.humedad!;
    int b16 = entrada.frecuencia!;
    
    
    total = (b13*(b10/100)*((100-h10)/100))*b16;
    

    return total;
}

double totalLMz(EntradaNutriente entrada, String label){
    double total;
    double b13 = entrada.cantidad!;
    double b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')[label] * 1.0;
    int b16 = entrada.frecuencia!;
    
    total = ((b10/100)*b13)*b16;

    return total;
}

//Suelo

nutrienteSuelo(SueloNutriente? sueloNutriente, String elemento){
    double elementoTotal;
    int factor = selectMap.tiposSuelo().firstWhere((e) => e['value'] == '${sueloNutriente!.tipoSuelo}')[elemento];
    elementoTotal = selectFuncionSuelo(sueloNutriente, elemento);

    return elementoTotal*(factor/100);
}


selectFuncionSuelo(SueloNutriente? sueloNutriente, String label) { 
    switch(label) { 
        case 'N': { return ((10000*0.3*sueloNutriente!.densidadAparente!*1000)*(sueloNutriente.nitrogeno!/100))*0.01*(2.2*0.7072); }
        
        case 'P': { return (((1000*3000*sueloNutriente!.densidadAparente!)*sueloNutriente.fosforo!)/1000000)*2.2*0.7072; }
        
        case 'K': { return 780*sueloNutriente!.densidadAparente!*sueloNutriente.potasio!*2.2*0.7; }
        
        case 'Ca': { return 400*sueloNutriente!.densidadAparente!*sueloNutriente.calcio!*2.2*0.7026; }

        case 'Mg': { return 240*sueloNutriente!.densidadAparente!*sueloNutriente.magnesio!*2.2*0.7026; }

        case 'S': { return (((1000*3000*1.15)*sueloNutriente!.azufre!)/1000000)*2.2*0.7072; }
    }
} 


