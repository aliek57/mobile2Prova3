import 'package:mobile2prova3/errors/ErrorClasses.dart';
import 'package:mobile2prova3/model/anuncio.dart';
import 'package:mobile2prova3/service/Service.dart';
import 'package:mobile2prova3/service/impl/anuncioRESTService.dart';

class AnuncioRepository {
  late final Service<Anuncio> _service;
  List<Anuncio>? _cache;

  static AnuncioRepository? _instance;

  AnuncioRepository._internal() {
    _service = AnuncioRESTService();
  }

  static AnuncioRepository getInstance() {
    _instance ??= AnuncioRepository._internal();
    return _instance!;
  }

  Future<List<Anuncio>> getAll() async {
    _cache ??= await _service.getAll();
    return _cache!;
  }

  Future<void> insert(Anuncio anuncio) async {
    Anuncio novoAnuncio = await _service.insert(anuncio);
    _cache?.add(novoAnuncio);
  }

  Future<bool> update(Anuncio anuncio) async {
    bool atualizou = await _service.update(anuncio);
    return atualizou;
  }

  Future<void> remove(int id) async {
    Anuncio? a = _cache?.firstWhere((element) => element.id == id, orElse: null);
    if (a != null && await _service.remove(a)) {
      _cache!.remove(a);
    }
  }

  Anuncio getAt(int index) {
    if (_cache != null && index >= 0 && index < _cache!.length) {
      return _cache![index];
    }
    throw AnuncioNotFound();
  }

  int getNumAnuncios() {
    return _cache?.length ?? 0;
  }
}