import 'package:mobile2prova3/errors/ErrorClasses.dart';
import 'package:mobile2prova3/model/marca.dart';
import 'package:mobile2prova3/service/Service.dart';
import 'package:mobile2prova3/service/impl/marcaRESTService.dart';

class MarcaRepository {
  late final Service<Marca> _service;
  List<Marca>? _cache;

  static MarcaRepository? _instance;

  MarcaRepository._internal() {
    _service = MarcaRESTService();
  }

  static MarcaRepository getInstance() {
    _instance ??= MarcaRepository._internal();
    return _instance!;
  }

  Future<List<Marca>> getAll() async {
    _cache ??= await _service.getAll();
    return _cache!;
  }

  Future<void> insert(Marca marca) async {
    Marca novaMarca = await _service.insert(marca);
    _cache?.add(novaMarca);
  }

  Future<bool> update(Marca marca) async {
    bool atualizou = await _service.update(marca);
    return atualizou;
  }

  Future<void> remove(int id) async {
    Marca? m = _cache?.firstWhere((element) => element.id == id, orElse: null);
    if (m != null && await _service.remove(m)) {
      _cache!.remove(m);
    }
  }

  Marca getAt(int index) {
    if (_cache != null && index >= 0 && index < _cache!.length) {
      return _cache![index];
    }
    throw MarcaNotFound();
  }

  int getNumMarcas() {
    return _cache?.length ?? 0;
  }
}