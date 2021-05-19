List<Map<String, dynamic>> dimenciones(){

    
    final List<Map<String, dynamic>> medidaItem = [
            {
                'value': '1',
                'label': 'Mz',
                
            },
            {
                'value': '2',
                'label': 'Ha',
            },
    ];

    return medidaItem;
}

List<Map<String, dynamic>> listMeses(){

    
    final List<Map<String, dynamic>> medidaItem = [
        {
            'value': '1',
            'label': 'Enero',
        },
        {
            'value': '2',
            'label': 'Febrero',
        },
        {
            'value': '3',
            'label': 'Marzo',
        },
        {
            'value': '4',
            'label': 'Abril',
        },
        {
            'value': '5',
            'label': 'Mayo',
        },
        {
            'value': '6',
            'label': 'Junio',
        },
        {
            'value': '7',
            'label': 'Julio',
        },
        {
            'value': '8',
            'label': 'Agosto',
        },
        {
            'value': '9',
            'label': 'Septiembre',
        },
        {
            'value': '10',
            'label': 'Octubre',
        },
        {
            'value': '11',
            'label': 'Noviembre',
        },
        {
            'value': '12',
            'label': 'Diciembre',
        },
    ];

    return medidaItem;
}

List<Map<String, dynamic>> variedadCacao(){
    final List<Map<String, dynamic>>  variedadesCacao = [
            {
                'value': '1', 
                'label': 'CAT 1'
            },
            {
                'value': '2', 
                'label': 'CAT 2'
            },
            {
                'value': '3', 
                'label': 'CAT 3'
            },
            {
                'value': '3', 
                'label': 'CAT 3'
            },
            {
                'value': '4', 
                'label': 'CAT 4'
            },
            {
                'value': '5', 
                'label': 'CAT 5'
            },
        ];

    return variedadesCacao;
}


//Preguntas de Puntos
 
List<Map<String, dynamic>> erosion(){
    final List<Map<String, dynamic>>  erosion = [
            {
                'value': '0', 
                'label': 'Deslizamiento'
            },
            {
                'value': '1', 
                'label': 'Evidencia de erosión'
            },
            {
                'value': '2', 
                'label': 'Cárcava'
            },
            {
                'value': '3', 
                'label': 'Acumulación de sedimiento'
            },
            {
                'value': '4', 
                'label': 'Pedegrosidad'
            },
            {
                'value': '5', 
                'label': 'Raíces desnudos'
            }

        ];

    return erosion;
}

List<Map<String, dynamic>> drenaje(){
    final List<Map<String, dynamic>>  drenaje = [
            {
                'value': '0', 
                'label': 'Encharcamiento'
            },
            {
                'value': '1', 
                'label': 'Amarillamiento'
            },
            {
                'value': '2', 
                'label': 'Enfermedades'
            },
            
        ];

    return drenaje;
}

List<Map<String, dynamic>> raiz(){
    final List<Map<String, dynamic>>  raiz = [
            {
                'value': '0', 
                'label': 'Afectación nematodos'
            },
            {
                'value': '1', 
                'label': 'Afectación hongos'
            }
            
        ];

    return raiz;
}

List<Map<String, dynamic>> conservacion(){
    final List<Map<String, dynamic>>  conservacion = [
            {
                'value': '0', 
                'label': 'Barrera muerta'
            },
            {
                'value': '1', 
                'label': 'Barrera viva'
            },
            {
                'value': '2', 
                'label': 'Siembra a curva a nivel'
            },
            {
                'value': '3', 
                'label': 'Terraza'
            },
            {
                'value': '4', 
                'label': 'Cobertura de piso'
            }

        ];

    return conservacion;
}

List<Map<String, dynamic>> obrasDrenaje(){
    final List<Map<String, dynamic>>  conservacion = [
            {
                'value': '0', 
                'label': 'Acequías'
            },
            {
                'value': '1', 
                'label': 'Canal a largo y ancho'
            },
            {
                'value': '2', 
                'label': 'Canal alrededor'
            },
            {
                'value': '3', 
                'label': 'Canal al lado'
            }

        ];

    return conservacion;
}


