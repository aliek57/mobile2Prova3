import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile2prova3/model/marca.dart';
import 'package:mobile2prova3/service/Service.dart';

class MarcaRESTService extends Service<Marca> {

  // static const String URL = "http://192.168.1.4:3000/carros/ws/marcas";
  static const String URL = "http://argo.td.utfpr.edu.br/carros/ws/marcas";

  @override
  Future<List<Marca>> getAll() async {
    List<Marca> marcas = [];
    http.Response resp = await http.get(Uri.parse(URL));

    if (resp.statusCode == 200) {
      var dados = jsonDecode(resp.body);
      for (Map<String, dynamic> m in dados) {
        marcas.add(Marca.fromJson(m));
      }
    } else {
      throw Exception("Falha ao buscar marcas: ${resp.statusCode}");
    }
    return marcas;
  }

  @override
  Future<Marca?> findById(int id) async {
    http.Response resp = await http.get(Uri.parse("$URL/$id"));

    if (resp.statusCode == 200) {
      return Marca.fromJson(jsonDecode(resp.body));
    } else if (resp.statusCode == 404) {
      return null;
    } else {
      throw Exception("Falha ao buscar marca: ${resp.statusCode}");
    }
  }

  @override
  Future<Marca> insert(Marca novo) async {
    http.Response resp = await http.post(
        Uri.parse(URL),
        body: jsonEncode(novo.toJson()),
        headers: {"content-type": "application/json"}
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      Marca m = Marca.fromJson(jsonDecode(resp.body));
      return m;
    } else {
      throw Exception("Falha inserindo marca: ${resp.statusCode}");
    }
  }

  @override
  Future<bool> update(Marca marca) async {
    http.Response resp = await http.put(
        Uri.parse("$URL/${marca.id}"),
        body: jsonEncode(marca.toJson()),
        headers: {"content-type": "application/json"}
    );
    return resp.statusCode == 200;
  }

  @override
  Future<bool> remove(Marca marca) async {
    http.Response resp = await http.delete(Uri.parse("$URL/${marca.id}"));
    return resp.statusCode == 200 || resp.statusCode == 204;
  }
}