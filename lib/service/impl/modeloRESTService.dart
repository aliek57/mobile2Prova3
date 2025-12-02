import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile2prova3/model/modelo.dart';
import 'package:mobile2prova3/service/Service.dart';

class ModeloRESTService extends Service<Modelo> {

  // static const String URL = "http://192.168.1.4:3000/carros/ws/modelos";
  static const String URL = "http://argo.td.utfpr.edu.br/carros/ws/modelos";

  @override
  Future<List<Modelo>> getAll() async {
    List<Modelo> modelos = [];
    http.Response resp = await http.get(Uri.parse(URL));

    if (resp.statusCode == 200) {
      var dados = jsonDecode(resp.body);
      for (Map<String, dynamic> m in dados) {
        modelos.add(Modelo.fromJson(m));
      }
    } else {
      throw Exception("Falha ao buscar modelos: ${resp.statusCode}");
    }
    return modelos;
  }

  @override
  Future<Modelo?> findById(int id) async {
    http.Response resp = await http.get(Uri.parse("$URL/$id"));

    if (resp.statusCode == 200) {
      return Modelo.fromJson(jsonDecode(resp.body));
    } else if (resp.statusCode == 404) {
      return null;
    } else {
      throw Exception("Falha ao buscar modelo: ${resp.statusCode}");
    }
  }

  @override
  Future<Modelo> insert(Modelo novo) async {
    http.Response resp = await http.post(
        Uri.parse(URL),
        body: jsonEncode(novo.toJson()),
        headers: {"content-type": "application/json"}
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      Modelo m = Modelo.fromJson(jsonDecode(resp.body));
      return m;
      /*Modelo temp = Modelo.fromJson(jsonDecode(resp.body));
      http.Response respCompleta = await http.get(
          Uri.parse("$URL/${temp.id}?_expand=marca")
      );

      if (respCompleta.statusCode == 200) {
        return Modelo.fromJson(jsonDecode(respCompleta.body));
      } else {
        return temp;
      }*/
    } else {
      throw Exception("Falha inserindo modelo: ${resp.statusCode}");
    }
  }

  @override
  Future<bool> update(Modelo modelo) async {
    http.Response resp = await http.put(
        Uri.parse("$URL/${modelo.id}"),
        body: jsonEncode(modelo.toJson()),
        headers: {"content-type": "application/json"}
    );
    return resp.statusCode == 200;
  }

  @override
  Future<bool> remove(Modelo modelo) async {
    http.Response resp = await http.delete(Uri.parse("$URL/${modelo.id}"));
    return resp.statusCode == 200 || resp.statusCode == 204;
  }
}