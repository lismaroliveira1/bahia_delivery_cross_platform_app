class CepAbertoAddress {
  final double altitude;
  final String cep;
  final double latitude;
  final double longitude;
  final String logradouro;
  final String bairro;
  final City city;
  final State state;

  CepAbertoAddress.fromMap(Map<String, dynamic> map)
      : altitude = map['altitude'] as double,
        cep = map['cep'] as String,
        latitude = double.tryParse(map['latitude'] as String),
        longitude = double.tryParse(map['longitude'] as String),
        logradouro = map['logradouro'] as String,
        bairro = map['bairro'] as String,
        city = City.fromMap(map['cidade'] as Map<String, dynamic>),
        state = State.fromMap(map['estado'] as Map<String, dynamic>);
  @override
  String toString() {
    return 'SearchAddressModel{altitude: $altitude, cep: $cep, latitude: $latitude, longitude: $longitude, logradouro: $logradouro, bairro: $bairro, city: $city, state: $state';
  }
}

class SearchFromLatLng {}

class City {
  final int ddd;
  final String ibge;
  final String nome;
  City.fromMap(Map<String, dynamic> map)
      : ddd = map['ddd'] as int,
        ibge = map['ibge'] as String,
        nome = map['nome'] as String;
  @override
  String toString() {
    return 'cidade: {ddd: $ddd, igbe: $ibge, nome: $nome}';
  }
}

class State {
  final String sigla;
  State.fromMap(Map<String, dynamic> map) : sigla = map['sigla'] as String;
  @override
  String toString() {
    return 'state: {sigla: $sigla}';
  }
}
