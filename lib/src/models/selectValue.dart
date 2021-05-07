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




List<Map<String, dynamic>> puntos1(){
    final List<Map<String, dynamic>>  repuesta = [
        {
            'value': '0',
            'label': 'No'
        },
        {
            'value': '1',
            'label': 'Algo'
        },
        {
            'value': '2',
            'label': 'Severo'
        }

    ];

    return repuesta;
}

List<Map<String, dynamic>> puntos2(){
    final List<Map<String, dynamic>>  repuesta = [
        {
            'value': '0',
            'label': 'No'
        },
        {
            'value': '1',
            'label': 'Mala'
        },
        {
            'value': '2',
            'label': 'Buena'
        }

    ];

    return repuesta;
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

List<Map<String, dynamic>> listAbonos(){
    final List<Map<String, dynamic>>  abonos = [
    {
        "nombre": "Ceniza",
        "N": 0,
        "P": 0.89,
        "K": 3.8,
        "Ca": 18,
        "Mg": 1.5,
        "S": 0
    },
    {
        "nombre": "Triple_Cal",
        "N": 0,
        "P": 0,
        "K": 0,
        "Ca": 30,
        "Mg": 15,
        "S": 15
    },
    {
    "nombre": "18_46_0",
    "N": 18,
    "P": 46,
    "K": 0,
    "Ca": 0,
    "Mg": 0,
    "S": 0
    },
    {
    "nombre": "20_4_10",
    "N": 20,
    "P": 4,
    "K": 10,
    "Ca": 0,
    "Mg": 0,
    "S": 0
    },
    {
    "nombre": "Bayfolan",
    "N": 91,
    "P": 66,
    "K": 50,
    "Ca": 0,
    "Mg": 0,
    "S": 0
    },
    {
    "nombre": "Ferticafe",
    "N": 18,
    "P": 5,
    "K": 18,
    "Ca": 0,
    "Mg": 0,
    "S": 0
    },
    {
    "nombre": "Foliar",
    "N": 20,
    "P": 20,
    "K": 20,
    "Ca": 0,
    "Mg": 0,
    "S": 0
    },
    {
    "nombre": "Triple_Quince",
    "N": 15,
    "P": 15,
    "K": 15,
    "Ca": 0,
    "Mg": 0,
    "S": 0
    },
    {
    "nombre": "Urea",
    "N": 46,
    "P": 0,
    "K": 0,
    "Ca": 0,
    "Mg": 0,
    "S": 0
    },
    {
    "nombre": "Biogreen",
    "N": 2,
    "P": 2.5,
    "K": 1.8,
    "Ca": 0,
    "Mg": 0,
    "S": 0.25
    },
    {
    "nombre": "Bocashi",
    "N": 2,
    "P": 2,
    "K": 2,
    "Ca": 1,
    "Mg": 0.3,
    "S": 0.25
    },
    {
    "nombre": "Compost",
    "N": 2,
    "P": 1,
    "K": 1,
    "Ca": 1,
    "Mg": 0.3,
    "S": 0.25
    },
    {
        "nombre": "Estiercol_Vaca",
        "N": 2,
        "P": 1,
        "K": 2,
        "Ca": 1.1,
        "Mg": 3,
        "S": 0.5
    },
    {
        "nombre": "Gallinaza",
        "N": 2,
        "P": 2.5,
        "K": 1.8,
        "Ca": 0.18,
        "Mg": 0.4,
        "S": 0.4
    },
    {
        "nombre": "Lombricompost",
        "N": 2,
        "P": 1,
        "K": 1,
        "Ca": 1,
        "Mg": 0.3,
        "S": 0.25
    },
    {
        "nombre": "Sulfato de potasio",
        "N": 0,
        "P": 0,
        "K": 52,
        "Ca": 0,
        "Mg": 0,
        "S": 16
    },
    {
        "nombre": "Caldo Sulfo Calcio",
        "N": 0,
        "P": 0,
        "K": 0,
        "Ca": 16,
        "Mg": 0,
        "S": 16
    },
    {
        "nombre": "Multi-Fruto NPK",
        "N": 12,
        "P": 30,
        "K": 12,
        "Ca": 0,
        "Mg": 0,
        "S": 0
    },
    {
        "nombre": "Multi Fruto 20 20 20",
        "N": 20,
        "P": 20,
        "K": 20,
        "Ca": 0,
        "Mg": 0,
        "S": 0
    },
    {
        "nombre": "Multi Fruto Cosechador",
        "N": 10,
        "P": 10,
        "K": 40,
        "Ca": 0,
        "Mg": 0,
        "S": 0
    },
    {
        "nombre": "Biol/Biofermentado",
        "N": 2,
        "P": 0.5,
        "K": 2,
        "Ca": 1,
        "Mg": 0.2,
        "S": 0.3
    },
    {
        "nombre": "Lombricompost DR",
        "N": 2,
        "P": 1,
        "K": 1,
        "Ca": 4,
        "Mg": 0.4,
        "S": 0.25
    }
];

    return abonos;
}




https://www.convertcsv.com/csv-to-json.htm;






























