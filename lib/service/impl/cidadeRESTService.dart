import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile2prova3/model/cidade.dart';
import 'package:mobile2prova3/service/Service.dart';

class CidadeRESTService extends Service<Cidade> {

  static const String URL = "http://argo.td.utfpr.edu.br/carros/ws/cidades";

  @override
  Future<List<Cidade>> getAll() async {
    List<Cidade> cidades = [];
    http.Response resp = await http.get(Uri.parse(URL));

    if (resp.statusCode == 200) {
      var dados = jsonDecode(resp.body);
      for (Map<String, dynamic> m in dados) {
        cidades.add(Cidade.fromJson(m));
      }
    } else {
      throw Exception("Falha ao buscar cidades: ${resp.statusCode}");
    }
    return cidades;
  }

  @override
  Future<Cidade?> findById(int id) async {
    http.Response resp = await http.get(Uri.parse("$URL/$id"));

    if (resp.statusCode == 200) {
      return Cidade.fromJson(jsonDecode(resp.body));
    } else if (resp.statusCode == 404) {
      return null;
    } else {
      throw Exception("Falha ao buscar cidade: ${resp.statusCode}");
    }
  }

  @override
  Future<Cidade> insert(Cidade novo) async {
    http.Response resp = await http.post(
        Uri.parse(URL),
        body: jsonEncode(novo.toJson()),
        headers: {"content-type": "application/json"}
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      Cidade c = Cidade.fromJson(jsonDecode(resp.body));
      return c;
    } else {
      throw Exception("Falha inserindo cidade: ${resp.statusCode}");
    }
  }

  @override
  Future<bool> update(Cidade cidade) async {
    http.Response resp = await http.put(
        Uri.parse("$URL/${cidade.id}"),
        body: jsonEncode(cidade.toJson()),
        headers: {"content-type": "application/json"}
    );
    return resp.statusCode == 200;
  }

  @override
  Future<bool> remove(Cidade cidade) async {
    http.Response resp = await http.delete(Uri.parse("$URL/${cidade.id}"));
    return resp.statusCode == 204;
  }
}