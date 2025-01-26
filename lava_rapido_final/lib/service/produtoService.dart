import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/produto.dart';

class ProdutoService {
  Future<List<Produto>?> todosProdutos() async {
    const String url = 'http://127.0.0.1:8000/api/produtos';

    final resposta = await http
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (resposta.statusCode == 200) {
      List<dynamic> dado = jsonDecode(resposta.body);
      return dado.map((e) => Produto.fromJson(e)).toList();
    }
    return null;
  }

  Future<Produto?> retornaProduto(int id) async {
    String url = 'http://127.0.0.1:8000/api/produto/$id';

    final resposta = await http
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (resposta.statusCode == 200) {
      return Produto.fromJson(jsonDecode(resposta.body));
    }
    return null;
  }

  Future<int> novoProduto(Produto produto) async {
    const String url = 'http://127.0.0.1:8000/api/produto';

    final resposta = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(produto.toJson()));

    return resposta.statusCode;
  }

  Future<int> atualizarProduto(Produto produto) async {
    final String url = 'http://127.0.0.1:8000/api/produto/${produto.id}';

    final resposta = await http.put(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(produto.toJson()));

    return resposta.statusCode;
  }

  Future<void> deletarProduto(int id) async {
    final String url = 'http://127.0.0.1:8000/api/produto/$id';

    final resposta = await http
        .delete(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    if (resposta.statusCode == 404) {
      throw Exception('Produto não encontrado');
    } else if (resposta.statusCode != 200 && resposta.statusCode != 404) {
      throw Exception('Erro ao deletar produto');
    }
  }
}
