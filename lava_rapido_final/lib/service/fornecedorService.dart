import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/fornecedor.dart';

class FornecedorService {
  Future<int> quantidadeFornecedor() async {
    const String url = 'http://127.0.0.1:8000/api/fornecedores';

    try {
      final resposta = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      if (resposta.statusCode == 200) {
        List<dynamic> dado = jsonDecode(resposta.body);
        return dado.length;
      }
    } catch (e) {
      print("Erro ao conectar com a API: $e");
      return -1;
    }
    return -1;
  }

  Future<List<Fornecedor>?> todosFornecedores() async {
    const String url = 'http://127.0.0.1:8000/api/fornecedores';

    final resposta = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (resposta.statusCode == 200) {
      List<dynamic> dado = jsonDecode(resposta.body);
      return dado.map((e) => Fornecedor.fromJson(e)).toList();
    }
    return null;
  }

  Future<Fornecedor?> retornaFornecedor(int id) async {
    String url = 'http://127.0.0.1:8000/api/fornecedor/$id';

    final resposta = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (resposta.statusCode == 200) {
      return Fornecedor.fromJson(jsonDecode(resposta.body));
    }
    return null;
  }

  Future<int> novoFornecedor(Fornecedor fornecedor) async {
    const String url = 'http://127.0.0.1:8000/api/fornecedor';

    final resposta = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(fornecedor.toJson()));

    return resposta.statusCode;
  }

  Future<int> atualizarFornecedor(Fornecedor fornecedor) async {
    final String url =
        'http://127.0.0.1:8000/api/fornecedor/${fornecedor.id}';

    final resposta = await http.put(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(fornecedor.toJson()));

    return resposta.statusCode;
  }

  Future<void> deletarFornecedor(int id) async {
    final String url = 'http://127.0.0.1:8000/api/fornecedor/$id';

    final resposta = await http.delete(Uri.parse(url));

    if (resposta.statusCode == 404) {
      throw Exception('Fornecedor não encontrado');
    } else if (resposta.statusCode != 200 && resposta.statusCode != 404) {
      throw Exception('Erro ao deletar fornecedor');
    }
  }
}