//Analisis Suelo
//Suelo
List<Map<String, dynamic>> tiposSuelo(){
    final List<Map<String, dynamic>>  sueloTipo = [
        {
            'value': '0', 
            'label': 'Vertisoles',
            'N': 60,
            'P': 50,
            'K': 65,
            'Ca': 65,
            'Mg': 65,
            'S': 70,
        },
        {
            'value': '1', 
            'label': 'Andisoles o Volcanicos',
            'N': 65,
            'P': 35,
            'K': 80,
            'Ca': 80,
            'Mg': 80,
            'S': 70,
        },
        {
            'value': '2', 
            'label': 'Ultisoles / Suelos Rojos',
            'N': 55,
            'P': 40,
            'K': 70,
            'Ca': 70,
            'Mg': 70,
            'S': 70,
        }

        ];

    return sueloTipo;
}

List<Map<String, dynamic>> texturasSuelo(){
    final List<Map<String, dynamic>>  texturaTipo = [
        {
            'value': '0', 
            'label': 'Arcilloso',
        },
        {
            'value': '1', 
            'label': 'Limoso',
        },
        {
            'value': '2', 
            'label': 'Arenoso'
        },
        {
            'value': '3', 
            'label': 'Arcilloso - Limoso',
        }

    ];

    return texturaTipo;
}

// Abonos
List<Map<String, dynamic>> listAbonos(){
    final List<Map<String, dynamic>>  abonos = [
    
    {
        'value': '1',
        'label': 'Ceniza',
        'N': 0.0,
        'P': 0.89,
        'K': 3.8,
        'Ca': 18.0,
        'Mg': 1.5,
        'S': 0.0
    },
    {
        'value': '2',
        'label': 'Triple_Cal',
        'N': 0,
        'P': 0,
        'K': 0,
        'Ca': 30,
        'Mg': 15,
        'S': 15
    },
    {
        'value': '3',
        'label': '18_46_0',
        'N': 18,
        'P': 46,
        'K': 0,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '4',
        'label': '20_4_10',
        'N': 20,
        'P': 4,
        'K': 10,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '5',
        'label': 'Bayfolan',
        'N': 91,
        'P': 66,
        'K': 50,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '6',
        'label': 'Ferticafe',
        'N': 18,
        'P': 5,
        'K': 18,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '7',
        'label': 'Foliar',
        'N': 20,
        'P': 20,
        'K': 20,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '8',
        'label': 'Triple_Quince',
        'N': 15,
        'P': 15,
        'K': 15,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '9',
        'label': 'Urea',
        'N': 46,
        'P': 0,
        'K': 0,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '10',
        'label': 'Biogreen',
        'N': 2,
        'P': 2.5,
        'K': 1.8,
        'Ca': 0,
        'Mg': 0,
        'S': 0.25
    },
    {
        'value': '11',
        'label': 'Bocashi',
        'N': 2,
        'P': 2,
        'K': 2,
        'Ca': 1,
        'Mg': 0.3,
        'S': 0.25
    },
    {
        'value': '12',
        'label': 'Compost',
        'N': 2,
        'P': 1,
        'K': 1,
        'Ca': 1,
        'Mg': 0.3,
        'S': 0.25
    },
    {
        'value': '13',
        'label': 'Estiercol_Vaca',
        'N': 2,
        'P': 1,
        'K': 2,
        'Ca': 1.1,
        'Mg': 3,
        'S': 0.5
    },
    {
        'value': '14',
        'label': 'Gallinaza',
        'N': 2,
        'P': 2.5,
        'K': 1.8,
        'Ca': 0.18,
        'Mg': 0.4,
        'S': 0.4
    },
    {
        'value': '15',
        'label': 'Lombricompost',
        'N': 2,
        'P': 1,
        'K': 1,
        'Ca': 1,
        'Mg': 0.3,
        'S': 0.25
    },
    {
        'value': '16',
        'label': 'Sulfato de potasio',
        'N': 0,
        'P': 0,
        'K': 52,
        'Ca': 0,
        'Mg': 0,
        'S': 16
    },
    {
        'value': '17',
        'label': 'Caldo Sulfo Calcio',
        'N': 0,
        'P': 0,
        'K': 0,
        'Ca': 16,
        'Mg': 0,
        'S': 16
    },
    {
        'value': '18',
        'label': 'Multi-Fruto NPK',
        'N': 12,
        'P': 30,
        'K': 12,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '19',
        'label': 'Multi Fruto 20 20 20',
        'N': 20,
        'P': 20,
        'K': 20,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '20',
        'label': 'Multi Fruto Cosechador',
        'N': 10,
        'P': 10,
        'K': 40,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    },
    {
        'value': '21',
        'label': 'Biol/Biofermentado',
        'N': 2,
        'P': 0.5,
        'K': 2,
        'Ca': 1,
        'Mg': 0.2,
        'S': 0.3
    },
    {
        'value': '22',
        'label': 'Lombricompost DR',
        'N': 2,
        'P': 1,
        'K': 1,
        'Ca': 4,
        'Mg': 0.4,
        'S': 0.25
    },
    {
        'value': '23',
        'label': 'Completo 0-0-60',
        'N': 0,
        'P': 0,
        'K': 60,
        'Ca': 0,
        'Mg': 0,
        'S': 0
    }
];

    return abonos;
}

