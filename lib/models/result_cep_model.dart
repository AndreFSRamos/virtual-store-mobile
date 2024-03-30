import 'package:http/http.dart' as http;

import '../datas/result_cep.dart';

class ViaCepService {
  static Future requestAPI(String cep) async {
    var request = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    final response = await http.get(request);
    if (response.statusCode == 200) {
      ResultCep.fromJson(response.body);

      return response.body;
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
