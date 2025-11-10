import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile2prova3/ui/viewmodels/AnuncioViewModel.dart';
import 'package:provider/provider.dart';
import 'package:mobile2prova3/model/anuncio.dart';
import 'package:mobile2prova3/model/cidade.dart';
import 'package:mobile2prova3/model/modelo.dart';

class TelaAnuncio extends StatefulWidget {
  const TelaAnuncio({super.key});

  @override
  State<TelaAnuncio> createState() => _TelaAnuncioState();
}

class _TelaAnuncioState extends State<TelaAnuncio> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  late TextEditingController _anoController;
  late TextEditingController _kmController;
  int? _modeloSelecionadoId;
  int? _cidadeSelecionadaId;

  Future<void>? _loadData;
  StreamSubscription? _errorSubscription;

  late AnuncioViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController();
    _valorController = TextEditingController();
    _anoController = TextEditingController();
    _kmController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = Provider.of<AnuncioViewModel>(context, listen: false);
    _loadData = _viewModel.conectar();

    _errorSubscription?.cancel();
    _errorSubscription = _viewModel.errorStream.listen((errorMessage) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    });
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _anoController.dispose();
    _kmController.dispose();
    _errorSubscription?.cancel();
    super.dispose();
  }

  void _limparFormulario() {
    _descricaoController.clear();
    _valorController.clear();
    _anoController.clear();
    _kmController.clear();
    setState(() {
      _modeloSelecionadoId = null;
      _cidadeSelecionadaId = null;
    });
    _viewModel.cancelar();
  }

  Widget _buildFormulario(AnuncioViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _descricaoController,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
            ),
            validator: viewModel.validarDescricao,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _valorController,
            decoration: const InputDecoration(
              labelText: 'Valor (R\$)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: viewModel.validarValor,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _anoController,
                  decoration: const InputDecoration(
                    labelText: 'Ano',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: viewModel.validarAno,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _kmController,
                  decoration: const InputDecoration(
                    labelText: 'KM',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: viewModel.validarKm,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            value: _modeloSelecionadoId,
            decoration: const InputDecoration(
              labelText: 'Modelo',
              border: OutlineInputBorder(),
            ),
            items: List.generate(
              viewModel.numModelos,
                  (index) {
                Modelo modelo = viewModel.getModeloAt(index);
                return DropdownMenuItem(
                  value: modelo.id,
                  child: Text(modelo.nome),
                );
              },
            ),
            onChanged: (value) {
              setState(() {
                _modeloSelecionadoId = value;
              });
            },
            validator: (value) =>
            value == null ? 'Selecione um modelo' : null,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            value: _cidadeSelecionadaId,
            decoration: const InputDecoration(
              labelText: 'Cidade',
              border: OutlineInputBorder(),
            ),
            items: List.generate(
              viewModel.numCidades,
                  (index) {
                Cidade cidade = viewModel.getCidadeAt(index);
                return DropdownMenuItem(
                  value: cidade.id,
                  child: Text(cidade.nome),
                );
              },
            ),
            onChanged: (value) {
              setState(() {
                _cidadeSelecionadaId = value;
              });
            },
            validator: (value) =>
            value == null ? 'Selecione uma cidade' : null,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    viewModel.confirmar(
                      _descricaoController.text,
                      double.parse(_valorController.text),
                      int.parse(_anoController.text),
                      int.parse(_kmController.text),
                      _cidadeSelecionadaId!,
                      _modeloSelecionadoId!,
                    );
                    _limparFormulario();
                  }
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: _limparFormulario,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemLista(AnuncioViewModel viewModel, int index) {
    Anuncio anuncio = viewModel.getAt(index);
    return ListTile(
      title: Text(anuncio.descricao),
      subtitle: Text('R\$ ${anuncio.valor.toStringAsFixed(2)} - Ano: ${anuncio.ano}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              viewModel.edicao = anuncio;
              _descricaoController.text = anuncio.descricao;
              _valorController.text = anuncio.valor.toString();
              _anoController.text = anuncio.ano.toString();
              _kmController.text = anuncio.km.toString();
              setState(() {
                _modeloSelecionadoId = anuncio.idModelo;
                _cidadeSelecionadaId = anuncio.idCidade;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              viewModel.remover(anuncio.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLista(AnuncioViewModel viewModel) {
    return Expanded(
      child: ListView.builder(
        itemCount: viewModel.numAnuncios,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: _buildItemLista(viewModel, index),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Anúncios'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else {
              return Consumer<AnuncioViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    children: [
                      SingleChildScrollView(
                        child: _buildFormulario(viewModel),
                      ),
                      const Divider(height: 20, thickness: 2),
                      _buildLista(viewModel),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}