import 'package:dio/dio.dart';
import '../model/endereco.dart';

class EnderecoService {
  Dio dio = Dio();

  Future<Endereco?> listarInformacoesEnderecoPorCep(String cep) async {
    var resposta = await dio.get('https://viacep.com.br/ws/$cep/json/');

    if (resposta.statusCode == 200) {
      if (resposta.data['erro'] == 'true') {
        return null;
      } else {
        return Endereco.fromJsonAPI(resposta.data);
      }
    } else {
      return null;
    }
  }
}
