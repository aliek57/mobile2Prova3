import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile2prova3/model/marca.dart';
import 'package:mobile2prova3/ui/viewmodels/MarcaViewModel.dart';
import 'package:provider/provider.dart';

class TelaMarca extends StatefulWidget {
  const TelaMarca({super.key});

  @override
  State<TelaMarca> createState() => _TelaMarcaState();
}

class _TelaMarcaState extends State<TelaMarca> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  Future<void>? _loadData;
  StreamSubscription? _errorSubscription;

  late MarcaViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = Provider.of<MarcaViewModel>(context, listen: false);
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
    _errorSubscription?.cancel();
    super.dispose();
  }

  Widget _buildFormulario(MarcaViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome da Marca',
              border: OutlineInputBorder(),
            ),
            validator: viewModel.validarNome,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    viewModel.confirmar(_nomeController.text);
                    _nomeController.clear();
                  }
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  viewModel.cancelar();
                  _nomeController.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemLista(MarcaViewModel viewModel, int index) {
    Marca marca = viewModel.getAt(index);
    return ListTile(
      title: Text(marca.nome),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              viewModel.edicao = marca;
              _nomeController.text = marca.nome;
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              viewModel.remover(marca.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLista(MarcaViewModel viewModel) {
    return Expanded(
      child: ListView.builder(
        itemCount: viewModel.numMarcas,
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
        title: const Text('Gerenciar Marcas'),
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
              return Consumer<MarcaViewModel>(
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