
import 'package:app_suelo/src/models/entradaNutriente_model.dart';
import 'package:app_suelo/src/models/salidaNutriente_model.dart';
import 'package:app_suelo/src/models/selectValue.dart' as selectMap;






salidaNitrogeno(SalidaNutriente salidaNutriente){
    double nitrogeno;
    
    double valorCacao =  salidaNutriente.cacao;
    double valorCascara=  salidaNutriente.cascaraCacao;
    double valorLena =  salidaNutriente.lena;
    double valorMusacea =  salidaNutriente.musacea;

    final factorCacao = selectMap.valoresSalida().firstWhere((e) => e['value'] == 1)['N'];
    final factorCascara = selectMap.valoresSalida().firstWhere((e) => e['value'] == 2)['N'];
    final factorLena = selectMap.valoresSalida().firstWhere((e) => e['value'] == 3)['N'];
    final factorMusacea = selectMap.valoresSalida().firstWhere((e) => e['value'] == 4)['N'];

    
    nitrogeno =(valorCacao * factorCacao) + ( valorCascara * factorCascara) + (valorLena * factorLena) + (valorMusacea * factorMusacea);
    
    return nitrogeno;
    
}

salidaFosforo(SalidaNutriente salidaNutriente){
    double fosforo;
    
    double valorCacao =  salidaNutriente.cacao;
    double valorCascara=  salidaNutriente.cascaraCacao;
    double valorLena =  salidaNutriente.lena;
    double valorMusacea =  salidaNutriente.musacea;

    final factorCacao = selectMap.valoresSalida().firstWhere((e) => e['value'] == 1)['P'];
    final factorCascara = selectMap.valoresSalida().firstWhere((e) => e['value'] == 2)['P'];
    final factorLena = selectMap.valoresSalida().firstWhere((e) => e['value'] == 3)['P'];
    final factorMusacea = selectMap.valoresSalida().firstWhere((e) => e['value'] == 4)['P'];

    
    fosforo =(valorCacao * factorCacao) + ( valorCascara * factorCascara) + (valorLena * factorLena) + (valorMusacea * factorMusacea);
    
    return fosforo;
    
}

salidaPotasio(SalidaNutriente salidaNutriente){
    double potasio;
    
    double valorCacao =  salidaNutriente.cacao;
    double valorCascara=  salidaNutriente.cascaraCacao;
    double valorLena =  salidaNutriente.lena;
    double valorMusacea =  salidaNutriente.musacea;

    final factorCacao = selectMap.valoresSalida().firstWhere((e) => e['value'] == 1)['K'];
    final factorCascara = selectMap.valoresSalida().firstWhere((e) => e['value'] == 2)['K'];
    final factorLena = selectMap.valoresSalida().firstWhere((e) => e['value'] == 3)['K'];
    final factorMusacea = selectMap.valoresSalida().firstWhere((e) => e['value'] == 4)['K'];

    
    potasio =(valorCacao * factorCacao) + ( valorCascara * factorCascara) + (valorLena * factorLena) + (valorMusacea * factorMusacea);
    
    return potasio;
    
}

salidaCalcio(SalidaNutriente salidaNutriente){
    double calcio;
    
    double valorCacao =  salidaNutriente.cacao;
    double valorCascara=  salidaNutriente.cascaraCacao;
    double valorLena =  salidaNutriente.lena;
    double valorMusacea =  salidaNutriente.musacea;

    final factorCacao = selectMap.valoresSalida().firstWhere((e) => e['value'] == 1)['Ca'];
    final factorCascara = selectMap.valoresSalida().firstWhere((e) => e['value'] == 2)['Ca'];
    final factorLena = selectMap.valoresSalida().firstWhere((e) => e['value'] == 3)['Ca'];
    final factorMusacea = selectMap.valoresSalida().firstWhere((e) => e['value'] == 4)['Ca'];

    
    calcio =(valorCacao * factorCacao) + ( valorCascara * factorCascara) + (valorLena * factorLena) + (valorMusacea * factorMusacea);
    
    return calcio;
    
}

salidaMagnesio(SalidaNutriente salidaNutriente){
    double magnesio;
    
    double valorCacao =  salidaNutriente.cacao;
    double valorCascara=  salidaNutriente.cascaraCacao;
    double valorLena =  salidaNutriente.lena;
    double valorMusacea =  salidaNutriente.musacea;

    final factorCacao = selectMap.valoresSalida().firstWhere((e) => e['value'] == 1)['Mg'];
    final factorCascara = selectMap.valoresSalida().firstWhere((e) => e['value'] == 2)['Mg'];
    final factorLena = selectMap.valoresSalida().firstWhere((e) => e['value'] == 3)['Mg'];
    final factorMusacea = selectMap.valoresSalida().firstWhere((e) => e['value'] == 4)['Mg'];

    
    magnesio =(valorCacao * factorCacao) + ( valorCascara * factorCascara) + (valorLena * factorLena) + (valorMusacea * factorMusacea);
    
    return magnesio;
    
}

