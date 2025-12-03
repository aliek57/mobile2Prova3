import 'package:mobile2prova3/errors/ErrorClasses.dart';
import 'package:mobile2prova3/model/cidade.dart';
import 'package:mobile2prova3/service/Service.dart';
import 'package:mobile2prova3/service/impl/cidadeRESTService.dart';

class CidadeRepository {
  late final Service<Cidade> _service;
  List<Cidade>? _cache;

  static CidadeRepository? _instance;

  CidadeRepository._internal() {
    _service = CidadeRESTService();
  }

  static CidadeRepository getInstance() {
    _instance ??= CidadeRepository._internal();
    return _instance!;
  }

  Future<List<Cidade>> getAll() async {
    _cache = await _service.getAll();
    return _cache!;
  }

  Future<void> insert(Cidade cidade) async {
    Cidade novaCidade = await _service.insert(cidade);
    _cache?.add(novaCidade);
  }

  Future<bool> update(Cidade cidade) async {
    bool atualizou = await _service.update(cidade);
    if(atualizou && _cache != null) {
      int i = _cache!.indexWhere((element) => element.id == cidade.id);
      if (i >= 0) _cache![i] = cidade;
    }
    return atualizou;
  }

  Future<void> remove(int id) async {
    Cidade? c = _cache?.firstWhere((element) => element.id == id);
    if (c != null && c.id !=0) {
      if (await _service.remove(c)){
        _cache!.remove(c);
      }
    } else {
      throw Exception("Cidade vinculada a item.");
    }
  }

  Cidade getAt(int index) {
    if (_cache != null && index >= 0 && index < _cache!.length) {
      return _cache![index];
    }
    throw CidadeNotFound();
  }

  int getNumCidades() {
    return _cache?.length ?? 0;
  }
}