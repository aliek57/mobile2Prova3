import 'package:mobile2prova3/errors/ErrorClasses.dart';
import 'package:mobile2prova3/model/modelo.dart';
import 'package:mobile2prova3/service/Service.dart';
import 'package:mobile2prova3/service/impl/modeloRESTService.dart';

class ModeloRepository {
  late final Service<Modelo> _service;
  List<Modelo>? _cache;

  static ModeloRepository? _instance;

  ModeloRepository._internal() {
    _service = ModeloRESTService();
  }

  static ModeloRepository getInstance() {
    _instance ??= ModeloRepository._internal();
    return _instance!;
  }

  Future<List<Modelo>> getAll() async {
    _cache ??= await _service.getAll();
    return _cache!;
  }

  Future<void> insert(Modelo modelo) async {
    Modelo novoModelo = await _service.insert(modelo);
    _cache?.add(novoModelo);
  }

  Future<bool> update(Modelo modelo) async {
    bool atualizou = await _service.update(modelo);
    return atualizou;
  }

  Future<void> remove(int id) async {
    Modelo? m = _cache?.firstWhere((element) => element.id == id, orElse: null);
    if (m != null && await _service.remove(m)) {
      _cache!.remove(m);
    }
  }

  Modelo getAt(int index) {
    if (_cache != null && index >= 0 && index < _cache!.length) {
      return _cache![index];
    }
    throw ModeloNotFound();
  }

  int getNumModelos() {
    return _cache?.length ?? 0;
  }
}