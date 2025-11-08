import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile2prova3/model/anuncio.dart';
import 'package:mobile2prova3/service/Service.dart';

class AnuncioRESTService extends Service<Anuncio> {

  static const String URL = "http://argo.td.utfpr.edu.br/carros/ws/anuncios";

  @override
  Future<List<Anuncio>> getAll() async {
    List<Anuncio> anuncios = [];
    http.Response resp = await http.get(Uri.parse(URL));

    if (resp.statusCode == 200) {
      var dados = jsonDecode(resp.body);
      for (Map<String, dynamic> m in dados) {
        anuncios.add(Anuncio.fromJson(m));
      }
    } else {
      throw Exception("Falha ao buscar anuncios: ${resp.statusCode}");
    }
    return anuncios;
  }

  @override
  Future<Anuncio?> findById(int id) async {
    http.Response resp = await http.get(Uri.parse("$URL/$id"));

    if (resp.statusCode == 200) {
      return Anuncio.fromJson(jsonDecode(resp.body));
    } else if (resp.statusCode == 404) {
      return null;
    } else {
      throw Exception("Falha ao buscar anuncio: ${resp.statusCode}");
    }
  }

  @override
  Future<Anuncio> insert(Anuncio novo) async {
    http.Response resp = await http.post(
        Uri.parse(URL),
        body: jsonEncode(novo.toJson()),
        headers: {"content-type": "application/json"}
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      Anuncio a = Anuncio.fromJson(jsonDecode(resp.body));
      return a;
    } else {
      throw Exception("Falha inserindo anuncio: ${resp.statusCode}");
    }
  }

  @override
  Future<bool> update(Anuncio anuncio) async {
    http.Response resp = await http.put(
        Uri.parse("$URL/${anuncio.id}"),
        body: jsonEncode(anuncio.toJson()),
        headers: {"content-type": "application/json"}
    );
    return resp.statusCode == 200;
  }

  @override
  Future<bool> remove(Anuncio anuncio) async {
    http.Response resp = await http.delete(Uri.parse("$URL/${anuncio.id}"));
    return resp.statusCode == 204;
  }
}