salidaAzufre(SalidaNutriente salidaNutriente){
    double azufre;
    
    double valorCacao =  salidaNutriente.cacao;
    double valorCascara=  salidaNutriente.cascaraCacao;
    double valorLena =  salidaNutriente.lena;
    double valorMusacea =  salidaNutriente.musacea;

    final factorCacao = selectMap.valoresSalida().firstWhere((e) => e['value'] == 1)['S'];
    final factorCascara = selectMap.valoresSalida().firstWhere((e) => e['value'] == 2)['S'];
    final factorLena = selectMap.valoresSalida().firstWhere((e) => e['value'] == 3)['S'];
    final factorMusacea = selectMap.valoresSalida().firstWhere((e) => e['value'] == 4)['S'];

    
    azufre =(valorCacao * factorCacao) + ( valorCascara * factorCascara) + (valorLena * factorLena) + (valorMusacea * factorMusacea);
    
    return azufre;
    
}


entradaNitrogeno(List<EntradaNutriente> entradas){
    double totalNitrogeno = 0;

    for (var entrada in entradas) {
        totalNitrogeno = totalNitrogeno+selectFuncion(entrada);
    }

    print(totalNitrogeno);

    return 0.0;
}

selectFuncion(EntradaNutriente entrada) { 
    switch(entrada.unidad.toString()) { 
        case '0': { return oz_planta(entrada);  } 
        break; 
        
        case '1': { return lb_planta(entrada); } 
        break; 
        
        case '2': { return g_planta(entrada); } 
        break; 
        
        case '3': { return kg_mz(entrada); } 
        break;

        case '4': {  return lb_mz(entrada); } 
        break; 

        case '5': { return l_mz(entrada); } 
        break; 
        
        
    }
} 

oz_planta(EntradaNutriente entrada){
    double nitrogeno;
    double b13 = entrada.cantidad;
    int b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')['N'];
    double h10 = entrada.humedad;
    int b16 = entrada.frecuencia;
    int d5 = entrada.densidad;

    nitrogeno = ((b13/16)*((100-h10)/100)*(b10/100)*d5)*b16;

    return nitrogeno;
}

lb_planta(EntradaNutriente entrada){
    double nitrogeno;
    double b13 = entrada.cantidad;
    int b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')['N'];
    double h10 = entrada.humedad;
    int b16 = entrada.frecuencia;
    int d5 = entrada.densidad;

    nitrogeno = (b13*((100-h10)/100)*(b10/100)*d5)*b16;

    return nitrogeno;
}

g_planta(EntradaNutriente entrada){
    double nitrogeno;
    double b13 = entrada.cantidad;
    int b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')['N'];
    double h10 = entrada.humedad;
    int b16 = entrada.frecuencia;
    int d5 = entrada.densidad;

    nitrogeno = ((b13/456)*((100-h10)/100)*(b10/100)*d5)*b16;

    return nitrogeno;
}

kg_mz(EntradaNutriente entrada){
    double nitrogeno;
    double b13 = entrada.cantidad;
    int b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')['N'];
    double h10 = entrada.humedad;
    int b16 = entrada.frecuencia;

    nitrogeno = ((b13*2.2)*((100-h10)/100)*(b10/100))*b16;

    return nitrogeno;
}

lb_mz(EntradaNutriente entrada){
    double nitrogeno;
    double b13 = entrada.cantidad;
    int b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')['N'];
    double h10 = entrada.humedad;
    int b16 = entrada.frecuencia;
    
    
    nitrogeno = (b13*(b10/100)*((100-h10)/100))*b16;

    return nitrogeno;
}

l_mz(EntradaNutriente entrada){
    double nitrogeno;
    double b13 = entrada.cantidad;
    int b10 = selectMap.listAbonos().firstWhere((e) => e['value'] == '${entrada.idAbono}')['N'];
    int b16 = entrada.frecuencia;
    
    nitrogeno = ((b10/100)*b13)*b16;

    return nitrogeno;
}

//(    
// SI($C13="lb/planta",$B13*((100-$H10)/100)*(B10/100)*$D$5,
// SI($C13="oz/planta",($B13/16)*((100-$H10)/100)*(B10/100)*$D$5,
// SI($C13="g/planta",($B13/456)*((100-$H10)/100)*(B10/100)*$D$5,
// SI($C13="kg/mz",($B13*2.2)*((100-$H10)/100)*(B10/100),
// SI($C13="lb/mz",$B13*(B10/100)*((100-$H10)/100),
//     SI($C13="L/mz",(B10/100)*$B13) 
// )
// )))))*$B16