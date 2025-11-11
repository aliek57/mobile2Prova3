import 'package:flutter/material.dart';
import 'package:mobile2prova3/model/anuncio.dart';
import 'package:mobile2prova3/model/modelo.dart';
import 'package:mobile2prova3/repository/ModeloRepository.dart';
import 'package:mobile2prova3/service/impl/anuncioRESTService.dart';

class BuscaViewModel extends ChangeNotifier {
  late ModeloRepository _modeloRepo;
  final AnuncioRESTService _anuncioService = AnuncioRESTService();

  List<Anuncio> resultados = [];
  bool carregando = false;
  bool _jaInicializado = false;

  Future<void> conectar() async {
    if (!_jaInicializado) {
      _modeloRepo = ModeloRepository.getInstance();
      _jaInicializado = true;
    }

    await _modeloRepo.getAll();
    notifyListeners();
  }

  Future<void> buscarAnuncios({
    int? modeloId,
    String? anoInicial,
    String? anoFinal,
    String? valorMin,
    String? valorMax,
  }) async {
    carregando = true;
    resultados = [];
    notifyListeners();

    try {
      resultados = await _anuncioService.buscar(
        modelo: modeloId,
        anoInicial: (anoInicial != null && anoInicial.isNotEmpty)
            ? int.tryParse(anoInicial)
            : null,
        anoFinal: (anoFinal != null && anoFinal.isNotEmpty)
            ? int.tryParse(anoFinal)
            : null,
        min: (valorMin != null && valorMin.isNotEmpty)
            ? double.tryParse(valorMin)
            : null,
        max: (valorMax != null && valorMax.isNotEmpty)
            ? double.tryParse(valorMax)
            : null,
      );
    } catch (e) {
      debugPrint("Erro na busca: $e");
    }

    carregando = false;
    notifyListeners();
  }

  int get numModelos => _modeloRepo.getNumModelos();
  Modelo getModeloAt(int idx) => _modeloRepo.getAt(idx);
}