import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile2prova3/model/marca.dart';
import 'package:mobile2prova3/model/modelo.dart';
import 'package:mobile2prova3/repository/MarcaRepository.dart';
import 'package:mobile2prova3/repository/ModeloRepository.dart';

class ModeloViewModel extends ChangeNotifier {

  final _snackbarController = StreamController<String>.broadcast();
  Stream<String> get errorStream => _snackbarController.stream;

  late final ModeloRepository _repo;
  late final MarcaRepository _marcaRepo;
  Modelo? edicao;

  Future<void> conectar() async {
    _repo = ModeloRepository.getInstance();
    _marcaRepo = MarcaRepository.getInstance();

    await _repo.getAll();
    await _marcaRepo.getAll();
  }

  String? validarNome(String? nome) {
    if (nome == null || nome.length < 2) {
      return "Nome deve ter ao menos 2 caracteres";
    }
    return null;
  }

  String? validarTipo(String? tipo) {
    if (tipo == null || tipo.isEmpty) {
      return "Tipo não pode ser vazio";
    }
    return null;
  }

  void confirmar(String nome, String tipo, int idMarca) async {
    try {
      if (edicao == null) {
        await _repo.insert(Modelo(0, nome, tipo, idMarca));
      } else {
        edicao!.nome = nome;
        edicao!.tipo = tipo;
        edicao!.idMarca = idMarca;
        await _repo.update(edicao!);
      }
      edicao = null;
    } on Exception catch (ex) {
      _snackbarController.sink.add("Erro cadastrando modelo: ${ex.toString()}");
    }
    notifyListeners();
  }

  int get numModelos => _repo.getNumModelos();
  Modelo getAt(int idx) => _repo.getAt(idx);

  int get numMarcas => _marcaRepo.getNumMarcas();
  Marca getMarcaAt(int idx) => _marcaRepo.getAt(idx);

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