List<Map<String, dynamic>> unidadAbono(){
    final List<Map<String, dynamic>>  unidad = [
        {
            'value': '0', 
            'label': 'oz/planta',
        },
        {
            'value': '1', 
            'label': 'lb/planta',
        },
        {
            'value': '2', 
            'label': 'g/planta'
        },
        {
            'value': '3', 
            'label': 'kg/mz',
        },
        {
            'value': '4', 
            'label': 'lb/mz',
        },
        {
            'value': '5', 
            'label': 'L/mz',
        },

    ];

    return unidad;
}

//Salidas Nutrientes
List<Map<String, dynamic>> valoresSalida(){
    final List<Map<String, dynamic>>  salida = [
        {
            "value": 1,
            "label": "Grano de Cacao (lb/qq seco)",
            "N": 2,
            "P": 0.4,
            "K": 1,
            "Ca": 0.12,
            "Mg": 0.34,
            "S": 0.14
        },
        {
            "value": 2,
            "label": "Cascara (lb /qq seco)",
            "N": 1.5,
            "P": 0.2,
            "K": 5,
            "Ca": 0.43,
            "Mg": 0.24,
            "S": 0.14
        },
        {
            "value": 3,
            "label": "Leña (lb/carga de 125lb)",
            "N": 1.1,
            "P": 1,
            "K": 0.6,
            "Ca": 0,
            "Mg": 0,
            "S": 0
        },
        {
            "value": 4,
            "label": "Cabezas de Banano (lb/Cabeza)",
            "N": 0.068,
            "P": 0.009,
            "K": 0.234,
            "Ca": 0,
            "Mg": 0,
            "S": 0
        }

    ];

    return salida;
}


//Decisiones

List<Map<String, dynamic>> solucionesXmes(){
    final List<Map<String, dynamic>>  solucionesXmes = [
        {
            'value': '0',
            'label': 'Barrera Viva'
        },
        {
            'value': '1',
            'label': 'Barrera muerta'
        },
        {
            'value': '2',
            'label': 'Aumento de cobertura de suelo'
        },
        {
            'value': '3',
            'label': 'Siembra a curva de nivel'
        },
        {
            'value': '4',
            'label': 'Terrazas'
        },
        {
            'value': '5',
            'label': 'Acequías'
        },
        {
            'value': '6',
            'label': 'Canales de drenaje'
        },
        {
            'value': '7',
            'label': 'Aplicar abono orgánico'
        },
        {
            'value': '8',
            'label': 'Aplicar abono mineral'
        }

    ];

    return solucionesXmes;
}



























