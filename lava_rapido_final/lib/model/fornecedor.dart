class Fornecedor {
  int id;
  String nome;
  String cnpj;
  String telefone;
  String email;
  String cep;
  String logradouro;
  String bairro;
  int numero;
  String complemento;
  String cidade;
  String estado;

  Fornecedor(
      this.id,
      this.nome,
      this.cnpj,
      this.telefone,
      this.email,
      this.cep,
      this.logradouro,
      this.bairro,
      this.numero,
      this.complemento,
      this.cidade,
      this.estado);

  factory Fornecedor.fromJson(Map<String, dynamic> json) {
    return Fornecedor(
      json['id'],
      json['nome'],
      json['cnpj'],
      json['telefone'],
      json['email'],
      json['cep'],
      json['logradouro'],
      json['bairro'],
      json['numero'],
      json['complemento'],
      json['cidade'],
      json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
      'email': email,
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'numero': numero,
      'complemento': complemento,
      'cidade': cidade,
      'estado': estado,
    };
  }
}
