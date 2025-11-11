import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile2prova3/model/anuncio.dart';
import 'package:mobile2prova3/model/cidade.dart';
import 'package:mobile2prova3/model/modelo.dart';
import 'package:mobile2prova3/repository/AnuncioRepository.dart';
import 'package:mobile2prova3/repository/CidadeRepository.dart';
import 'package:mobile2prova3/repository/ModeloRepository.dart';

class AnuncioViewModel extends ChangeNotifier {

  final _snackbarController = StreamController<String>.broadcast();
  Stream<String> get errorStream => _snackbarController.stream;

  late AnuncioRepository _repo;
  late ModeloRepository _modeloRepo;
  late CidadeRepository _cidadeRepo;
  Anuncio? edicao;
  bool _jaInicializado = false;

  Future<void> conectar() async {
    if (!_jaInicializado) {
      _repo = AnuncioRepository.getInstance();
      _modeloRepo = ModeloRepository.getInstance();
      _cidadeRepo = CidadeRepository.getInstance();
      _jaInicializado = true;
    }

    await _repo.getAll();
    await _modeloRepo.getAll();
    await _cidadeRepo.getAll();
  }

  String? validarDescricao(String? valor) {
    if (valor == null || valor.length < 5) {
      return "Descrição muito curta";
    }
    return null;
  }

  String? validarValor(String? valor) {
    if (valor == null || valor.isEmpty || double.tryParse(valor) == null) {
      return "Valor inválido";
    }
    if (double.parse(valor) <= 0) {
      return "Valor deve ser positivo";
    }
    return null;
  }

  String? validarAno(String? valor) {
    if (valor == null || valor.isEmpty || int.tryParse(valor) == null) {
      return "Ano inválido";
    }
    if (int.parse(valor) < 1950) {
      return "Ano improvável";
    }
    return null;
  }

  String? validarKm(String? valor) {
    if (valor == null || valor.isEmpty || int.tryParse(valor) == null) {
      return "KM inválido";
    }
    if (int.parse(valor) < 0) {
      return "KM não pode ser negativa";
    }
    return null;
  }

  void confirmar(
      String descricao,
      double valor,
      int ano,
      int km,
      int idCidade,
      int idModelo) async {
    try {
      if (edicao == null) {
        await _repo.insert(
            Anuncio(0, descricao, valor, ano, km, idCidade, idModelo));
      } else {
        edicao!.descricao = descricao;
        edicao!.valor = valor;
        edicao!.ano = ano;
        edicao!.km = km;
        edicao!.idCidade = idCidade;
        edicao!.idModelo = idModelo;
        await _repo.update(edicao!);
      }
      edicao = null;
    } on Exception catch (ex) {
      _snackbarController.sink.add("Erro cadastrando anúncio: ${ex.toString()}");
    }
    notifyListeners();
  }

  int get numAnuncios => _repo.getNumAnuncios();
  Anuncio getAt(int idx) => _repo.getAt(idx);

  int get numModelos => _modeloRepo.getNumModelos();
  Modelo getModeloAt(int idx) => _modeloRepo.getAt(idx);

  int get numCidades => _cidadeRepo.getNumCidades();
  Cidade getCidadeAt(int idx) => _cidadeRepo.getAt(idx);

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