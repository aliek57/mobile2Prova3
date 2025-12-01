import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile2prova3/model/cidade.dart';
import 'package:mobile2prova3/repository/CidadeRepository.dart';

class CidadeViewModel extends ChangeNotifier {

  final _snackbarController = StreamController<String>.broadcast();
  Stream<String> get errorStream => _snackbarController.stream;

  late CidadeRepository _repo;
  Cidade? edicao;
  bool _jaInicializado = false;

  Future<void> conectar() async {
    if (!_jaInicializado) {
      _repo = CidadeRepository.getInstance();
      _jaInicializado = true;
    }

    await _repo.getAll();
  }

  String? validarNome(String? nome) {
    if (nome == null || nome.length < 2) {
      return "Nome deve ter ao menos 2 caracteres";
    }
    return null;
  }

  String? validarDDD(String? ddd) {
    if (ddd == null || ddd.length < 2) {
      return "DDD deve ter ao menos 2 dígitos";
    }
    return null;
  }

  void confirmar(String nome, String ddd) async {
    try {
      if (edicao == null) {
        await _repo.insert(Cidade(0, nome, ddd));
      } else {
        edicao!.nome = nome;
        edicao!.ddd = ddd;
        await _repo.update(edicao!);
      }
      edicao = null;
    } on Exception catch (ex) {
      _snackbarController.sink.add("Erro cadastrando cidade: ${ex.toString()}");
    }
    notifyListeners();
  }

  int get numCidades => _repo.getNumCidades();

  Cidade getAt(int idx) {
    return _repo.getAt(idx);
  }

  void cancelar() {
    edicao = null;
    notifyListeners();
  }

  void remover(int id) async {
    try {
      await _repo.remove(id);
    } on Exception catch (ex) {
      _snackbarController.sink.add("Erro ao remover cidade: ${ex.toString()}");
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _snackbarController.close();
    super.dispose();
  }
}