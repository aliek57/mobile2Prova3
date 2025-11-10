import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile2prova3/ui/viewmodels/ModeloViewModel.dart';
import 'package:provider/provider.dart';
import 'package:mobile2prova3/model/marca.dart';
import 'package:mobile2prova3/model/modelo.dart';

class TelaModelo extends StatefulWidget {
  const TelaModelo({super.key});

  @override
  State<TelaModelo> createState() => _TelaModeloState();
}

class _TelaModeloState extends State<TelaModelo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _tipoController;
  int? _marcaSelecionadaId;
  Future<void>? _loadData;
  StreamSubscription? _errorSubscription;

  late ModeloViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _tipoController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = Provider.of<ModeloViewModel>(context, listen: false);
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
    _nomeController.dispose();
    _tipoController.dispose();
    _errorSubscription?.cancel();
    super.dispose();
  }

  void _limparFormulario() {
    _nomeController.clear();
    _tipoController.clear();
    setState(() {
      _marcaSelecionadaId = null;
    });
    _viewModel.cancelar();
  }

  Widget _buildFormulario(ModeloViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome do Modelo',
              border: OutlineInputBorder(),
            ),
            validator: viewModel.validarNome,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Tipo',
              border: OutlineInputBorder(),
            ),
            value: _tipoController.text.isEmpty ? null : _tipoController.text,
            items: ['SEDAN', 'HATCH', 'SUV', 'CAMIONETE']
                .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                _tipoController.text = value;
              }
            },
            validator: (value) => viewModel.validarTipo(value),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            value: _marcaSelecionadaId,
            decoration: const InputDecoration(
              labelText: 'Marca',
              border: OutlineInputBorder(),
            ),
            items: List.generate(
              viewModel.numMarcas,
                  (index) {
                Marca marca = viewModel.getMarcaAt(index);
                return DropdownMenuItem(
                  value: marca.id,
                  child: Text(marca.nome),
                );
              },
            ),
            onChanged: (value) {
              setState(() {
                _marcaSelecionadaId = value;
              });
            },
            validator: (value) =>
            value == null ? 'Selecione uma marca' : null,
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
                      _nomeController.text,
                      _tipoController.text,
                      _marcaSelecionadaId!,
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

  Widget _buildItemLista(ModeloViewModel viewModel, int index) {
    Modelo modelo = viewModel.getAt(index);
    return ListTile(
      title: Text(modelo.nome),
      subtitle: Text('Tipo: ${modelo.tipo} - Marca: ${modelo.marca?.nome ?? 'N/A'}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              viewModel.edicao = modelo;
              _nomeController.text = modelo.nome;
              _tipoController.text = modelo.tipo;
              setState(() {
                _marcaSelecionadaId = modelo.idMarca;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              viewModel.remover(modelo.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLista(ModeloViewModel viewModel) {
    return Expanded(
      child: ListView.builder(
        itemCount: viewModel.numModelos,
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
        title: const Text('Gerenciar Modelos'),
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
              return Consumer<ModeloViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    children: [
                      _buildFormulario(viewModel),
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