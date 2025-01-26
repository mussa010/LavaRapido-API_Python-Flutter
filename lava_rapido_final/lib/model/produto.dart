class Produto {
  int id;
  String modelo;
  String marca;
  String descricao;
  int quantidade;
  double valorUnitario;
  int idFornecedor;

  Produto(this.id, this.modelo, this.marca, this.descricao, this.quantidade,
      this.valorUnitario, this.idFornecedor);

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(json['id'], json['modelo'], json['marca'], json['descricao'],
        json['quantidade'], json['valorUnitario'], json['idFornecedor']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelo': modelo,
      'marca': marca,
      'descricao': descricao,
      'quantidade': quantidade,
      'valorUnitario': valorUnitario,
      'idFornecedor': idFornecedor
    };
  }
}
