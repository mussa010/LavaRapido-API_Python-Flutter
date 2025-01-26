import 'package:tuple/tuple.dart';

class Endereco {
  String logradouro;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String estado;
  String cep;

  Endereco(this.logradouro, this.numero, this.bairro, this.complemento,
      this.cep, this.cidade, this.estado);

  getLogradouro() {
    return logradouro;
  }

  getNumero() {
    return numero;
  }

  getBairro() {
    return bairro;
  }

  getComplemento() {
    return complemento;
  }

  getCep() {
    return cep;
  }

  getCidade() {
    return cidade;
  }

  getEstado() {
    return estado;
  }

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(json['logradouro'], json['numero'], json['bairro'],
        json['complemento'], json['cep'], json['cidade'], json['estado']);
  }

  factory Endereco.fromJsonAPI(Map<String, dynamic> json) {
    final List<Tuple2<String, String>> ufs = [
      const Tuple2('AC', 'Acre'),
      const Tuple2('AL', 'Alagoas'),
      const Tuple2('AP', 'Amapá'),
      const Tuple2('AM', 'Amazonas'),
      const Tuple2('BA', 'Bahia'),
      const Tuple2('CE', 'Ceará'),
      const Tuple2('DF', 'Distrito Federal'),
      const Tuple2('ES', 'Espírito Santo'),
      const Tuple2('GO', 'Goiás'),
      const Tuple2('MA', 'Maranhão'),
      const Tuple2('MT', 'Mato Grosso'),
      const Tuple2('MS', 'Mato Grosso do Sul'),
      const Tuple2('MG', 'Minas Gerais'),
      const Tuple2('PA', 'Pará'),
      const Tuple2('PB', 'Paraíba'),
      const Tuple2('PR', 'Paraná'),
      const Tuple2('PE', 'Pernambuco'),
      const Tuple2('PI', 'Piauí'),
      const Tuple2('RJ', 'Rio de Janeiro'),
      const Tuple2('RN', 'Rio Grande do Norte'),
      const Tuple2('RS', 'Rio Grande do Sul'),
      const Tuple2('RO', 'Rondônia'),
      const Tuple2('RR', 'Roraima'),
      const Tuple2('SC', 'Santa Catarina'),
      const Tuple2('SP', 'São Paulo'),
      const Tuple2('SE', 'Sergipe'),
      const Tuple2('TO', 'Tocantins'),
    ];

    final uf = ufs.firstWhere((uf) => uf.item1 == json['uf'],
        orElse: () => const Tuple2('XX', 'Sigla não encontrada'));
    return Endereco(
      json['logradouro'],
      '',
      json['bairro'],
      '',
      json['cep'],
      json['localidade'],
      uf.item2,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'complemento': complemento,
      'cep': cep,
      'cidade': cidade,
      'estado': estado
    };
  }

  String retornaNomeUf(String sigla) {
    final List<Tuple2<String, String>> ufs = [
      const Tuple2('AC', 'Acre'),
      const Tuple2('AL', 'Alagoas'),
      const Tuple2('AP', 'Amapá'),
      const Tuple2('AM', 'Amazonas'),
      const Tuple2('BA', 'Bahia'),
      const Tuple2('CE', 'Ceará'),
      const Tuple2('DF', 'Distrito Federal'),
      const Tuple2('ES', 'Espírito Santo'),
      const Tuple2('GO', 'Goiás'),
      const Tuple2('MA', 'Maranhão'),
      const Tuple2('MT', 'Mato Grosso'),
      const Tuple2('MS', 'Mato Grosso do Sul'),
      const Tuple2('MG', 'Minas Gerais'),
      const Tuple2('PA', 'Pará'),
      const Tuple2('PB', 'Paraíba'),
      const Tuple2('PR', 'Paraná'),
      const Tuple2('PE', 'Pernambuco'),
      const Tuple2('PI', 'Piauí'),
      const Tuple2('RJ', 'Rio de Janeiro'),
      const Tuple2('RN', 'Rio Grande do Norte'),
      const Tuple2('RS', 'Rio Grande do Sul'),
      const Tuple2('RO', 'Rondônia'),
      const Tuple2('RR', 'Roraima'),
      const Tuple2('SC', 'Santa Catarina'),
      const Tuple2('SP', 'São Paulo'),
      const Tuple2('SE', 'Sergipe'),
      const Tuple2('TO', 'Tocantins'),
    ];

    final uf = ufs.firstWhere((uf) => uf.item1 == sigla,
        orElse: () => const Tuple2('XX', ''));
    return uf.item2;
  }
}
