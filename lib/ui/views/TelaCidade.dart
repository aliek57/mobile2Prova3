import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile2prova3/model/cidade.dart';
import 'package:mobile2prova3/ui/viewmodels/CidadeViewModel.dart';

class TelaCidade extends StatefulWidget {
  const TelaCidade({super.key});

  @override
  State<TelaCidade> createState() => _TelaCidadeState();
}

class _TelaCidadeState extends State<TelaCidade> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _dddController;
  Future<void>? _loadData;
  StreamSubscription? _errorSubscription;

  late CidadeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _dddController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = Provider.of<CidadeViewModel>(context, listen: false);
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
    _dddController.dispose();
    _errorSubscription?.cancel();
    super.dispose();
  }

  Widget _buildFormulario(CidadeViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome da Cidade',
              border: OutlineInputBorder(),
            ),
            validator: viewModel.validarNome,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _dddController,
            decoration: const InputDecoration(
              labelText: 'DDD',
              border: OutlineInputBorder(),
            ),
            validator: viewModel.validarDDD,
            keyboardType: TextInputType.number,
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
                      _dddController.text,
                    );
                    _nomeController.clear();
                    _dddController.clear();
                  }
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  viewModel.cancelar();
                  _nomeController.clear();
                  _dddController.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemLista(CidadeViewModel viewModel, int index) {
    Cidade cidade = viewModel.getAt(index);
    return ListTile(
      title: Text(cidade.nome),
      subtitle: Text('DDD: ${cidade.ddd}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              viewModel.edicao = cidade;
              _nomeController.text = cidade.nome;
              _dddController.text = cidade.ddd;
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              viewModel.remover(cidade.id ?? 0);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLista(CidadeViewModel viewModel) {
    return Expanded(
      child: ListView.builder(
        itemCount: viewModel.numCidades,
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
        title: const Text('Gerenciar Cidades'),
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
              return Consumer<CidadeViewModel>(
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