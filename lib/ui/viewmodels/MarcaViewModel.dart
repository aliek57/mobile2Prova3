import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile2prova3/model/marca.dart';
import 'package:mobile2prova3/repository/MarcaRepository.dart';

class MarcaViewModel extends ChangeNotifier {

  final _snackbarController = StreamController<String>.broadcast();
  Stream<String> get errorStream => _snackbarController.stream;

  late final MarcaRepository _repo;
  Marca? edicao;

  Future<void> conectar() async {
    _repo = MarcaRepository.getInstance();
    await _repo.getAll();
  }

  String? validarNome(String? nome) {
    if (nome == null || nome.length < 2) {
      return "Nome deve ter ao menos 2 caracteres";
    }
    return null;
  }

  void confirmar(String nome) async {
    try {
      if (edicao == null) {
        await _repo.insert(Marca(0, nome));
      } else {
        edicao!.nome = nome;
        await _repo.update(edicao!);
      }
      edicao = null;
    } on Exception catch (ex) {
      _snackbarController.sink.add("Erro cadastrando marca: ${ex.toString()}");
    }
    notifyListeners();
  }

  int get numMarcas => _repo.getNumMarcas();

  Marca getAt(int idx) {
    return _repo.getAt(idx);
  }

  void cancelar() {
    edicao = null;
    notifyListeners();
  }

  void remover(int id) async {
    await _repo.remove(id);
    notifyListeners();
  }

  @override
  void dispose() {
    _snackbarController.close();
    super.dispose();
  }
}